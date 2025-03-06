//`include "transaction.sv"

class driver;
  virtual intf vif;
  mailbox gen2drv;

  function new(virtual intf vif, mailbox gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

  task run();
    forever begin
      transaction tr;
      gen2drv.get(tr);
      vif.write_paddr = tr.write_paddr;
      vif.write_data = tr.write_data;
      vif.read_paddr = tr.read_paddr;
      vif.read = tr.read;
      vif.write = tr.write;
      vif.transfer = tr.transfer;
      @(posedge vif.pclk);
      tr.display("DRIVER");
    end
  endtask
endclass
/*class driver;
  virtual intf vif;
  mailbox gen2drv;
  transaction tr;
  function new(virtual intf vif, mailbox gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

  task run();
    forever begin
      
      gen2drv.get(tr);
      vif.write_paddr = tr.write_paddr;
      vif.write_data = tr.write_data;
      vif.read_paddr = tr.read_paddr;
      vif.read = tr.read;
      vif.write = tr.write;
      vif.transfer = tr.transfer;
      @(posedge vif.pclk);
      tr.display("DRIVER");
    end
  endtask
endclass*/
