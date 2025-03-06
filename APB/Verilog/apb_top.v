module apb_top(
  input pclk, prsetn, transfer, read, write,
  input [8:0] apb_write_paddr,
  input [7:0] apb_write_data,
  input [8:0] apb_read_paadr,
  output pslverr,
  output [7:0] apb_read_data_out);
  
  wire [7:0] pwdata, prdata, prdata1, prdata2;
  wire [8:0] paddr;
  wire pready, pready1, pready2, penable, psel1, psel2, pwrite;
  
  apb_master dut_master(
  apb_write_paddr, apb_read_paddr,
  apb_write_data, prdata,
  presetn, pclk, read, write, transfer, pready, state,
  psel1, psel2,
  penable,
  paddr, //address is 9 bits here as the the last bit is used to select the slave
  pwrite,
  pwdata, apb_read_data_out,
  pslverr);
  
  apb_slave dut_slave1 (
  pclk, presetn,
  psel, penable, pwrite,
  paddr,pwdata,
  prdata, 
  pready );
  
  apb_slave dut_slave2 (
  pclk, presetn,
  psel, penable, pwrite,
  paddr,pwdata,
  prdata, 
  pready );
  


endmodule
