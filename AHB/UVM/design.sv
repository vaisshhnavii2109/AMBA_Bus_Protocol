// Package definition
package ahb_state_pkg;
  `include "uvm_macros.svh"  // Include UVM macros inside the package
  typedef enum {IDLE, ACTIVE, WRITE_BURST, READ_BURST, AGAIN, LITTLE, OPERATION} state_e;

  // AHB transaction parameters
  parameter NON_SEQ = 4'b0000;
  parameter SEQ     = 4'b0001;
  parameter BUSY    = 4'b0010;
  parameter IDLE_TRANS = 4'b0011;
  parameter OKAY    = 4'b0100;
  parameter ERROR   = 4'b0101;
endpackage

// AHB Interface
interface ahb_if;
  logic [1:0] HSELx, HWRITE, HCLK, HRESETn;
  logic clk, reset;
  logic [31:0] HADDR, HWDATA, HRDATA;
  logic [1:0] HSIZE;
  logic [2:0] HBURST;
  logic [1:0] HTRANS;
  logic HMASTLOCK;
  logic HREADY;
  logic state;
  logic [1:0] HRESP;
  logic [4:0] local_addr;
  logic count;

  // Clocking block for master
  clocking master_cb @(posedge clk);
    input HRDATA, HMASTLOCK, HREADY, HRESP;
    output HWRITE, HRESETn, HSELx, HCLK, HADDR, HWDATA, HSIZE, HBURST, HTRANS;
  endclocking: master_cb

  // Modport for master
  modport master(clocking master_cb);
endinterface

// AHB RTL Slave Module
module ahb_rtl_slave_2(ahb_if sintf);
  import ahb_state_pkg::*;  // Import the package

  // Internal signals
  logic [31:0] memory_slave[0:99];  // Static array with fixed size
  state_e ps_slave1;
  state_e ns_slave1;
  reg [31:0] addr_buff;
  bit opcode;

  // Initialize memory_slave array
  initial begin
    foreach (memory_slave[i])
      memory_slave[i] = i;  // Initialize memory with index values
  end

  // State transition logic
  always_ff @(posedge sintf.clk or negedge sintf.HRESETn) begin
    if (!sintf.HRESETn)
      ps_slave1 <= IDLE;  // Reset to IDLE state
    else
      ps_slave1 <= ns_slave1;  // Transition to next state
  end

  // State machine logic
  always_ff @(posedge sintf.clk or negedge sintf.HRESETn) begin
    if (!sintf.HRESETn) begin
      ns_slave1 <= OPERATION;  // Default to OPERATION state on reset
    end else begin
      case (ps_slave1)
        IDLE: begin
          if (!sintf.HRESETn && sintf.HSELx == 0)
            ns_slave1 <= IDLE;  // Stay in IDLE if reset and HSELx is low
          else begin
            sintf.HREADY <= 1'b1;  // Set HREADY high
            sintf.local_addr <= 5'b0;  // Reset local address
            ns_slave1 <= OPERATION;  // Move to OPERATION state
          end
        end

        OPERATION: begin
          if (sintf.HTRANS == 2'b10 || sintf.HTRANS == 2'b11) begin
            if (opcode == 1'b1 && sintf.HWRITE == 2'b0 && addr_buff == sintf.HADDR)
              sintf.HRDATA <= sintf.HWDATA;  // Write data to HRDATA
            else if (sintf.HWRITE == 2'b0)
              sintf.HRDATA <= memory_slave[sintf.HADDR];  // Read data from memory
            else
              sintf.HRDATA <= 32'b0;  // Default HRDATA value
            addr_buff <= sintf.HADDR;  // Update address buffer
            opcode <= sintf.HWRITE;  // Update opcode
            ns_slave1 <= OPERATION;  // Stay in OPERATION state
            if (opcode == 1'b1) begin
              memory_slave[addr_buff] <= sintf.HWDATA;  // Write data to memory
            end
          end else begin
            sintf.HRESP <= OKAY;  // Set HRESP to OKAY
          end
        end

        ACTIVE: begin
          if (sintf.HRESETn && sintf.HSELx && sintf.HWRITE && sintf.HREADY) begin
            addr_buff <= sintf.HADDR;  // Update address buffer
            ns_slave1 <= WRITE_BURST;  // Move to WRITE_BURST state
          end else if (sintf.HRESETn && sintf.HSELx && !sintf.HWRITE && sintf.HREADY) begin
            addr_buff <= sintf.HADDR;  // Update address buffer
            ns_slave1 <= READ_BURST;  // Move to READ_BURST state
          end else begin
            ns_slave1 <= IDLE;  // Move to IDLE state
          end
        end

        AGAIN: begin
          if (sintf.HREADY)
            ns_slave1 <= ACTIVE;  // Move to ACTIVE state
          else
            ns_slave1 <= LITTLE;  // Move to LITTLE state
        end

        WRITE_BURST: begin
          if (sintf.HRESETn && sintf.HSELx && sintf.HWRITE) begin
            case (sintf.HBURST)
              3'b000: begin
                memory_slave[addr_buff] <= sintf.HWDATA;  // Write data to memory
                addr_buff <= sintf.HADDR;  // Update address buffer
                sintf.HRESP <= OKAY;  // Set HRESP to OKAY
                if (sintf.HWRITE == 2'b01)
                  ns_slave1 <= WRITE_BURST;  // Stay in WRITE_BURST state
                else
                  ns_slave1 <= READ_BURST;  // Move to READ_BURST state
              end
              // Other burst types...
            endcase
          end else begin
            sintf.HRESP <= ERROR;  // Set HRESP to ERROR
          end
        end

        READ_BURST: begin
          if (sintf.HRESETn && sintf.HSELx && !sintf.HWRITE) begin
            case (sintf.HBURST)
              3'b000: begin
                sintf.HRDATA <= 32'h0878754;  // Dummy read data
                addr_buff <= sintf.HADDR;  // Update address buffer
                if (sintf.HWRITE == 2'b01)
                  ns_slave1 <= WRITE_BURST;  // Move to WRITE_BURST state
                else
                  ns_slave1 <= READ_BURST;  // Stay in READ_BURST state
                sintf.HRESP <= OKAY;  // Set HRESP to OKAY
              end
              // Other burst types...
            endcase
          end else begin
            sintf.HRESP <= ERROR;  // Set HRESP to ERROR
          end
        end

        LITTLE: begin
          if (sintf.HMASTLOCK)
            ns_slave1 <= ACTIVE;  // Move to ACTIVE state
          else
            ns_slave1 <= IDLE;  // Move to IDLE state
        end
      endcase
    end
  end
endmodule