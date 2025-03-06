class apb_wr_seq extends uvm_sequence#(apb_pkt);
  `uvm_object_utils(apb_wr_seq)
  function new(string name = "apb_wr_seq");
    super.new(name);
  endfunction
  task body();
    begin
      `uvm_do_with(req,{req.pwrite==1'b1;req.penable==1'b0;})
      
      `uvm_do_with(req,{req.pwrite==1'b1;req.penable==1'b1;req.paddr==8'h00;req.pwdata==32'haaaaeeee;})
      
      `uvm_do_with(req,{req.pwrite==1'b1;req.penable==1'b0;})
      
      `uvm_do_with(req,{req.pwrite==1'b1;req.penable==1'b1;req.paddr==8'hab;req.pwdata==32'hffffeeee;})
      `uvm_do_with(req,{req.pwrite==1'b1;req.penable==1'b0;})
      `uvm_do_with(req,{req.pwrite==1'b1;req.penable==1'b1;req.paddr==8'h10;req.pwdata==32'hffff1111;})
      `uvm_do_with(req,{req.pwrite==1'b1;req.penable==1'b0;})
      `uvm_do_with(req,{req.pwrite==1'b1;req.penable==1'b1;req.paddr==8'h30;req.pwdata==32'h00001111;})
    end
  endtask
endclass