`timescale 1ns / 1ps
// 16-bit Ripple Adder

module RIPPLE_ADDER_16BIT(
    input  logic [15:0] A,
    input  logic [15:0] B,
    input  logic        Cin,
    output logic [15:0] S,
    output logic        Cout
    );
    
 
logic [15:0]  C;
    
FULL_ADDER FULL_ADDER0 (.A (A[0]),  .B (B[0]),  .Cin (Cin),   .S (S[0]),  .Cout (C[0]));    
FULL_ADDER FULL_ADDER1 (.A (A[1]),  .B (B[1]),  .Cin (C[0]),  .S (S[1]),  .Cout (C[1]));    
FULL_ADDER FULL_ADDER2 (.A (A[2]),  .B (B[2]),  .Cin (C[1]),  .S (S[2]),  .Cout (C[2]));    
FULL_ADDER FULL_ADDER3 (.A (A[3]),  .B (B[3]),  .Cin (C[2]),  .S (S[3]),  .Cout (C[3]));    
FULL_ADDER FULL_ADDER4 (.A (A[4]),  .B (B[4]),  .Cin (C[3]),  .S (S[4]),  .Cout (C[4]));    
FULL_ADDER FULL_ADDER5 (.A (A[5]),  .B (B[5]),  .Cin (C[4]),  .S (S[5]),  .Cout (C[5]));    
FULL_ADDER FULL_ADDER6 (.A (A[6]),  .B (B[6]),  .Cin (C[5]),  .S (S[6]),  .Cout (C[6]));    
FULL_ADDER FULL_ADDER7 (.A (A[7]),  .B (B[7]),  .Cin (C[6]),  .S (S[7]),  .Cout (C[7]));      
FULL_ADDER FULL_ADDER8 (.A (A[8]),  .B (B[8]),  .Cin (C[7]),  .S (S[8]),  .Cout (C[8]));    
FULL_ADDER FULL_ADDER9 (.A (A[9]),  .B (B[9]),  .Cin (C[8]),  .S (S[9]),  .Cout (C[9]));    
FULL_ADDER FULL_ADDER10(.A (A[10]), .B (B[10]), .Cin (C[9]),  .S (S[10]), .Cout (C[10]));    
FULL_ADDER FULL_ADDER11(.A (A[11]), .B (B[11]), .Cin (C[10]), .S (S[11]), .Cout (C[11]));    
FULL_ADDER FULL_ADDER12(.A (A[12]), .B (B[12]), .Cin (C[11]), .S (S[12]), .Cout (C[12]));    
FULL_ADDER FULL_ADDER13(.A (A[13]), .B (B[13]), .Cin (C[12]), .S (S[13]), .Cout (C[13]));    
FULL_ADDER FULL_ADDER14(.A (A[14]), .B (B[14]), .Cin (C[13]), .S (S[14]), .Cout (C[14]));    
FULL_ADDER FULL_ADDER15(.A (A[15]), .B (B[15]), .Cin (C[14]), .S (S[15]), .Cout (C[15]));         
    
assign Cout = C[15]; 
    
endmodule :RIPPLE_ADDER_16BIT


//=================================
// TEST BENCH 
//=================================
module RIPPLE_ADDER_16BIT_tb();

logic [15:0] A;
logic [15:0] B;
logic        Cin;
logic [15:0] S;
logic        Cout;

logic [16:0] ex_result;
int error;
initial begin
   Cin = 0;
   error = 0; 
   for(int i=0;i<100;i++)
   begin
      A = $random;
      B = $random;
      ex_result = A + B;
      #2;
      if(ex_result!={Cout,S}) error++;
      #2;
   end 
   
   if(error == 0) $display("NO ERROR!");
   else $display("%d ERRORS!",error);

end 




// DUT INSTANTIATION
RIPPLE_ADDER_16BIT  uRIPPLE_ADDER_16BIT(.*);

endmodule 


