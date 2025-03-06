module apb_master(
  input  logic pclk, presetn,
  input  logic [7:0] apb_write_paddr, apb_read_paddr,
  input  logic [7:0] apb_write_data,
  input  logic read, write, transfer,
  input  logic [7:0] prdata,
  input  logic pready, pslverr,
  output logic psel,
  output logic penable,
  output logic [7:0] paddr,
  output logic pwrite,
  output logic [7:0] pwdata,
  output logic [7:0] apb_read_data_out
);

  typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;
  state_t present_state, next_state;

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) present_state <= IDLE;
    else present_state <= next_state;
  end

  always_comb begin
    next_state = present_state;
    penable = 1'b0;
    psel = 1'b0;
    pwrite = 1'b0;
    paddr = 8'b0;
    pwdata = 8'b0;
    apb_read_data_out = 8'b0;

    case (present_state)
      IDLE: begin
        if (transfer) next_state = SETUP;
      end

      SETUP: begin
        if (read && !write) begin
          paddr = apb_read_paddr;  // Read address
          psel = 1'b1;
        end else if (!read && write) begin
          paddr = apb_write_paddr;  // Write address
          psel = 1'b1;
          pwrite = 1'b1;
          pwdata = apb_write_data;
        end
        next_state = ACCESS;
      end

      ACCESS: begin
        penable = 1'b1;
        if (pready) begin
          if (read && !write) apb_read_data_out = prdata;
          next_state = IDLE;
        end else begin
          next_state = ACCESS;
        end
      end
    endcase
  end

 /* // Assertions
  property pslverr_assertion;
    @(posedge pclk) disable iff (!presetn)
    (pslverr) |-> (penable && psel);
  endproperty

  assert property (pslverr_assertion)
    else $error("PSLVERR asserted without valid transaction!");*/
endmodule
