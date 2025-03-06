//`include "transaction.sv"
class generator;
    ahb_transaction trans;
    mailbox gen2drv;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        repeat (10) begin
            trans = new();
            assert (trans.randomize());
            trans.display();
            gen2drv.put(trans);
        end
    endtask
endclass

