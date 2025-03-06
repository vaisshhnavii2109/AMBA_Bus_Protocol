module ahb_top(
    input clk,
    input hresetn,
    input enable,
    input [31:0] in_hwdata,
    input [31:0] in_haddr,
    input [2:0] in_hsize,
    input [2:0] in_hburst,
    input in_hwrite,
    input [1:0] in_htrans,
    output logic [31:0] out_hrdata,
    output logic hready,
    output logic [1:0] hresp
);

    // Internal signals
    logic [31:0] hrdata_1, hrdata_2; // Slave outputs
    logic hready_1, hready_2;        // Slave ready signals
    logic [1:0] hresp_1, hresp_2;    // Slave response signals
    logic [1:0] hsel;                // Decoder output

    // Internal signals for master and mux outputs
    logic [31:0] master_hrdata;      // Master hrdata output
    logic master_hready;             // Master hready output
    logic [1:0] master_hresp;        // Master hresp output

    logic [31:0] mux_hrdata;         // Mux hrdata output
    logic mux_hready;                // Mux hready output
    logic [1:0] mux_hresp;           // Mux hresp output

    // Instantiate Master
    ahb_master master_inst(
        .clk(clk),
        .hresetn(hresetn),
        .enable(enable),
        .in_hwdata(in_hwdata),
        .in_haddr(in_haddr),
        .in_hsize(in_hsize),
        .in_hburst(in_hburst),
        .in_hwrite(in_hwrite),
        .in_htrans(in_htrans),
        .hrdata(master_hrdata), // Master drives internal hrdata
        .hready(master_hready), // Master drives internal hready
        .hresp(master_hresp)    // Master drives internal hresp
    );

    // Instantiate Decoder
    decoder decoder_inst(
        .haddr(in_haddr),
        .hsel(hsel)
    );

    // Instantiate Slave 1
    ahb_slave slave_1(
        .clk(clk),
        .hresetn(hresetn),
        .hwdata(in_hwdata),
        .haddr(in_haddr),
        .hsize(in_hsize),
        .hburst(in_hburst),
        .hwrite(in_hwrite & hsel[0]), // Only write if hsel[0] is active
        .htrans(in_htrans),
        .hrdata(hrdata_1),
        .hready(hready_1),
        .hresp(hresp_1)
    );

    // Instantiate Slave 2 (dummy, not used in this example)
    ahb_slave slave_2(
        .clk(clk),
        .hresetn(hresetn),
        .hwdata(in_hwdata),
        .haddr(in_haddr),
        .hsize(in_hsize),
        .hburst(in_hburst),
        .hwrite(in_hwrite & hsel[1]), // Only write if hsel[1] is active
        .htrans(in_htrans),
        .hrdata(hrdata_2),
        .hready(hready_2),
        .hresp(hresp_2)
    );

    // Instantiate Multiplexer
    mux mux_inst(
        .hrdata_1(hrdata_1),
        .hrdata_2(hrdata_2),
        .hready_1(hready_1),
        .hready_2(hready_2),
        .hresp_1(hresp_1),
        .hresp_2(hresp_2),
        .sel(hsel),
        .hrdata(mux_hrdata), // Mux drives internal hrdata
        .hready(mux_hready), // Mux drives internal hready
        .hresp(mux_hresp)    // Mux drives internal hresp
    );

    // Merge master and mux outputs using basic gates
    assign out_hrdata = master_hrdata | mux_hrdata; // OR gate for hrdata
    assign hready = master_hready | mux_hready;     // OR gate for hready
    assign hresp = master_hresp | mux_hresp;        // OR gate for hresp

endmodule
