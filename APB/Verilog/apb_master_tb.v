`timescale 1ns/1ps

module apb_master_tb;

  // Inputs to the DUT
  reg [7:0] apb_write_paddr, apb_read_paddr;
  reg [7:0] apb_write_data, prdata;
  reg presetn, pclk, read, write, transfer, pready, state;

  // Outputs from the DUT
  wire psel1, psel2, pslverr;
  wire [8:0] paddr; 
  wire [7:0] pwdata, apb_read_data_out;
  wire penable, pwrite;

  // Instantiate the DUT (Device Under Test)
  apb_master uut (
    .apb_write_paddr(apb_write_paddr),
    .apb_read_paddr(apb_read_paddr),
    .apb_write_data(apb_write_data),
    .prdata(prdata),
    .presetn(presetn),
    .pclk(pclk),
    .read(read),
    .write(write),
    .transfer(transfer),
    .pready(pready),
    .state(state),
    .psel1(psel1),
    .psel2(psel2),
    .penable(penable),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .apb_read_data_out(apb_read_data_out),
    .pslverr(pslverr)
  );

  // Clock generation
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk; // Clock with 10ns period
  end

  // Test Stimuli
  initial begin
    // Initialize all inputs
    apb_write_paddr = 8'd0;
    apb_read_paddr = 8'd0;
    apb_write_data = 8'd0;
    prdata = 8'd0;
    presetn = 0;
    read = 0;
    write = 0;
    transfer = 0;
    pready = 0;
    state = 0;

    // Apply reset
    #10 presetn = 1; // Release reset
    #10;

    // Test case 1: Idle State
    $display("Test Case 1: Idle State");
    transfer = 0;
    #20;
    if (penable == 0 && uut.present_state == uut.idle)
      $display("PASS: Idle state");
    else
      $display("FAIL: Idle state");

    // Test case 2: Setup State with Write
    $display("Test Case 2: Setup State with Write");
    transfer = 1;
    write = 1;
    apb_write_paddr = 8'hAA;
    apb_write_data = 8'h55;
    #20;
    if (uut.present_state == uut.setup && paddr == 8'hAA && pwdata == 8'h55)
      $display("PASS: Setup state with write");
    else
      $display("FAIL: Setup state with write");

    // Test case 3: Setup State with Read
    $display("Test Case 3: Setup State with Read");
    write = 0;
    read = 1;
    apb_read_paddr = 8'hBB;
    #20;
    if (uut.present_state == uut.setup && paddr == 8'hBB)
      $display("PASS: Setup state with read");
    else
      $display("FAIL: Setup state with read");

    // Test case 4: Enable State with Read
    $display("Test Case 4: Enable State with Read");
    pready = 1;
    prdata = 8'hFF;
    #20;
    if (uut.present_state == uut.enable && apb_read_data_out == 8'hFF)
      $display("PASS: Enable state with read");
    else
      $display("FAIL: Enable state with read");

    // Test case 5: Error Condition
    $display("Test Case 5: Error Condition");
    apb_write_data = 8'dx; // Invalid write data
    #20;
    if (pslverr)
      $display("PASS: Error condition detected");
    else
      $display("FAIL: Error condition detected");

    // Finish simulation
    $stop;
  end

endmodule

