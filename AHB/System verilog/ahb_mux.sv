module mux(
    input [31:0] hrdata_1,
    input [31:0] hrdata_2,
    input hready_1,
    input hready_2,
    input [1:0] hresp_1,
    input [1:0] hresp_2,
    input [1:0] sel,
    output logic [31:0] hrdata,
    output logic hready,
    output logic [1:0] hresp
);

    always_comb begin
        case (sel)
            2'b01: begin
                hrdata = hrdata_1;
                hready = hready_1;
                hresp = hresp_1;
            end
            2'b10: begin
                hrdata = hrdata_2;
                hready = hready_2;
                hresp = hresp_2;
            end
            default: begin
                hrdata = 32'h0;
                hready = 1'b0;
                hresp = 2'b00; // OKAY response
            end
        endcase
    end

endmodule
