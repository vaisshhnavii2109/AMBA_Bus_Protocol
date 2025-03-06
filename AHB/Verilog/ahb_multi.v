
module multiplexer (
    input [31:0] hrdata1,
    input [31:0] hrdata2,
    input [31:0] hrdata3,
    input [2:0] hsel,
    output reg [31:0] hrdata
);

    always @(*) begin
        case (hsel)
            3'b001: hrdata = hrdata1;
            3'b010: hrdata = hrdata2;
            3'b100: hrdata = hrdata3;
            default: hrdata = 32'b0;
        endcase
    end
endmodule
