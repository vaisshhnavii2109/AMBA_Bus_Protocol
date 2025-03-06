//`include "transaction.sv"
class monitor;
  virtual intf vif;
  mailbox mon2scb;

  function new(virtual intf vif, mailbox mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction

  task run();
    forever begin
      @(posedge vif.pclk);
      if (vif.penable && vif.psel) begin
        transaction tr = new();
        tr.write_paddr = vif.write_paddr;
        tr.write_data = vif.write_data;
        tr.read_paddr = vif.read_paddr;
        tr.read = vif.read;
        tr.write = vif.write;
        tr.transfer = vif.transfer;
        tr.prdata = vif.prdata;
        tr.pslverr = vif.pslverr;
        tr.display("MONITOR");
        mon2scb.put(tr);
      end
    end
  endtask
endclass
