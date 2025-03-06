interface intf(input logic pclk, input logic presetn);
  logic [7:0] write_paddr;
  logic [7:0] write_data;
  logic [7:0] read_paddr;
  logic transfer;
  logic read;
  logic write;
  logic [7:0] prdata;
  logic pslverr;
  logic psel;
  logic penable;
  logic [7:0] paddr;
  logic pwrite;
  logic [7:0] pwdata;
  logic [7:0] apb_read_data_out;
  logic pready;
endinterface
