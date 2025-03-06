//`include "transaction.sv"
class generator;
  mailbox gen2drv;
  transaction tr;

  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task run();
    forever begin
      tr = new();
      assert(tr.randomize());
      tr.display("GENERATOR");
      gen2drv.put(tr);
      #10;
    end
  endtask
endclass
