module ahb_master (
    input clk,
    input reset,
    input hready,
    input [1:0] control, // 00: IDEAL, 01: READ, 10: WRITE
    output reg [31:0] haddr,
    output reg [2:0] hsize,
    output reg [31:0] hwdata,
    output reg hwrite
);

    reg [1:0] state, next_state;

    localparam IDEAL = 2'b00, READ = 2'b01, WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDEAL;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDEAL: if (control == WRITE) next_state = WRITE;
                   else if (control == READ) next_state = READ;
            READ: if (hready) next_state = IDEAL;
            WRITE: if (hready) next_state = IDEAL;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            haddr <= 32'b0;
            hsize <= 3'b0;
            hwdata <= 32'b0;
            hwrite <= 1'b0;
        end else if (state == WRITE && hready) begin
            haddr <= haddr + 32'h4; // Increment address
            hwdata <= hwdata + 1;  // Example data increment
            hwrite <= 1'b1;
        end else if (state == READ && hready) begin
            haddr <= haddr + 32'h4; // Increment address
            hwrite <= 1'b0;
        end
    end
endmodule

