`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 32-bit CARRY-SELECT-ADDER 
// 

//===================================
// CARRY CIRCUIT WITH P G 
//===================================
module CARRY_CIRCUIT_WITHPG
(
    input  logic P,   // Propagate 
    input  logic G,   // Generate 
    input  logic Cin, // Carry Input bit  
    output logic Cout // Carry Output bit 
);

 logic t1;
 
 and and1(t1,P,Cin);
 or  or1(Cout,G,t1); 


endmodule :CARRY_CIRCUIT_WITHPG 


//===================================
// SUM CIRCUIT WITH P G 
//===================================
module SUM_CIRCUIT_WITHPG
(
    input  logic P,   // Propagate 
    input  logic Cin, // Carry-in 
    output logic S    // Sum Output bit  
);

   xor xor1(S,P,Cin);

endmodule :SUM_CIRCUIT_WITHPG 

//============================
// Create 4-BIT Propagate-Generate Signals
//============================
module CREATE_PG_4BIT_
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


endmodule :CREATE_PG_4BIT_  


//=====================================
// 4-BIT CARRY-SELECT-ADDER 
//=====================================
module CARRY_SELECT_ADDER_4BIT(
    input  logic [3:0] P,   // Propagate 
    input  logic [3:0] G,   // Generate 
    input  logic       Cin, // Carry Input bit  
    output logic [3:0] S,   // Sum 
    output logic       Cout // Carry Output bit 
    );

logic [3:0] C,C0,C1;

// FIRST RIPPLE CARRY CALCULATION WITH Cin=0
CARRY_CIRCUIT_WITHPG uCARRY_CIRCUIT_WITHPG00(.P (P[0]),   .G (G[0]),  .Cin (1'b0),  .Cout (C0[0]) );
CARRY_CIRCUIT_WITHPG uCARRY_CIRCUIT_WITHPG01(.P (P[1]),   .G (G[1]),  .Cin (C0[0]), .Cout (C0[1]) );
CARRY_CIRCUIT_WITHPG uCARRY_CIRCUIT_WITHPG02(.P (P[2]),   .G (G[2]),  .Cin (C0[1]), .Cout (C0[2]) );
CARRY_CIRCUIT_WITHPG uCARRY_CIRCUIT_WITHPG03(.P (P[3]),   .G (G[3]),  .Cin (C0[2]), .Cout (C0[3]) );


// FIRST RIPPLE CARRY CALCULATION WITH Cin=1
CARRY_CIRCUIT_WITHPG uCARRY_CIRCUIT_WITHPG10(.P (P[0]),   .G (G[0]),  .Cin (1'b1),  .Cout (C1[0]) );
CARRY_CIRCUIT_WITHPG uCARRY_CIRCUIT_WITHPG11(.P (P[1]),   .G (G[1]),  .Cin (C1[0]), .Cout (C1[1]) );
CARRY_CIRCUIT_WITHPG uCARRY_CIRCUIT_WITHPG12(.P (P[2]),   .G (G[2]),  .Cin (C1[1]), .Cout (C1[2]) );
CARRY_CIRCUIT_WITHPG uCARRY_CIRCUIT_WITHPG13(.P (P[3]),   .G (G[3]),  .Cin (C1[2]), .Cout (C1[3]) );


// Carry-Select Multiplexers 
assign C = Cin ? C1 : C0;


// Sum Calculations with the Selected Carry 
SUM_CIRCUIT_WITHPG SUM_CIRCUIT_WITHPG0(.P (P[0]), .Cin (Cin),  .S (S[0]) );
SUM_CIRCUIT_WITHPG SUM_CIRCUIT_WITHPG1(.P (P[1]), .Cin (C[0]), .S (S[1]) );
SUM_CIRCUIT_WITHPG SUM_CIRCUIT_WITHPG2(.P (P[2]), .Cin (C[1]), .S (S[2]) );
SUM_CIRCUIT_WITHPG SUM_CIRCUIT_WITHPG3(.P (P[3]), .Cin (C[2]), .S (S[3]) );

// Output-Carry 
assign Cout= C[3];

endmodule :CARRY_SELECT_ADDER_4BIT 




//=====================================
// 32-BIT CARRY-SELECT-ADDER with 4-BIT CARRY-SELECT-ADDERS
//=====================================
module CARRY_SELECT_ADDER_32BIT(
    input  logic [31:0] A,   // Propagate 
    input  logic [31:0] B,   // Generate 
    input  logic        Cin, // Carry Input bit  
    output logic [31:0] S,   // Sum 
    output logic        Cout // Carry Output bit   
    );
    
logic [31:0] P;    
logic [31:0] G;    
logic [6:0]  C;

//    
CREATE_PG_4BIT_         CREATE_PG_4BIT0(.A (A[3:0]), .B (B[3:0]), .P(P[3:0]), .G(G[3:0])  );    
CARRY_SELECT_ADDER_4BIT CARRY_SELECT_ADDER_4BIT0(.P (P[3:0]), .G (G[3:0]), .Cin (Cin), .S (S[3:0]), .Cout (C[0]) );    
//    
CREATE_PG_4BIT_         CREATE_PG_4BIT1(.A (A[7:4]), .B (B[7:4]), .P(P[7:4]), .G(G[7:4])  );    
CARRY_SELECT_ADDER_4BIT CARRY_SELECT_ADDER_4BIT1(.P (P[7:4]), .G (G[7:4]), .Cin (C[0]), .S (S[7:4]), .Cout (C[1]) );   
//    
CREATE_PG_4BIT_         CREATE_PG_4BIT2(.A (A[11:8]), .B (B[11:8]), .P(P[11:8]), .G(G[11:8])  );    
CARRY_SELECT_ADDER_4BIT CARRY_SELECT_ADDER_4BIT2(.P (P[11:8]), .G (G[11:8]), .Cin (C[1]), .S (S[11:8]), .Cout (C[2]) );    
//    
CREATE_PG_4BIT_         CREATE_PG_4BIT3(.A (A[15:12]), .B (B[15:12]), .P(P[15:12]), .G(G[15:12])  );    
CARRY_SELECT_ADDER_4BIT CARRY_SELECT_ADDER_4BIT3(.P (P[15:12]), .G (G[15:12]), .Cin (C[2]), .S (S[15:12]), .Cout (C[3]) );     
//    
CREATE_PG_4BIT_         CREATE_PG_4BIT4(.A (A[19:16]), .B (B[19:16]), .P(P[19:16]), .G(G[19:16])  );    
CARRY_SELECT_ADDER_4BIT CARRY_SELECT_ADDER_4BIT4(.P (P[19:16]), .G (G[19:16]), .Cin (C[3]), .S (S[19:16]), .Cout (C[4]) ); 
//    
CREATE_PG_4BIT_         CREATE_PG_4BIT5(.A (A[23:20]), .B (B[23:20]), .P(P[23:20]), .G(G[23:20])  );    
CARRY_SELECT_ADDER_4BIT CARRY_SELECT_ADDER_4BIT5(.P (P[23:20]), .G (G[23:20]), .Cin (C[4]), .S (S[23:20]), .Cout (C[5]) ); 
//    
CREATE_PG_4BIT_         CREATE_PG_4BIT6(.A (A[27:24]), .B (B[27:24]), .P(P[27:24]), .G(G[27:24])  );    
CARRY_SELECT_ADDER_4BIT CARRY_SELECT_ADDER_4BIT6(.P (P[27:24]), .G (G[27:24]), .Cin (C[5]), .S (S[27:24]), .Cout (C[6]) ); 
//    
CREATE_PG_4BIT_         CREATE_PG_4BIT7(.A (A[31:28]), .B (B[31:28]), .P(P[31:28]), .G(G[31:28])  );    
CARRY_SELECT_ADDER_4BIT CARRY_SELECT_ADDER_4BIT7(.P (P[31:28]), .G (G[31:28]), .Cin (C[6]), .S (S[31:28]), .Cout (Cout) ); 
//    


endmodule :CARRY_SELECT_ADDER_32BIT



//=================================
// TEST BENCH 
//=================================
module CARRY_SELECT_ADDER_32BIT_tb();

logic [31:0] A;
logic [31:0] B;
logic        Cin;
logic [31:0] S;
logic        Cout;

logic [32:0] ex_result;
int error;
//
//
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
   //
   if(error == 0) $display("NO ERROR!");
   else $display("%d ERRORS!",error);
   //
end 




// DUT INSTANTIATION
CARRY_SELECT_ADDER_32BIT  uCARRY_SELECT_ADDER_32BIT(.*);

endmodule 




//=================================
// TEST BENCH 
//=================================
module CARRY_SELECT_ADDER_4BIT_tb();

localparam BITHWIDTH = 4;

logic [(BITHWIDTH-1):0] A;
logic [(BITHWIDTH-1):0] B;
logic [(BITHWIDTH-1):0] P;
logic [(BITHWIDTH-1):0] G;
logic                   Cin;
logic [(BITHWIDTH-1):0] S;
logic                   Cout;

logic [BITHWIDTH:0]     ex_result;
int error;
//
//
initial begin
   Cin = 0;
   error = 0; 
   for(int i=0;i<100;i++)
   begin
      A = $random;
      B = $random;
      P = A ^ B;
      G = A & B;
      ex_result = A + B;
      #2;
      if(ex_result!={Cout,S}) error++;
      #2;
   end 
   //
   if(error == 0) $display("NO ERROR!");
   else $display("%d ERRORS!",error);
   //
end 




// DUT INSTANTIATION
CARRY_SELECT_ADDER_4BIT  uCARRY_SELECT_ADDER_4BIT(.*);

endmodule 
