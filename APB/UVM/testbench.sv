// Code your testbench here
// or browse Examples
import uvm_pkg::*;
`include"uvm_macros.svh"
`include"apb_packet.sv"
`include"apb_read_sequence.sv"
`include"apb_write_sequence.sv"
`include"apb_main_seq.sv"

`include"apb_drive.sv"
`include"apb_moni.sv"
`include"apb_agent.sv"
`include"apb_scbd.sv"
`include"apb_environment.sv"
`include"apb_basetest.sv"
module test;
  dutintf intf1();
  apb_slave dut0(.dif (intf1));
  initial begin
    intf1.clk = 0;
  forever #5 intf1.clk=~intf1.clk;
  end
  initial begin
    uvm_config_db#(virtual dutintf)::set(null,"*","dut_vif",intf1);
    run_test("base_test");
  end
  initial begin
    $dumpfile("this.vcd");
    $dumpvars(0,test);
  end
endmodule
