module decoder (
    input [31:0] haddr,
    output reg [2:0] hsel
);

    always @(*) begin
        case (haddr[31:30]) // Example address range decoding
            2'b00: hsel = 3'b001;
            2'b01: hsel = 3'b010;
            2'b10: hsel = 3'b100;
            default: hsel = 3'b000;
        endcase
    end
endmodule

