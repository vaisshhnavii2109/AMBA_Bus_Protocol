module apb_slave_tb;

  reg pclk, presetn;
  reg psel, penable, pwrite;
  reg [7:0] paddr, pwdata;
  wire [7:0] prdata;
  wire pready;

  // Instantiate the DUT (Device Under Test)
  apb_slave dut (
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

  // Clock generation
  always #5 pclk = ~pclk;

  // Testbench logic
  initial begin
    // Initialize signals
    pclk = 0;
    presetn = 0;
    psel = 0;
    penable = 0;
    pwrite = 0;
    paddr = 8'h00;
    pwdata = 8'h00;

    // Apply reset
    #10 presetn = 1;

    // Test Case 1: Write Operation
    #10;
    psel = 1;
    penable = 0;
    pwrite = 1;
    paddr = 8'h10;  // Target memory address
    pwdata = 8'h55; // Data to write
    #10 penable = 1; // Enable signal
    #10 penable = 0; // Complete transaction

    // Test Case 2: Read Operation
    #20;
    psel = 1;
    penable = 0;
    pwrite = 0;
    paddr = 8'h10; // Target memory address
    #10 penable = 1; // Enable signal
    #10 penable = 0; // Complete transaction

    // Test Case 3: Write Operation to another address
    #20;
    psel = 1;
    penable = 0;
    pwrite = 1;
    paddr = 8'h20;  // New memory address
    pwdata = 8'hAA; // Data to write
    #10 penable = 1; // Enable signal
    #10 penable = 0; // Complete transaction

    // Test Case 4: Read from the new address
    #20;
    psel = 1;
    penable = 0;
    pwrite = 0;
    paddr = 8'h20; // Target memory address
    #10 penable = 1; // Enable signal
    #10 penable = 0; // Complete transaction

    // End simulation
    #30 $finish;
  end

endmodule

