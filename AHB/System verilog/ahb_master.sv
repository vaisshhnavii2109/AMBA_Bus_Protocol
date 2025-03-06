module ahb_master(
    input clk,
    input hresetn,
    input enable,
    input [31:0] in_hwdata,
    input [31:0] in_haddr,
    input [2:0] in_hsize,
    input [2:0] in_hburst,
    input in_hwrite,
    input [1:0] in_htrans,
    output logic [31:0] hrdata, // Internal signal
    output logic hready,        // Internal signal
    output logic [1:0] hresp    // Internal signal
);
    // Internal state machine
    typedef enum {IDLE, WRITE, READ} state_e;
    state_e current_state, next_state;

    // Internal signals
    logic [31:0] haddr;
    logic [31:0] hwdata;
    logic [2:0] hsize;
    logic [2:0] hburst;
    logic hwrite;
    logic [1:0] htrans;
    logic [7:0] count; // Burst counter

    // State transition logic
    always_ff @(posedge clk or negedge hresetn) begin
        if (!hresetn) begin
            current_state <= IDLE;
            count <= 8'h0;
        end else begin
            current_state <= next_state;
            if (current_state == WRITE || current_state == READ) begin
                count <= count + 1;
            end else begin
                count <= 8'h0;
            end
        end
    end

    // State machine logic
    always_comb begin
        next_state = current_state; // Default to current state
        case (current_state)
            IDLE: begin
                if (enable && in_htrans == 2'b10) begin // NON_SEQ transaction
                    if (in_hwrite) begin
                        next_state = WRITE;
                    end else begin
                        next_state = READ;
                    end
                end
            end

            WRITE: begin
                if (count == in_hburst) begin
                    next_state = IDLE;
                end
            end

            READ: begin
                if (count == in_hburst) begin
                    next_state = IDLE;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always_ff @(posedge clk or negedge hresetn) begin
        if (!hresetn) begin
            hready <= 1'b0;
            hresp <= 2'b00; // OKAY response
            hrdata <= 32'h0;
        end else begin
            case (current_state)
                IDLE: begin
                    hready <= 1'b0;
                    hresp <= 2'b00; // OKAY response
                end

                WRITE: begin
                    hready <= (count == in_hburst) ? 1'b1 : 1'b0;
                    hresp <= 2'b00; // OKAY response
                end

                READ: begin
                    hready <= (count == in_hburst) ? 1'b1 : 1'b0;
                    hrdata <= in_hwdata; // Sample data during read
                    hresp <= 2'b00; // OKAY response
                end

                default: begin
                    hready <= 1'b0;
                    hresp <= 2'b00; // OKAY response
                end
            endcase
        end
    end

    // Drive address and control signals
    always_ff @(posedge clk or negedge hresetn) begin
        if (!hresetn) begin
            haddr <= 32'h0;
            hwdata <= 32'h0;
            hsize <= 3'b0;
            hburst <= 3'b0;
            hwrite <= 1'b0;
            htrans <= 2'b0;
        end else if (enable) begin
            haddr <= in_haddr;
            hwdata <= in_hwdata;
            hsize <= in_hsize;
            hburst <= in_hburst;
            hwrite <= in_hwrite;
            htrans <= in_htrans;
        end
    end

endmodule
