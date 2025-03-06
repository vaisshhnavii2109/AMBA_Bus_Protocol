module apb_slave(
  input pclk, presetn,
  input psel, penable, pwrite,
  input [7:0] paddr,pwdata,
  output [7:0] prdata, 
  output reg pready);
  
  reg [7:0]addr;
  reg [7:0]mem[63:0];
  
  assign prdata = mem[addr];
  
  always@(*)
  begin
    if (!presetn)
      begin
        pready = 1'b0;
      end
      else if (psel && !penable && !pwrite)
        pready = 1'b0;
        
      else if (psel && penable && !pwrite)
        begin
        pready = 1'b0;
        addr = paddr;
      end
      
    else if (psel && !penable && pwrite)
      begin
        pready = 1'b0;
      end
      
    else if (psel && penable && pwrite)
      begin
        pready = 1'b1;
        mem[addr] = pwdata;
      end
      
    else
      pready = 1'b0;
    end
  
  
endmodule