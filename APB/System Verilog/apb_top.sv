module apb_top(
  input  logic pclk, presetn,
  input  logic [7:0] apb_write_paddr, apb_read_paddr,
  input  logic [7:0] apb_write_data,
  input  logic read, write, transfer,
  output logic [7:0] apb_read_data_out,
  output logic pslverr
);

  logic psel, penable, pwrite;
  logic [7:0] paddr, pwdata, prdata;
  logic pready;

  // Instantiate APB Master
  apb_master master (
    .pclk(pclk),
    .presetn(presetn),
    .apb_write_paddr(apb_write_paddr),
    .apb_read_paddr(apb_read_paddr),
    .apb_write_data(apb_write_data),
    .read(read),
    .write(write),
    .transfer(transfer),
    .prdata(prdata),
    .pready(pready),
    .pslverr(pslverr),
    .psel(psel),
    .penable(penable),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .apb_read_data_out(apb_read_data_out)
  );

  // Instantiate APB Slave
  apb_slave slave (
    .pclk(pclk),
    .presetn(presetn),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready)
  );
endmodule
