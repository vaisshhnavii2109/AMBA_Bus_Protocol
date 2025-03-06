module apb_top_tb;

  reg pclk, presetn, transfer, read, write;
  reg [8:0] apb_write_paddr, apb_read_paddr;
  reg [7:0] apb_write_data;
  wire pslverr;
  wire [7:0] apb_read_data_out;

  apb_top dut (
    .pclk(pclk),
    .prsetn(presetn),
    .transfer(transfer),
    .read(read),
    .write(write),
    .apb_write_paddr(apb_write_paddr),
    .apb_write_data(apb_write_data),
    .apb_read_paadr(apb_read_paddr),
    .pslverr(pslverr),
    .apb_read_data_out(apb_read_data_out)
  );

  // Clock generation
  always #5 pclk = ~pclk;

  initial begin
    // Initialize signals
    pclk = 0;
    presetn = 0;
    transfer = 0;
    read = 0;
    write = 0;
    apb_write_paddr = 0;
    apb_write_data = 0;
    apb_read_paddr = 0;

    // Apply reset
    #10 presetn = 1;

    // Test Case 1: Write to Slave 1
    #20;
    transfer = 1;
    write = 1;
    read = 0;
    apb_write_paddr = 9'b000000001; // Address mapped to Slave 1
    apb_write_data = 8'hA5;        // Example data to write
    #20;
    transfer = 0;
    write = 0;

    // Test Case 2: Read from Slave 1
    #30;
    transfer = 1;
    write = 0;
    read = 1;
    apb_read_paddr = 9'b000000001; // Address mapped to Slave 1
    #20;
    transfer = 0;
    read = 0;

    // Test Case 3: Write to Slave 2
    #40;
    transfer = 1;
    write = 1;
    read = 0;
    apb_write_paddr = 9'b000000010; // Address mapped to Slave 2
    apb_write_data = 8'h5A;        // Example data to write
    #20;
    transfer = 0;
    write = 0;

    // Test Case 4: Read from Slave 2
    #50;
    transfer = 1;
    write = 0;
    read = 1;
    apb_read_paddr = 9'b000000010; // Address mapped to Slave 2
    #20;
    transfer = 0;
    read = 0;

    // End simulation
    #100 $finish;
  end

endmodule
