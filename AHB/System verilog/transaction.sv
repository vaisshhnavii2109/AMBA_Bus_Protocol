class ahb_transaction;
    rand logic [31:0] haddr;
    rand logic [31:0] hwdata;
    rand logic [2:0] hsize;
    rand logic [2:0] hburst;
    rand logic hwrite;
    rand logic [1:0] htrans;

    function void display();
        $display("Transaction: haddr=%h, hwdata=%h, hsize=%h, hburst=%h, hwrite=%b, htrans=%b",
                 haddr, hwdata, hsize, hburst, hwrite, htrans);
    endfunction
endclass
