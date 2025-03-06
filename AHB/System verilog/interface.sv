interface ahb_if(input logic clk, input logic hresetn);
    logic [31:0] haddr;
    logic [31:0] hwdata;
    logic [31:0] hrdata;
    logic [2:0] hsize;
    logic [2:0] hburst;
    logic hwrite;
    logic [1:0] htrans;
    logic hready;
    logic [1:0] hresp;

    clocking driver_cb @(posedge clk);
        output haddr, hwdata, hsize, hburst, hwrite, htrans;
        input hready, hrdata, hresp;
    endclocking

    clocking monitor_cb @(posedge clk);
        input haddr, hwdata, hsize, hburst, hwrite, htrans, hready, hrdata, hresp;
    endclocking
endinterface
