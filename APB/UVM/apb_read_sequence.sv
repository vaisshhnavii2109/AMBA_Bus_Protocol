class apb_read_seq extends uvm_sequence#(apb_pkt);
  `uvm_object_utils(apb_read_seq)
  function new(string name = "apb_read_seq");
    super.new(name);
  endfunction
  task body();
    begin
      `uvm_do_with(req,{req.pwrite==1'b0;req.penable==1'b0;})
      `uvm_do_with(req,{req.pwrite==1'b0;req.penable==1'b1;req.paddr==8'h00;})
      `uvm_do_with(req,{req.pwrite==1'b0;req.penable==1'b0;})
      `uvm_do_with(req,{req.pwrite==1'b0;req.penable==1'b1;req.paddr==8'hab;})
      `uvm_do_with(req,{req.pwrite==1'b0;req.penable==1'b0;})
      `uvm_do_with(req,{req.pwrite==1'b0;req.penable==1'b1;req.paddr==8'h10;})
      `uvm_do_with(req,{req.pwrite==1'b0;req.penable==1'b0;})
      `uvm_do_with(req,{req.pwrite==1'b0;req.penable==1'b1;req.paddr==8'h30;})
    end
  endtask
endclass