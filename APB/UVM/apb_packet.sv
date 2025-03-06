class apb_pkt extends uvm_sequence_item;
 // `uvm_object_utils(apb_pkt)
  function new(string name = "apb_pkt");
    super.new(name);
  endfunction
  rand bit[7:0] paddr;
  rand bit[31:0] pwdata;
  bit[31:0] prdata;
  rand bit pwrite;
  rand bit psel;
  rand bit penable;
  constraint c1 {psel == 1'b1;};
  `uvm_object_utils_begin(apb_pkt)
  `uvm_field_int(paddr, UVM_ALL_ON)
  `uvm_field_int(pwdata,UVM_ALL_ON)
  `uvm_field_int(prdata, UVM_ALL_ON)
  `uvm_field_int(pwrite, UVM_ALL_ON)
  `uvm_field_int(psel, UVM_ALL_ON)
  `uvm_field_int(penable, UVM_ALL_ON)
  `uvm_object_utils_end
  
  
endclass