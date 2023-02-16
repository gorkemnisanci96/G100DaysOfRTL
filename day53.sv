// 3 always Block Coding Style - Not Recomended - Registered Outputs. 
// http://www.sunburst-design.com/papers/CummingsSNUG2019SV_FSM1.pdf


typedef enum logic [1:0] {
                         IDLE = 2'b00,
                         READ = 2'b01,
                         DLY  = 2'b11, 
                         DONE = 2'b10,
                         XXX  = 'x } state_type; 





module day53 (
   input logic clk, 
   input logic rstn,
   input logic go, 
   input logic ws, 
   output logic rd, 
   output logic rd
);
  
state_type state, next; 
  
  
  always_ff @(posedge clk or negedge rstn)
    begin
      if(!rstn) begin state <= IDLE;   end 
      else      begin state <= next;   end 
    end 
  
  always_comb begin
    next = XXX;
    case(state)
      IDLE: begin
        if(go) begin next = READ;   end 
        else   begin next = IDLE;   end 
      end 
      READ:    begin next = DLY;    end 
      DLY:begin  
        if(!ws)begin next = DONE;   end
        else   begin next = READ;   end 
      end 
      DONE:    begin next = IDLE;   end
      default: begin next = XXX;    end 
    endcase
  end 
  
  
  always_ff @(posedge clk, negedge rstn)
    begin
      if(!rstn)
        begin
          rd <= '0;
          ds <= '0;
        end else begin
          rd <= '0;
          ds <= '0;
          case(next)
            IDLE: ;
            READ: rd <= '1;
            DLY:  rd <= '1;
            DONE: ds <= '1;
            default: {rd.ds} <= 'x;
          endcase 
        end 
      
      
    end 
   
endmodule :day53  
