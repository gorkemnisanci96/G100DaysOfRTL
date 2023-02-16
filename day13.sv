`timescale 1ns / 1ps
//////////////////////////////////////
// Different Ways of Writing a Single bit MUX 
module day13(
input  logic sel,
input  logic a1,a2,a3,a4,
input  logic b1,b2,b3,b4,
output logic c1,c2,c3,c4
);


// MUX1 
always_comb 
begin
    case(sel)
      1'b0: c1 = a1;  
      1'b1: c1 = b1;
    endcase 
end 

// MUX2
always_comb 
begin
   if(sel == 1'b0)
   begin
     c2 = a2;
   end else begin
     c2 = b2;
   end
end 

// MUX3
assign c3 = sel ? b3 : a3;

// MUX4
assign c4 = sel&b4 | ~sel&a4; 


endmodule :day13 



module day13_tb();

logic sel;
logic a1,a2,a3,a4;
logic b1,b2,b3,b4;
logic c1,c2,c3,c4;


initial begin
a1 = 1'b1;
a2 = 1'b0;
a3 = 1'b1;
a4 = 1'b1;
b1 = 1'b0;
b2 = 1'b1;
b3 = 1'b0;
b4 = 1'b0;
//
sel = 0;
//
#10
if((c1==a1) && (c2==b2) && (c3==a3) && (c4==a4))
begin
  $display("--PASS--");
end else begin
  $display("--FAIL--");
end  
#30

$finish;
end 

// Module Instantiation
day13 uday13(.*);


endmodule :day13_tb 
