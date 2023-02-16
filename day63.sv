`timescale 1ns / 1ps
// FULL ADDER CIRCUIT WITH GATE LEVEL MODELLING


module FULL_ADDER(
   input logic A,
   input logic B,
   input logic Cin,
   output logic S,
   output logic Cout
    );
    
 logic t1,t2,t3;
 
 xor xor1(t1,A,B);
 xor xor2(S,t1,Cin);
 and and1(t2,Cin,t1);
 and and2(t3,A,B);
 or  or1(Cout,t2,t3);     
    
endmodule




module FULL_ADDER_tb();


logic clk;
logic A;
logic B;
logic Cin;
logic S;
logic Cout;
//
logic [2:0] cnt; 
logic [1:0] ex_result; 
int error;
// Clock Generation 
initial begin
   clk = 1'b0;
   forever #10 clk = ~clk;  
end 

assign A    = cnt[0];
assign B    = cnt[1];
assign Cin  = cnt[2];

assign ex_result = cnt[0] + cnt[1] + cnt[2];


initial begin
cnt   = '0;
error = '0;
for(int i =0;i<8;i++)
begin
   if(ex_result[0] != S || ex_result[1] != Cout)   error++;
   @(posedge clk);
      cnt <= cnt + 1;
end 

if(error == 0) $display("NO ERROR!");
else $display("%d !!ERROR!! ",error);



end 




// MODULE INSTANTIATION 
FULL_ADDER uFULL_ADDER(.*);
 
endmodule 
