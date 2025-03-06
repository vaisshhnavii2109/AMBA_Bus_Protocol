class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  uvm_analysis_imp#(apb_pkt,apb_scoreboard) sc_port;
  bit[31:0] local_mem[256];
  apb_pkt qu[$];
  apb_pkt local_pkt;
  function new(string name = "apb_scoreboard",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sc_port = new("sc_port",this);
    foreach(local_mem[i]) local_mem[i]=0;
  endfunction
  virtual function void write(apb_pkt pkt);
    qu.push_back(pkt);
  endfunction
  virtual task run_phase(uvm_phase phase);
    forever begin
    wait(qu.size()>0);
      local_pkt = qu.pop_front();
      if(local_pkt.pwrite) begin
        local_mem[local_pkt.paddr]=local_pkt.pwdata;
        `uvm_info("SCBD","data written to loc_mem",UVM_LOW)
        `uvm_info("SCBD",$sformatf("loc_mem[%0h] is %0h",local_pkt.paddr,local_mem[local_pkt.paddr]),UVM_LOW)
      end
      else begin
        if(local_pkt.prdata==local_mem[local_pkt.paddr]) begin
          `uvm_info("SCBD", "readdata match",UVM_LOW)
          `uvm_info("SCBD",$sformatf("prdata of slave is %h,prdata from dut is %h",local_mem[local_pkt.paddr],local_pkt.prdata),UVM_LOW)
        end
        else begin
          `uvm_error("SCBD","read data FAIL")
          `uvm_info("SCBD",$sformatf("prdata of slave is %h,prdata from dut is %h and paddr is %h",local_mem[local_pkt.paddr],local_pkt.prdata,local_pkt.paddr),UVM_LOW)
        end
      end
    end
  endtask
endclass
    