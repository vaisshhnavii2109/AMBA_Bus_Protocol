// Code your design here
interface dutintf;
  logic clk;
  logic rst_n;
  logic [7:0] paddr;
  logic pwrite;
  logic penable;
  logic psel;
  logic [31:0] prdata;
  logic [31:0] pwdata;
endinterface

module apb_slave(dutintf dif);
  logic [31:0] mem [256];
logic [1:0] apb_st;
const logic [1:0] SETUP = 0;
const logic [1:0] W_ENABLE = 1;
const logic [1:0] R_ENABLE = 2;
// SETUP -> ENABLE
  always @(negedge dif.rst_n or posedge dif.clk) begin
  if (dif.rst_n == 0) begin
    apb_st <= 0;
    dif.prdata <= 0;
    foreach(mem[i]) mem[i]=0;
   // $display("[%0t]system reset success",$time);
  end
  else begin
    case (apb_st)
      SETUP : begin
     //   $display("[%0t]DUTWRITEFROMSETUP,pwdata of %h written to mem[%h] so %0h",$time,dif.pwdata,dif.paddr,mem[dif.paddr]);
        // clear the prdata
        dif.prdata <= 0;
        // Move to ENABLE when the psel is asserted
        if (dif.psel && !dif.penable) begin
          if (dif.pwrite) begin
            apb_st <= W_ENABLE;
       //     $display("[%0t]DUT,sending to WR case",$time);
          end
          else begin
            apb_st <= R_ENABLE;
         //   $display("[%0t]DUT,sending to RD case",$time); 
          end
        end
      end
      W_ENABLE : begin
        //$display("[%0t]DUT,In WRITRE Case now",$time);
        // write pwdata to memory/
        if (dif.psel && dif.penable && dif.pwrite) begin
          mem[dif.paddr] <= dif.pwdata;
          //$display("[%0t]DUTWRITE,pwdata of %h written to mem[%h] so %0h",$time,dif.pwdata,dif.paddr,mem[dif.paddr]);
        end
        // return to SETUP
        apb_st <= SETUP;
        
      end
      R_ENABLE : begin
        //$display("[%0t]DUT,In READ Case now",$time);
        // read prdata from memory
        if (dif.psel && dif.penable && !dif.pwrite) begin
          dif.prdata <= mem[dif.paddr];
          //$display("[%0t]DUTREAD,read from dut is %h at paddr = %h",$time,dif.prdata,dif.paddr);
        end
        // return to SETUP
        apb_st <= SETUP;
      end
    endcase
  end
end
endmodule
