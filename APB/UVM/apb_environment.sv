class env extends uvm_env;
  `uvm_component_utils(env)
  apb_agent a0;
  apb_scoreboard sc0;
  function new(string name = "env",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a0 = apb_agent::type_id::create("a0",this);
    sc0 = apb_scoreboard::type_id::create("sc0",this);
  endfunction
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a0.ag_port.connect(sc0.sc_port);
  endfunction
endclass