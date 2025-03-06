class apb_driver extends uvm_driver#(apb_pkt);
  `uvm_component_utils(apb_driver)
  virtual dutintf vif;
  apb_pkt pkt;
  function new(string name = "apb_driver",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dutintf)::get(this,"","dut_vif",vif)) begin
      `uvm_fatal("DRV","no VIf handle")
    end
  endfunction
  virtual task run_phase(uvm_phase phase);
    vif.rst_n = 0;
    @(posedge vif.clk);
    vif.rst_n = 1;
    @(posedge vif.clk);
    forever begin
      seq_item_port.get_next_item(req);
      vif.paddr=req.paddr;
      vif.pwrite=req.pwrite;
      vif.penable=req.penable;
      vif.psel=req.psel;
      vif.pwdata=req.pwdata;
      `uvm_info("DRV",$sformatf("paddr is %h,pwrite is %h,penable is %h,psel is %h,pwdata is %h",vif.paddr,vif.pwrite,vif.penable,vif.psel,vif.pwdata),UVM_LOW)
      seq_item_port.item_done();
      @(posedge vif.clk);
      @(posedge vif.clk);
      @(posedge vif.clk);
    end
  endtask
endclass
      
      