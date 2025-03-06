module decoder(
    input [31:0] haddr,
    output logic [1:0] hsel
);

    // Simple address decoding logic
    assign hsel = (haddr < 32'h1000) ? 2'b01 : 2'b10;

endmodule
