`timescale 1ns / 1ps

//===============================
//  FULL ADDER with CARRY Propagate and Generate Inputs   
//===============================
module FULL_ADDER_withPG
(
    input  logic P,   // Propagate 
    input  logic G,   // Generate 
    input  logic Cin, // Carry Input bit  
    output logic S,   // Sum Output vit  
    output logic Cout // Carry Output bit 
);

 logic t1;

 xor xor1(S,P,Cin);
 //
 and and1(t1,P,Cin);
 or  or1(Cout,G,t1);  

endmodule 


//===============================
//  4-Bit FULL ADDER with CARRY Propagate and Generate Inputs   
//===============================
module FULL_ADDER_withPG_4BIT
(
    input  logic [3:0]  P,   // Propagate 
    input  logic [3:0]  G,   // Generate 
    input  logic        Cin, // Carry Input bit  
    output logic [3:0]  S,   // Sum Output vit  
    output logic        Cout // Carry Output bit 
);

  logic [2:0] C;


  FULL_ADDER_withPG FULL_ADDER_withPG0( .P (P[0]),   .G (G[0]),    .Cin (Cin),   .S (S[0]),   .Cout (C[0]) );
  FULL_ADDER_withPG FULL_ADDER_withPG1( .P (P[1]),   .G (G[1]),    .Cin (C[0]),  .S (S[1]),   .Cout (C[1]) );
  FULL_ADDER_withPG FULL_ADDER_withPG2( .P (P[2]),   .G (G[2]),    .Cin (C[1]),  .S (S[2]),   .Cout (C[2]) );
  FULL_ADDER_withPG FULL_ADDER_withPG3( .P (P[3]),   .G (G[3]),    .Cin (C[2]),  .S (S[3]),   .Cout (Cout) );

endmodule 




//===============================
//  16-BIT CARRY SKIP ADDER 
//===============================
module CREATE_PG_4BIT
(
    input  logic [3:0] A, // 4-bit number1
    input  logic [3:0] B, // 4-bit number2  
    output logic [3:0] P, // 4-bit Propagate Signal 
    output logic [3:0] G  // 4-bit Generate Signal 
);

  xor xor0(P[0],A[0],B[0]);
  xor xor1(P[1],A[1],B[1]);
  xor xor2(P[2],A[2],B[2]);
  xor xor3(P[3],A[3],B[3]);
  //
  and and0(G[0],A[0],B[0]);
  and and1(G[1],A[1],B[1]);
  and and2(G[2],A[2],B[2]);
  and and3(G[3],A[3],B[3]);


endmodule :CREATE_PG_4BIT  


//===============================
//  16-BIT CARRY SKIP ADDER 
//===============================
module CARRY_SKIP_ADDER_16BIT(
    input  logic [15:0] A,
    input  logic [15:0] B,
    input  logic        Cin,
    output logic [15:0] S,
    output logic        Cout
    );
    
  logic [15:0]  C;    
  logic [15:0]  P;    
  logic [15:0]  G;    
  logic [2:0]   MUXOUT;    
  //
  CREATE_PG_4BIT         uCREATE_PG_4BIT0(.A (A[3:0]),.B (B[3:0]),.P (P[3:0]),.G (G[3:0]));
  FULL_ADDER_withPG_4BIT uFULL_ADDER_withPG_4BIT0(.P (P[3:0]),   .G (G[3:0]),   .Cin (Cin),  .S (S[3:0]),   .Cout (C[0]) );
  assign MUXOUT[0] = &P[3:0] ? Cin : C[0] ;
  //
  CREATE_PG_4BIT uCREATE_PG_4BIT1(.A (A[7:4]),   .B (B[7:4]),    .P (P[7:4]),   .G (G[7:4]));
  FULL_ADDER_withPG_4BIT uFULL_ADDER_withPG_4BIT1(.P (P[7:4]),   .G (G[7:4]),   .Cin (MUXOUT[0]),  .S (S[7:4]),   .Cout (C[1]) );
  assign MUXOUT[1] = &P[7:4] ? MUXOUT[0] : C[1] ;
  //
  CREATE_PG_4BIT uCREATE_PG_4BIT2(.A (A[11:8]),  .B (B[11:8]),   .P (P[11:8]),  .G (G[11:8]));
  FULL_ADDER_withPG_4BIT uFULL_ADDER_withPG_4BIT2(.P (P[11:8]),   .G (G[11:8]),   .Cin (MUXOUT[1]),  .S (S[11:8]),   .Cout (C[2]) );
  assign MUXOUT[2] = &P[11:8] ? MUXOUT[1] : C[2] ;
  //
  CREATE_PG_4BIT CREATE_PG_4BIT3(.A (A[15:12]), .B (B[15:12]),  .P (P[15:12]), .G (G[15:12]));
  FULL_ADDER_withPG_4BIT uFULL_ADDER_withPG_4BIT3(.P (P[15:12]),   .G (G[15:12]),   .Cin (MUXOUT[2]),  .S (S[15:12]),   .Cout (C[3]) );
  assign Cout = &P[15:12] ? MUXOUT[2] : C[3] ;
  //
endmodule :CARRY_SKIP_ADDER_16BIT  
 
 
 
module CARRY_SKIP_ADDER_16BIT_tb();

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
   for(int i=0;i<500;i++)
   begin
      A = $random;
      B = $random;
      Cin = $random;
      ex_result = A + B + Cin;
      #2;
      if(ex_result!={Cout,S}) error++;
      #2;
   end 
   
   if(error == 0) $display("NO ERROR!");
   else $display("%d ERRORS!",error);

end 


// DUT INSTANTIATION 
CARRY_SKIP_ADDER_16BIT uCARRY_SKIP_ADDER_16BIT0(.*);
endmodule 
