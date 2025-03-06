class apb_monitor extends uvm_monitor;
function new(string name = "apb_monitor",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  `uvm_component_utils(apb_monitor)
  virtual dutintf vif;
  uvm_analysis_port#(apb_pkt)mon_port;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dutintf)::get(this,"","dut_vif",vif)) begin
      `uvm_fatal("DRV","no VIf handle")
    end
    mon_port = new("mon_port",this);
  endfunction
  virtual task run_phase(uvm_phase phase);
    apb_pkt pkt = apb_pkt::type_id::create("pkt",this);
    forever begin
      @(posedge vif.clk);
      @(vif.paddr,vif.pwrite,vif.penable,vif.pwdata);
      `uvm_info("MON","Monitor starting now",UVM_LOW)
      pkt.pwrite = vif.pwrite;
        pkt.paddr = vif.paddr;
        pkt.pwdata = vif.pwdata;
        pkt.psel = vif.psel;
      pkt.penable = vif.penable;
      if(!vif.pwrite) begin
        `uvm_info("MON","monitoring READ operation",UVM_LOW)
        @(posedge vif.clk);
        @(posedge vif.clk);
        @(posedge vif.clk);
        @(posedge vif.clk);
        @(posedge vif.clk);
        pkt.paddr = vif.paddr;///TODO
        pkt.prdata = vif.prdata;
        `uvm_info("MON",$sformatf("Read data obtained is %h",pkt.prdata),UVM_LOW)
      end
      pkt.print();
        mon_port.write(pkt);
    end
  endtask
endclass
        

      