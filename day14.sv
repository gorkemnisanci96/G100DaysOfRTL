`timescale 1ns / 1ps
//////////////////////////////////////
// There is a stream of bits coming and in each clock cycle generating a new 
// binary number by shifting the previous number to the left and being the LSB. 
// This program finds the result of the MOD 5 in each clock cycle. 


module day14(
  input  logic clk,
  input  logic rstn, 
  input  logic i_BitStream,
  output logic [3:0] o_ModFive
    );
    
    
localparam [2:0] s0 = 3'b000,
                 s1 = 3'b001,
                 s2 = 3'b010,
                 s3 = 3'b011,
                 s4 = 3'b100;    
    
logic [2:0] State,StateNext;


always_comb
begin
   case(State)
     s0: StateNext = i_BitStream ? s1 : s0 ;   
     s1: StateNext = i_BitStream ? s3 : s2 ;      
     s2: StateNext = i_BitStream ? s0 : s4 ;      
     s3: StateNext = i_BitStream ? s2 : s1 ;      
     s4: StateNext = i_BitStream ? s4 : s3 ;      
   endcase 
end     

//////////////////////////
// STATE REGISTER 
/////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
     State <= s0;
  end else begin
     State <= StateNext; 
  end 
end 




//////////////////////////
// OUTPUT 
/////////////////////////   
assign o_ModFive = State;
     
    
    
    
    
       
endmodule :day14


//////////////////////////////
// TEST BENCH 
//////////////////////////////

module day14_tb();

logic clk;
logic rstn; 
logic i_BitStream;
logic [3:0] o_ModFive;

//////////////////////////////
// Clock Generation 
//////////////////////////////
initial begin
 clk = 1'b0;
 fork
   forever #10 clk = ~clk;
 join

end 

//////////////////////////////
// RESET GENERATION 
//////////////////////////////
task RESET();
begin
  rstn = 1'b1;
  @(posedge clk);
  rstn = 1'b0;
  repeat(2)@(posedge clk);
  rstn = 1'b1;
end 
endtask 



initial begin
i_BitStream = 0;
RESET();
@(posedge clk);
  i_BitStream = 1;
@(posedge clk);
  i_BitStream = 0;
@(posedge clk);
  i_BitStream = 0;
@(posedge clk);
  i_BitStream = 1;
@(posedge clk);
  i_BitStream = 0;
@(posedge clk);
  i_BitStream = 1;
@(posedge clk);
  i_BitStream = 0;
repeat(2)@(posedge clk);     
if(o_ModFive == 3'd4)begin $display("---PASS--- Time: %0t",$time); end  else begin $display("---FAIL--- Time: %0t",$time); end
  
 
  
repeat(20) @(posedge clk);
$finish;
end 


// Module Instantiation 
day14 uday14(.*);

endmodule 
