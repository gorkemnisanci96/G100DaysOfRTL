`timescale 1ns / 1ps
// PATERN DETECTOR with Two Shift Registers 
// Shift Register 1: MSB arrives First 
// Shift Register 2: LSB arrives First 





module day19
#(parameter DATAWIDTH = 8)
(
   input logic clk,                             // Clock 
   input logic rstn,                            // Active Low Asynchronous Reset
   //
   input logic                   i_Stream,      // Serial BitStream 
   input logic                   i_Valid,       // Bit-Stream Valid
   input logic [(DATAWIDTH-1):0] i_Pattern,     // Pattern Input
   output logic                  o_DetectFlag1, // Pattern Detected Flag for shiftReg 1
   output logic                  o_DetectFlag2  // Pattern Detected Flag for shiftReg 2
    );
    
    
logic [(DATAWIDTH-1):0] ShftReg1;    
logic [(DATAWIDTH-1):0] ShftReg2;    
logic [(DATAWIDTH-1):0] ValidReg;    
logic                   ValigFlag;
    
    
    
// SHIFT REGISTER 1 [SHIFTS THE BIT FROM THE LOWER END]      
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      ShftReg1 <= 0;
   end  
   else if(i_Valid == 1'b1) begin
      ShftReg1 <= {ShftReg1[(DATAWIDTH-2):0],i_Stream};
   end
end     
  
// SHIFT REGISTER 2   
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      ShftReg2 <= 0;
   end else if(i_Valid) 
   begin
      ShftReg2 <= {i_Stream,ShftReg2[(DATAWIDTH-1):1]};
   end 
end  
 
 
 
  
    
    
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      ValidReg <= 0;
   end else if(i_Valid == 1'b1)
   begin
      ValidReg <= {ValidReg[(DATAWIDTH-2):0],1'b1};
   end
end 
    
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      ValigFlag <= 1'b0;
   end else begin
      ValigFlag <= ValigFlag | ValidReg[(DATAWIDTH-1)];
   end 
end     
    
    
    
    
//  PATAERN DETECTED FLAG Generation     
assign o_DetectFlag1 = ValigFlag & (ShftReg1 == i_Pattern);
assign o_DetectFlag2 = ValigFlag & (ShftReg2 == i_Pattern);

    
    
endmodule :day19


///////////////////////////////
//   TEST BENCH 
//////////////////////////////

module day19_tb();

parameter DATAWIDTH = 8;

logic                   clk;
logic                   rstn; 
//
logic                   i_Stream;
logic [(DATAWIDTH-1):0] i_Pattern; 
logic                   o_DetectFlag1;  
logic                   o_DetectFlag2;  
logic                   i_Valid;

////////////////////
// Clock Generation 
///////////////////
initial begin
   clk = 1'b0;
   fork
      forever #10 clk = ~clk;
   join
end 

///////////////
// RESET TASK
//////////////
task RESET();
begin
   i_Stream = 0;
   i_Pattern =8'h7C;
   i_Valid = 1'b0;
   //
   rstn = 1'b1;
   @(posedge clk);
   rstn = 1'b0;
   repeat(2) @(posedge clk);
   rstn = 1'b1;
end 
endtask 


initial begin
  RESET();
  repeat(10) @(posedge clk);
  for(int i=0;i<100;i++)
  begin
     @(posedge clk);
     i_Valid  = 1'b1;
     i_Stream = $random;
  end 

  repeat(20) @(posedge clk);
  $finish;
end 


//////////////////////////
//  DUT INSTANTIATION 
//////////////////////////
day19
#( .DATAWIDTH (DATAWIDTH))
uday19
(.*);


endmodule :day19_tb 
