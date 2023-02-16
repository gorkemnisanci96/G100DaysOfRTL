`timescale 1ns / 1ps
// Round-Robin Arbiter 
// This file contains two different implementation of Round-Robin arbiter for three Devices. 




module day4_V1
#(parameter TIMECC = 20)
(
  input  logic       clk,
  input  logic       rstn,
  input  logic [2:0] req, // Request Signal For Three Devices 
  output logic [2:0] grant// Access signal to Three Devices 
    );
    
localparam [1:0] IDLE = 2'b00,
                 S1   = 2'b01, 
                 S2   = 2'b10, 
                 S3   = 2'b11; 
  
logic [1:0]                  state  , state_next;  
logic [($clog2(TIMECC)-1):0] counter, counter_next;   
  


  
  
/////////////////////
//   STATE DIAGRAM 
////////////////////      
always_comb
begin
   state_next   = state;
   counter_next = counter;
   grant        = 3'b000;
   case(state)
     IDLE: 
     begin
       grant        = 3'b000;
       counter_next = 0;
       if     (req[0]==1'b1) begin state_next = S1; end 
       else if(req[1]==1'b1) begin state_next = S2;   end 
       else if(req[2]==1'b1) begin state_next = S3;   end 
       else                  begin state_next = IDLE; end 
     end 
     S1:
     begin
       grant = 3'b000;  
       if( (req[0]==1'b1) && counter<TIMECC)
       begin
          counter_next = counter + 1;
          grant = 3'b001;
       end else  
       begin
          state_next   = S2;
          counter_next = 0;
       end 
     end 
     S2:
     begin
       grant = 3'b000;
       if( (req[1]==1'b1) && counter<TIMECC)
       begin
          counter_next = counter + 1;
          grant = 3'b010;
       end else 
       begin
          state_next   = S3;
          counter_next = 0;
       end      
     end 
     S3:
     begin
       grant = 3'b000;
       if( (req[2]==1'b1) && counter<TIMECC)
       begin
          counter_next = counter + 1;
          grant = 3'b100;
       end else 
       begin
          state_next   = S1;
          counter_next = 0;
       end      
     end 
   endcase 
end     
    
    
/////////////////////
//   STATE FLIP-FLOP
////////////////////    
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    state <= IDLE;
  end else begin
    state <= state_next;
  end 
end     
    
    
/////////////////////
//   COUNTER FLIP-FLOP
////////////////////    
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    counter <= 0;
  end else begin
    counter <= counter_next;
  end 
end         
    
    
    
    
    
endmodule :day4_V1


module day4_V2
#(parameter TIMECC = 20)
(
  input  logic       clk,
  input  logic       rstn,
  input  logic [2:0] req, // Request Signal For Three Devices 
  output logic [2:0] grant// Access signal to Three Devices 
    );
    
localparam [1:0] IDLE = 2'b00,
                 S1   = 2'b01, 
                 S2   = 2'b10, 
                 S3   = 2'b11; 
  
logic [1:0]                  state  , state_next;  
logic [($clog2(TIMECC)-1):0] counter, counter_next;   
  


  
  
    
always_comb
begin
   state_next   = state;
   counter_next = counter;
   case(state)
     IDLE: 
     begin
       grant        = 3'b000;
       counter_next = 0;
       if     (req[0]==1'b1) begin state_next = S1; end 
       else if(req[1]==1'b1) begin state_next = S2;   end 
       else if(req[2]==1'b1) begin state_next = S3;   end 
       else                  begin state_next = IDLE; end 
     end 
     S1:
     begin
       grant = 3'b000;  
       if( (req[0]==1'b1) && counter<TIMECC)
       begin
          counter_next = counter + 1;
          grant = 3'b001;
       end else if ((req[1]==1'b1))
       begin
          state_next   = S2;
          counter_next = 0;
          grant = 3'b010;
       end else if ((req[2]==1'b1)) 
       begin
          state_next   = S3;
          counter_next = 0;
          grant = 3'b100;
       end else if ((req[0]==1'b1))
       begin
          state_next   = S1;
          counter_next = 0;
          grant = 3'b001;
       end else begin
          state_next   = IDLE;
          counter_next = 0;
       end 
       
     end 
     S2:
     begin
       grant = 3'b000;
       if( (req[1]==1'b1) && counter<TIMECC)
       begin
          counter_next = counter + 1;
          grant = 3'b010;
       end else if ((req[2]==1'b1))
       begin
          state_next   = S3;
          counter_next = 0;
          grant = 3'b100;
       end else if ((req[0]==1'b1)) 
       begin
          state_next   = S1;
          counter_next = 0;
          grant = 3'b001;
       end else if ((req[1]==1'b1))
       begin
          state_next   = S2;
          counter_next = 0;
          grant = 3'b010;
       end else begin
          state_next   = IDLE;
          counter_next = 0;
       end       
     end 
     S3:
     begin
       grant = 3'b000;
       if( (req[2]==1'b1) && counter<TIMECC)
       begin
          counter_next = counter + 1;
          grant = 3'b100;
       end else if ((req[0]==1'b1))
       begin
          state_next   = S1;
          counter_next = 0;
          grant = 3'b001;
       end else if ((req[1]==1'b1)) 
       begin
          state_next   = S2;
          counter_next = 0;
          grant = 3'b010;
       end else if ((req[2]==1'b1))
       begin
          state_next   = S3;
          counter_next = 0;
          grant = 3'b100;
       end else begin
          state_next   = IDLE;
          counter_next = 0;
       end    
     end 
   endcase 
end     
    
    
/////////////////////
//   STATE FLIP-FLOP
////////////////////    
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    state <= IDLE;
  end else begin
    state <= state_next;
  end 
end     
    
    
/////////////////////
//   COUNTER FLIP-FLOP
////////////////////    
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    counter <= 0;
  end else begin
    counter <= counter_next;
  end 
end         
    
    
    
    
    
endmodule :day4_V2











module day4_V1_tb();

logic       clk;
logic       rstn;
logic [2:0] req;
logic [2:0] grant_V1;
logic [2:0] grant_V2;
parameter TIMECC = 10;

initial begin
clk = 1'b0;

 fork
  forever #10 clk = ~clk;
 join

end 

initial begin
req = 3'b0;
rstn = 1'b1;
repeat(2) @(posedge clk);
rstn = 1'b0;
repeat(2) @(posedge clk);
rstn = 1'b1;
repeat(2) @(posedge clk);
req = 3'b001;
repeat(30) @(posedge clk);
req = 3'b010;
@(posedge clk);
req = 3'b100;
repeat(30) @(posedge clk);
req = 3'b000;
repeat(30) @(posedge clk);
req = 3'b011;
repeat(30) @(posedge clk);
req = 3'b000;
repeat(300) @(posedge clk);
$finish;
end 


day4_V1
#(.TIMECC (TIMECC))
uday4_V1 
( 
  .clk   (clk),
  .rstn  (rstn),
  .req   (req), 
  .grant (grant_V1)
);

day4_V2
#(.TIMECC (TIMECC))
uday4_V2 
( 
  .clk   (clk),
  .rstn  (rstn), 
  .req   (req), 
  .grant (grant_V2)
);


endmodule :day4_V1_tb
