module apb_slave(
  input  logic pclk, presetn,
  input  logic psel, penable, pwrite,
  input  logic [7:0] paddr, pwdata,
  output logic [7:0] prdata,
  output logic pready
);

  logic [7:0] mem[256];  // Memory array for the slave

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      pready <= 1'b0;
      prdata <= 8'b0;
    end else if (psel && penable) begin
      if (pwrite) begin
        mem[paddr] <= pwdata;  // Write operation
        pready <= 1'b1;
      end else begin
        prdata <= mem[paddr];  // Read operation
        pready <= 1'b1;
      end
    end else begin
      pready <= 1'b0;
    end
  end
endmodule
