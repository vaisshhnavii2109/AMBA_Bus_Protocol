//`include "transaction.sv"
class monitor;
    virtual ahb_if vif;
    mailbox mon2scb;

    function new(virtual ahb_if vif, mailbox mon2scb);
        this.vif = vif;
        this.mon2scb = mon2scb;
    endfunction

    task run();
        forever begin
            ahb_transaction trans = new();
            @(vif.monitor_cb);
            trans.haddr = vif.monitor_cb.haddr;
            trans.hwdata = vif.monitor_cb.hwdata;
            trans.hsize = vif.monitor_cb.hsize;
            trans.hburst = vif.monitor_cb.hburst;
            trans.hwrite = vif.monitor_cb.hwrite;
            trans.htrans = vif.monitor_cb.htrans;
            mon2scb.put(trans);
        end
    endtask
endclass
