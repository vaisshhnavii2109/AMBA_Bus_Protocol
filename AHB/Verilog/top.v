module top (
    input clk,
    input reset,
    input hready,
    input [1:0] control, // 2'b10 for write, 2'b01 for read
    input [31:0] hwdata, // Data to write
    input [31:0] haddr,  // Address
    output reg [31:0] hrdata, // Data read
    output reg hselx,
    output reg [3:0] hcount // Simple counter for operations
);
    // Memory for storing data
    reg [31:0] memory [0:15]; // 16 memory locations

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hcount <= 0;
            hselx <= 0;
            hrdata <= 0;
        end else if (hready) begin
            hcount <= hcount + 1;
            hselx <= 1;

            case (control)
                2'b10: // Write operation
                    memory[haddr] <= hwdata;

                2'b01: // Read operation
                    hrdata <= memory[haddr];

                default: // Idle or undefined
                    hrdata <= 32'b0;
            endcase
        end else begin
            hselx <= 0; // Deselected if not ready
        end
    end
endmodule
