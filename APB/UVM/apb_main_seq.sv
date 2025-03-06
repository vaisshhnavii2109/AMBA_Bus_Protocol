class apb_seq extends uvm_sequence#(apb_pkt);
  `uvm_object_utils(apb_seq)
  function new(string name = "apb_seq");
    super.new(name);
  endfunction
  task body();
    apb_read_seq rd;
    apb_wr_seq wr;
    begin
      repeat(1) begin
        `uvm_do(wr)
      end
      repeat(1) begin
        `uvm_do(rd)
      end
    end
  endtask
endclass