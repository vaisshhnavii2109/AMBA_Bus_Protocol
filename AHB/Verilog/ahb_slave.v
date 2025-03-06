module slave (
    input [31:0] hwdata,
    input hwrite,
    input hsel,
    output reg [31:0] hrdata
);

    reg [31:0] mem;

    always @(posedge hwrite) begin
        if (hsel && hwrite)
            mem <= hwdata; // Write operation
    end

    always @(*) begin
        if (hsel && !hwrite)
            hrdata = mem; // Read operation
        else
            hrdata = 32'b0;
    end
endmodule

