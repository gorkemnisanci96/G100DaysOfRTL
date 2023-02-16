// 4 always Block Coding Style - Recomended - Registered Outputs. 
// http://www.sunburst-design.com/papers/CummingsSNUG2019SV_FSM1.pdf


typedef enum logic [1:0] {
                         IDLE = 2'b00,
                         READ = 2'b01,
                         DLY  = 2'b11, 
                         DONE = 2'b10,
                         XXX  = 'x } state_type; 





module day54 (
   input logic clk, 
   input logic rstn,
   input logic go, 
   input logic ws, 
   output logic rd, 
   output logic rd
);
  
state_type state, next; 
logic rd_next;  
logic ds_next;  
  
  
  always_comb begin
    next = XXX;
    case(state)
      IDLE:
        begin
          if(go) begin next = READ;  end
          else   begin next = IDLE;  end
        end
      READ:      begin next = DLY;   end 
      DLY:
        begin               
          if(!ws)begin next = DONE;  end 
          else   begin next = READ;  end 
        end
      DONE:      begin next = IDLE;  end 
      default:   begin next = XXX;   end   
     endcase  
  end 
  
  always_ff @(posedge clk, negedge rstn)
    begin
      if(!rstn) begin state <= IDLE;   end 
      else      begin state <= next;   end 
    end 
  
  
  always_comb begin 
    rd_next = '0;
    ds_next = '0;
    case(state)
      IDLE:
        begin
          if(go) begin rd_next = '1;  end
          else   begin  end
        end
      READ:      begin rd_next = '1;  end 
      DLY:
        begin               
          if(!ws)begin rd_next= '1;  end 
          else   begin ds_next= '1;  end 
        end
      DONE:      begin end 
      default:   begin {rd_next,ds_next}='x; end   
    endcase 
  end 
  
  always_ff @(posedge clk or negedge rstn)
    begin
      if(!rstn)
        begin
          rd <= '0;
          ds <= '0;
        end else begin
          rd <= rd_next;
          ds <= ds_next;  
        end    
    end 
  
endmodule :day54 
