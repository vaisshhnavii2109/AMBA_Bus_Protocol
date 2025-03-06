module ahb_slave(
    input clk,
    input hresetn,
    input [31:0] hwdata,
    input [31:0] haddr,
    input [2:0] hsize,
    input [2:0] hburst,
    input hwrite,
    input [1:0] htrans,
    output logic [31:0] hrdata,
    output logic hready,
    output logic [1:0] hresp
);

    // Internal memory
    logic [31:0] memory[0:255]; // 256 x 32-bit memory

    // Internal signals
    logic [7:0] count; // Burst counter
    logic [31:0] addr_buff; // Address buffer

    // Initialize memory
    initial begin
        foreach (memory[i]) begin
            memory[i] = i; // Initialize memory with address values
        end
    end

    // State machine for handling AHB transactions
    always_ff @(posedge clk or negedge hresetn) begin
        if (!hresetn) begin
            hrdata <= 32'h0;
            hready <= 1'b0;
            hresp <= 2'b00; // OKAY response
            count <= 8'h0;
            addr_buff <= 32'h0;
        end else begin
            if (htrans == 2'b10 || htrans == 2'b11) begin // NON_SEQ or SEQ transaction
                if (hwrite == 1'b0) begin // Read transaction
                    if (count != hburst) begin // Burst not complete
                        hrdata <= memory[haddr + count]; // Read data from memory
                        count <= count + 1; // Increment burst counter
                        hready <= 1'b1; // Slave is ready
                        hresp <= 2'b00; // OKAY response
                    end else begin // Burst complete
                        hready <= 1'b0; // Slave is not ready
                        hresp <= 2'b00; // OKAY response
                        count <= 8'h0; // Reset burst counter
                    end
                end else begin // Write transaction (not handled in this example)
                    hready <= 1'b1; // Slave is ready
                    hresp <= 2'b00; // OKAY response
                end
            end else begin // IDLE or BUSY transaction
                hready <= 1'b0; // Slave is not ready
                hresp <= 2'b00; // OKAY response
            end
        end
    end

endmodule
