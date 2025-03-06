class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  env e0;
  apb_seq seq;
  function new(string name = "base_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e0 = env::type_id::create("e0",this);
    seq = apb_seq::type_id::create("seq",this);
  endfunction
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(e0.a0.s0);
    #620;
    phase.drop_objection(this);
  endtask
endclass
