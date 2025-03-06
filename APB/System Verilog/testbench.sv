`include "test.sv"
`include "apb_top.sv"

module testbench;
  logic pclk, presetn;
  intf i_intf(pclk, presetn);
  test t;

  // Clock generation
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk;
  end

  // Reset and test execution
  initial begin
    presetn = 0;  // Apply reset
    #10 presetn = 1;  // Release reset
    t = new(i_intf);  // Create test instance
    t.run();  // Run the test
  end

  initial begin
    #1000 $finish;  // End simulation
  end

  // Coverage collection
  covergroup cg @(posedge pclk);
    option.per_instance = 1;
    coverpoint i_intf.write_paddr;
    coverpoint i_intf.write_data;
    coverpoint i_intf.read_paddr;
    coverpoint i_intf.read;
    coverpoint i_intf.write;
    coverpoint i_intf.transfer;
    coverpoint i_intf.prdata;
    coverpoint i_intf.pslverr;
  endgroup

  cg cov = new();

  initial begin
    forever begin
      @(posedge pclk);
      cov.sample();
    end
  end

  // Assertions
  property pslverr_assertion;
    @(posedge pclk) disable iff (!presetn)
    (i_intf.pslverr) |-> (i_intf.penable && i_intf.psel);
  endproperty

  assert property (pslverr_assertion)
    else $error("PSLVERR asserted without valid transaction!");

  // Task to generate random values and perform write-read operations
  task automatic write_read_task;
    logic [7:0] write_addr, read_addr, write_data;
    int delay;

    forever begin
      // Generate random values for write address, write data, and read address
      write_addr = $urandom_range(0, 255);
      write_data = $urandom_range(0, 255);
      read_addr = write_addr;  // Read from the same address as write
      delay = $urandom_range(1, 10);  // Random delay between write and read

      // Perform write operation
      i_intf.write_paddr = write_addr;
      i_intf.write_data = write_data;
      i_intf.write = 1;
      i_intf.read = 0;  // Ensure read is low during write
      i_intf.transfer = 1;
      @(posedge pclk);
      i_intf.transfer = 0;
      i_intf.write = 0;
      @(posedge pclk);

      // Wait for a few clock cycles before performing read operation
      repeat (delay) @(posedge pclk);

      // Perform read operation
      i_intf.write_paddr = read_addr;
      i_intf.write = 0;  // Ensure write is low during read
      i_intf.read = 1;
      i_intf.transfer = 1;
      @(posedge pclk);
      i_intf.transfer = 0;
      i_intf.read = 0;
      @(posedge pclk);

      // Verify read data matches written data
      if (i_intf.prdata === write_data) begin
        $display("[SUCCESS] Read Data: %h matches Write Data: %h at Address: %h",
                 i_intf.prdata, write_data, read_addr);
      end else begin
        $error("[ERROR] Read Data: %h does not match Write Data: %h at Address: %h",
               i_intf.prdata, write_data, read_addr);
      end
    end
  endtask

  // Start the write-read task
  initial begin
    #20;  // Wait for reset to complete
    write_read_task();
  end

  // Instantiate the top module
  apb_top uut (
    .pclk(pclk),
    .presetn(presetn),
    .apb_write_paddr(i_intf.write_paddr),
    .apb_read_paddr(i_intf.read_paddr),
    .apb_write_data(i_intf.write_data),
    .read(i_intf.read),
    .write(i_intf.write),
    .transfer(i_intf.transfer),
    .apb_read_data_out(i_intf.apb_read_data_out),
    .pslverr(i_intf.pslverr)
  );
endmodule
