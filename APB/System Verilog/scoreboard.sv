//`include "transaction.sv"
class scoreboard;
  mailbox mon2scb;
  bit [7:0] mem[0:255];

  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction

  task run();
    forever begin
      transaction tr;
      mon2scb.get(tr);
      if (tr.write) begin
        mem[tr.write_paddr] = tr.write_data;
      end
      if (tr.read) begin
        assert(mem[tr.read_paddr] == tr.prdata)
          else $error("Data mismatch at address %0h", tr.read_paddr);
      end
    end
  endtask
endclass
