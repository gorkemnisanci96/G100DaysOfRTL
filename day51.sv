// 1-always Block Coding Style - Not Recomended - Registered Outputs. 
// http://www.sunburst-design.com/papers/CummingsSNUG2019SV_FSM1.pdf


typedef enum logic [1:0] {
                         IDLE = 2'b00,
                         READ = 2'b01,
                         DLY  = 2'b11, 
                         DONE = 2'b10,
  XXX  = 'x } state_type; 





module day51 (
   input logic clk, 
   input logic rstn,
   input logic go, 
   input logic ws, 
   output logic rd, 
   output logic rd
);
  
state_type state;  
  

  always_ff @(posedge clk, negedge rstn)
    begin
      if(!rstn)
        begin
          state <= IDLE; 
          rd    <= '0; 
          ds    <= '0;
        end else begin
          state <= XXX; 
          rd    <= '0;
          ds    <= '0; 
          
          case(state)
            IDLE:
               begin
                 if(go)
                    begin
                       rd <= '1;
                                     state <= READ;
                    end else 
                    begin
                                     state <= IDLE;
                    end 
               end 
            READ:
               begin
                  rd <= '1;
                                     state <= DLY;
               end 
            DLY:
               begin
                 if(!ws)
                    begin
                       ds <= '1;
                                     state <= DONE;
                    end else 
                    begin
                       rd <= '1;   
                                     state <= READ;
                    end 
               end                     
            DONE: begin              state <= IDLE; end 
            default: begin
                     ds <= 'x;
                     rd <= 'x; 
                                     state <= XXX;
                     end 
          endcase 
          
        end    
    end 

endmodule :day51  
