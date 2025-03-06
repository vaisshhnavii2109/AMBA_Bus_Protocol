class transaction;
  rand logic [7:0] write_paddr;
  rand logic [7:0] write_data;
  rand logic [7:0] read_paddr;
  rand bit transfer;
  rand bit write;
  rand bit read;
  logic [7:0] prdata;
  logic pslverr;

  // Constraints
  constraint valid_addr { write_paddr inside {[0:255]}; read_paddr inside {[0:255]}; }
  constraint valid_data { write_data inside {[0:255]}; }
  constraint read_write_exclusive { read != write; }

  function void display(string tag);
    $display("[%s] Write Addr: %h, Write Data: %h, Read Addr: %h, Read: %b, Write: %b, Transfer: %b, Read Data: %h, PSLVERR: %b",
             tag, write_paddr, write_data, read_paddr, read, write, transfer, prdata, pslverr);
  endfunction
endclass
