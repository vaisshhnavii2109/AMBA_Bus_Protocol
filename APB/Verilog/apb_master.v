module apb_master(
  input [7:0] apb_write_paddr, apb_read_paddr,
  input [7:0] apb_write_data, prdata,
  input presetn, pclk, read, write, transfer, pready, state,
  output psel1, psel2,
  output reg penable,
  output reg [8:0] paddr, //address is 9 bits here as the the last bit is used to select the slave
  output reg pwrite,
  output reg [7:0] pwdata, apb_read_data_out,
  output pslverr);
  
reg [2:0] present_state, next_state;
reg invalid_setup_error;
reg setup_error,
invalid_read_paddr,
invalid_write_paddr,
invalid_write_data;

parameter idle = 2'b01,
          setup = 2'b10,
          enable = 2'b11;

always @(posedge pclk)
begin
  if(!presetn)
    present_state <= idle;
  else
    present_state <= next_state;
  end
  
  
always@(state, transfer, pready)
begin
  pwrite = write;
  
  case(present_state)
    
    idle:
    begin
      penable = 0;
      if (!transfer)
        next_state = idle;
        
      else next_state = setup;
      end
        
        setup: 
        begin
          penable = 1'b0;
          if (read == 1'b1 && write == 1'b0)
            paddr = apb_read_paddr;
            
          else if (read == 1'b0 && write == 1'b1)
            begin
            paddr = apb_write_paddr;
            pwdata = apb_write_data;
          end
        end
        
        enable: 
        begin 
          if(psel1 || psel2)
            penable = 1'b1;
            
            if(transfer & !pslverr)
              begin
                if(pready)
                  begin
                    if(read == 1'b0 && write == 1'b1)
                      next_state = setup;
                    else if (read == 1'b1 && write ==1'b0)
                      begin
                      next_state = setup;
                      apb_read_data_out = prdata;
                    end
                  end
                else
                  next_state = enable;
                end
                
                next_state = idle;
              end
            endcase
          end
          
          //pslverr
          always @(*)
          begin
            invalid_setup_error = setup_error || invalid_read_paddr || invalid_write_data || invalid_write_paddr;
            
            if (!presetn)
              begin
                setup_error = 1'b0;
                invalid_read_paddr = 1'b0;
                invalid_write_paddr = 1'b0;
                invalid_write_data = 1'b0;
              end
              else if (present_state == idle && next_state == enable)
                begin
                  setup_error = 1'b1;
                end
                
              else if ((apb_write_data == 8'dx) && (read == 1'b0) && (write == 1'b1) && (present_state == setup) || (present_state == enable))
                begin
                  invalid_write_data = 1'b1;     
                end
                
              else if ((apb_read_paddr == 9'dx) && (read == 1'b1) && (write == 1'b0) && (present_state == setup) || (present_state == enable))
                begin
                  invalid_read_paddr = 1'b1;
                end
                
              else if ((apb_write_paddr == 9'dx) && (read == 1'b0) && (write == 1'b1) && (present_state == setup) || (present_state == enable))
                begin
                  invalid_write_paddr = 1'b0;
                end
                
              else 
                invalid_write_paddr = 1'b0;
                invalid_write_data = 1'b0;
                invalid_read_paddr = 1'b0;
                invalid_setup_error = 1'b0;
              end
              assign pslverr = invalid_setup_error;
            endmodule
              