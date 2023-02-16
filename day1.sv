`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////
// The day 1 includes examples about the Packed/Unpacked array types of SystemVerilog. 
// Please refer to IEEE Std 1800-2012 for Explanation. 
//  PACKED ARRAY TYPE:
//  The term packed array is used to refer to the dimensions decleared before the identifier name.
//  Packed arrray is a mechanisim for subdividing a vector into subfields.
//  A packed array is guaranteed to be represented as a contiguous set of bits. 
//  So it is treated as a single vector. 
//   
//  UNPACKED ARRAY TYPE:
//  The term unpacked is used to refer to the dimensions declared after the data indetifier name.
//  
module day1
#(parameter DataWidth          = 32,
  parameter ShiftRegisterDepth = 8 )
(
  input logic           clk, 
  input logic           rstn,
  input logic [(DataWidth-1):0] inputstream
    );
    
    
//////////////////////////////////////////////
//
//      PACKED ARRAYS 
//
//////////////////////////////////////////////   
    
//////////
// Example 1 
///////// 
       
logic [(ShiftRegisterDepth-1):0][(DataWidth-1):0] ShiftRegister ;    
    
    
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
     ShiftRegister <= 0 ; 
   end else begin
     ShiftRegister <= {ShiftRegister[(ShiftRegisterDepth-2):0],inputstream};
   end 
end     
    
    
//////////
// Example 2 : Accessing the Individual Elements of the Packed arrays.  
/////////    
logic [1:0][7:0] packedarray1;

always_comb 
begin
    packedarray1[0] = 8'hA;
    packedarray1[1] = 8'hB;
end 

// Lets change the direction of the [1:0] to [1:0]

logic [0:1][7:0] packedarray2;

always_comb 
begin
    packedarray2[0] = 8'hA;
    packedarray2[1] = 8'hB;
end 

// Initialize the Two Dimensional Packed Array
//  Where the packedarray3[0]=1 
//            packedarray3[1]=5 
//
logic [4:0][7:0] packedarray3;
logic [4:0][7:0] packedarray4;
logic [4:0][7:0] packedarray5;

always_comb 
begin
    packedarray3 = {8'h5,8'h4,8'h3,8'h2,8'h1};
    //
    packedarray4 = 40'h123456789A;
    //
    packedarray5[0] = 8'h9A;
    packedarray5[1] = 8'h78;
    packedarray5[2] = 8'h56;
    packedarray5[3] = 8'h34;
    packedarray5[4] = 8'h12;
end     
    
//////////////////////////////////////////////
//
//      UNPACKED ARRAYS 
//
//////////////////////////////////////////////   


//////////
// Example 1 : 
///////// 
logic unpackedarray1 [0:7][0:2];

always_comb
begin
  unpackedarray1[0][0] = 1;
  unpackedarray1[0][1] = 0;
  unpackedarray1[0][2] = 0;
  //
  unpackedarray1[7][0] = 1;
  unpackedarray1[7][1] = 1;
  unpackedarray1[7][2] = 0;
  //
  //unpackedarray[5] = 3'b101; THIS IS NOT ALLOWED 
  //0
end 


    
//////////////////////////////////////////////
//
//   MIX PACKED/UNPACKED ARRAYS 
//
//////////////////////////////////////////////   

//////////
// Example 1 : 
///////// 

logic [7:0] mixarray1 [4:0];
logic [7:0] mixarray2 [4:0];


always_comb 
begin
   mixarray1[0] = 8'h11;
   mixarray1[1] = 8'h12;
   mixarray1[2] = 8'h13;
   mixarray1[3] = 8'h14;
   mixarray1[4] = 8'h15;
   //
   //mixarray2 = 40'h123456789A; THIS IS NOT ALLOWED
   //
    mixarray2 = {8'h15,8'h14,8'h13,8'h12,8'h11};   
    //
    mixarray2 = {mixarray2[3:0],mixarray2[4]};
    //
end 

//////////
// Example 2: ShiftRegister Using Mix Packed-Unpacked Array
///////// 
logic [(DataWidth-1):0] mixarray3 [(ShiftRegisterDepth-1):0] ;


always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    for(int i=0;i<ShiftRegisterDepth;i++)
    begin
        mixarray3[i] <= 0; 
    end 
  end else begin
       mixarray3 <= {mixarray3[(ShiftRegisterDepth-2):0],inputstream};
  end 
end 





    
endmodule

//////////////////////////////////////////////
//
//           TEST BENCH 
//
//////////////////////////////////////////////

module day1_tb();


parameter DataWidth          = 32;
parameter ShiftRegisterDepth = 8;
  
  
logic clk;
logic rstn;
logic [(DataWidth-1):0] inputstream;
logic [7:0] inputstream2;


initial begin
 clk=1'b0;
 fork
  forever #10 clk = ~clk; 
 join
end 

task RESET();
begin
 rstn = 1'b1;
 @(posedge clk);
 rstn = 1'b0;
 repeat(2) @(posedge clk);
 rstn = 1'b1;
 repeat(2) @(posedge clk);
end 
endtask

//////////
// Stimulus for Example : The number 5 is just a random number to overflow the ShiftRegister. 
///////// 
initial begin
inputstream = 0;
RESET();
 for(int i=0;i<(ShiftRegisterDepth+5);i++)
 begin
     @(posedge clk);
     inputstream = i;
 end 
$finish;
end 




day1
#(.DataWidth          (DataWidth),
  .ShiftRegisterDepth (ShiftRegisterDepth) )
uday1 (.*);

endmodule 

