// Code your testbench here
// or browse Examples
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "ahb_tb_package.sv"

module top;

  ahb_if ahb_intf();
  ahb_rtl_slave_2 dut(.sintf(ahb_intf));

  initial begin
    uvm_config_db#(virtual ahb_if)::set(null,"*","dut_vif",ahb_intf);
  end

  // Clock generation
  always begin
    #5 ahb_intf.clk = ~ahb_intf.clk;
  end

  // Reset generation
  initial begin
    ahb_intf.HRESETn = 0;
    ahb_intf.clk = 0;

    #10 ahb_intf.HRESETn = 1;
  end

  // Run the test
  initial begin
    run_test("ahb_test");
  end

  // VCD file dumping
  initial begin
    $dumpfile("dump.vcd");  // Specify the VCD file name
    $dumpvars(0, top);      // Dump all signals in the top module
  end

  // Add a delay to allow the simulation to run for a while
  initial begin
    #1000;  // Adjust the delay as needed
    $finish; // End the simulation after the delay
  end

endmodule