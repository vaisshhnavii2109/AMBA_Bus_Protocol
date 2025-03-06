//`include "transaction.sv"
class driver;
    virtual ahb_if vif;
    mailbox gen2drv;

    function new(virtual ahb_if vif, mailbox gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    task run();
        forever begin
            ahb_transaction trans;
            gen2drv.get(trans);
            vif.driver_cb.haddr <= trans.haddr;
            vif.driver_cb.hwdata <= trans.hwdata;
            vif.driver_cb.hsize <= trans.hsize;
            vif.driver_cb.hburst <= trans.hburst;
            vif.driver_cb.hwrite <= trans.hwrite;
            vif.driver_cb.htrans <= trans.htrans;
            @(vif.driver_cb);
        end
    endtask
endclass
