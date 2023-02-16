`timescale 1ns / 1ps
//////////////////////////////////////////
// Logic Design Using 2-to-1 MUXes 

module day30();



//////////////////////
// NOT GATE
// A |C     
// 0 |1
// 1 |0
logic A1,C1;
assign C1 = A1 ? 1'b0 : 1'b1; 



//////////////////////
// XOR GATE
// A B|C     
// 0 0|0
// 0 1|1
// 1 0|1
// 1 1|0
logic A2,B2,C2;

assign C2 = A2 ? (B2 ? 1'b0:1'b1)  : B2; 

//////////////////////
// NAND GATE
// A B|C     
// 0 0|1
// 0 1|1
// 1 0|1
// 1 1|0
logic A3,B3,C3;
assign C3 = A3 ? (B3?1'b0:1'b1)  : 1'b1;

//////////////////////////////
// MUX 4-to-1 
logic [1:0] In1,In2,In3,In4;
logic [1:0] Sel; 
logic [1:0] Out; 

assign Out = Sel[1]  ?  (Sel[0] ? In1 : In2) : (Sel[0] ? In3 : In4); 


endmodule:day30
