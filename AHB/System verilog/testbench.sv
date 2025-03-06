`include "test.sv"
`include "ahb_top.sv"
`include "interface.sv"  // Include the interface file

module testbench;
    logic pclk, presetn;
    logic hclk, hresetn, sel;
    logic [31:0] out_hrdata;
    logic hresp;
    logic [15:0] haddr;    // Address
    logic [1:0]  htrans;   // Transfer control
    logic [2:0]  hsize;    // Transfer size
    logic        hwrite;   // Write control
    logic [31:0] hwdata;   // Write data
    logic        hready;   // Transfer phase done

    // Instantiate the interface
    ahb_if vif(pclk, presetn);

    // Instantiate the test
    test t;

    // Assign interface signals to internal signals
    assign vif.hwdata = hwdata;
    assign vif.haddr = haddr;
    assign vif.hsize = hsize;
    assign vif.hburst = 3'b000; // Example value for hburst
    assign vif.hwrite = hwrite;
    assign vif.htrans = htrans;
    assign out_hrdata = vif.hrdata;
    assign hready = vif.hready;
    assign hresp = vif.hresp;

    // Instantiate DUT
    ahb_top dut(
        .clk(hclk),
        .hresetn(hresetn),
        .enable(1'b1),
        .hwdata(hwdata),
        .haddr(haddr),
        .hsize(hsize),
        .hburst(3'b000), // Example value for hburst
        .hwrite(hwrite),
        .htrans(htrans),
        .out_hrdata(out_hrdata),
        .hready(hready),
        .hresp(hresp)
    );

    initial begin
        $dumpfile("jay.vcd");
        $dumpvars();
        hclk = 1;
        forever #5 hclk = ~hclk;
    end

    initial begin
        hresetn = 1;
        hwrite = 0;
        haddr = 0;
        hwdata = 0;
        hready = 0;
        htrans = 0;
        hsize = 0;
        sel = 0;
        #10;
        hresetn = 0;
        sel = 1;
        #10;
        hready = 1;
        #10;
        hwrite = 1;
        htrans[1] = 1;
        haddr = 104;
        hwdata = {4{8'b10110001}};
        #10;
        hwrite = 0;
        hsize = 1;
        #10;
        hwrite = 1;
        haddr = 108;
        hwdata = {4{8'b10111101}};
        #10;
        hwrite = 0;
        hsize = 1;
        #10;
        hwrite = 1;
        haddr = 212;
        hwdata = 32'b10101010101010101010100000001010;
        #10;
        hwrite = 0;
        hsize = 1;
        #10;
        hwrite = 1;
        haddr = 220;
        hwdata = 32'b10101010111111111111111111111010;
        #10;
        hwrite = 0;
        hsize = 1;
        #10;
        hwrite = 1;
        haddr = 228;
        hwdata = 32'b10111111111111111111111111111010;
        #10;
        hwrite = 0;
        hsize = 1;
        #10;
        $stop;
    end
endmodule
