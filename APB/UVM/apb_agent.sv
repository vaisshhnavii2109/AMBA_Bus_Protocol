class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  uvm_analysis_port#(apb_pkt) ag_port;
  uvm_sequencer#(apb_pkt) s0;
  apb_driver d0;
  apb_monitor m0;
  function new(string name = "apb_agent",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s0 = uvm_sequencer#(apb_pkt)::type_id::create("s0",this);
    d0 = apb_driver::type_id::create("d0",this);
    m0 = apb_monitor::type_id::create("m0",this);
    ag_port = new("ag_port",this);
  endfunction
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d0.seq_item_port.connect(s0.seq_item_export);
    m0.mon_port.connect(this.ag_port);
  endfunction
endclass