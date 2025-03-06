
module tb_top;
    reg clk, reset, hready;
    reg [1:0] control;
    reg [31:0] hwdata;   // Data to write
    reg [31:0] haddr;    // Address
    wire [31:0] hrdata;  // Data read
    wire [3:0] hcount;   // Operation count
    wire hselx;          // Slave select signal

    // Instantiate the top module
    top uut (
        .clk(clk),
        .reset(reset),
        .hready(hready),
        .control(control),
        .hwdata(hwdata),
        .haddr(haddr),
        .hrdata(hrdata),
        .hcount(hcount),
        .hselx(hselx)
    );

    // Clock generation (10ns clock period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Testbench logic
    initial begin
        // Initialize signals
        reset = 1;
        hready = 0;
        control = 2'b00; // Idle
        hwdata = 0;
        haddr = 0;

        // Reset sequence
        #20 reset = 0;

        // Write to address 5
        #30 hready = 1; 
        control = 2'b10; 
        haddr = 5; 
        hwdata = 32'hABCDEFAB;

        // Delay for visibility
        #40 hready = 0;

        // Read from address 5
        #30 hready = 1; 
        control = 2'b01; 
        haddr = 5;

        // Write to address 8
        #50 hready = 1; 
        control = 2'b10; 
        haddr = 8; 
        hwdata = 32'hEABCFDED;

        // Read from address 8
        #40 hready = 1; 
        control = 2'b01; 
        haddr = 8;

        // Idle state
        #50 control = 2'b00;
        hready = 0;

        #100 $stop; // End of simulation
    end
endmodule
