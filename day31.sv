`timescale 1ns / 1ps
//////////////////////////////////////////////
//    TASK      AND      FUNCTION 
// Consume Time    |  Completes in 0 simulation Time 
// Provide Output  | Returns value and Provide output

module day31();
  
 
 
logic [7:0] num1; 
logic [7:0] num2; 
logic [7:0] sum1,sum2; 
  
////////////////////////
// Addition Operation Using Task 
function [7:0] sumFunction 
(
input logic [7:0] a,
input logic [7:0] b
);
begin
  sumFunction = a + b; 
end 
endfunction 






/////////////////////
// Addition Operation Using Task 
task SumTask
(
  input  logic [7:0] a1,
  input  logic [7:0] a2,
  output logic [7:0] sum
);
begin
#10; // We can use delay in a Task 
  sum = a1 + a2; 

end 
endtask   
  
  
initial begin
num1 = 8'd0;
num2 = 8'd0;
#10;
num1 = 8'd5;
num2 = 8'd2;
SumTask(.a1(num1),.a2(num2),.sum(sum1));
//
sum2 = sumFunction(.a(num1), .b(num2));
//



$finish;
end   
  
  
  
  
  
  
endmodule :day31
