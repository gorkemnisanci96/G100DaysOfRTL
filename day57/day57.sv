`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Dual Edge Triggered Flip Flop 



//==========================
// DUT 
//==========================
module day57_v1(
   input  logic clk,
   input  logic rstn,
   input  logic D,  
   output logic Q 
    );
    
    
logic n,p;

//==========
// Negative Edge Triggered Flip-Flop
//==========
always_ff @(negedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      n <= '0;
   end else begin
      n <= D;     
   end 
end    
    
//==========
// Positive Edge Triggered Flip-Flop
//==========
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      p <= '0;
   end else begin 
      p <= D;
   end 
end     
 
 
    
assign Q = ( (clk&p) | ((~clk)&n) );    

    
endmodule :day57_v1







//==========================
// DUT 
//==========================
module day57_v2(
   input  logic clk,
   input  logic rstn,
   input  logic D,  
   output logic Q 
    );
    
    
logic n,p;

//==========
// Negative Edge Triggered Flip-Flop
//==========
always_ff @(negedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      n <= '0;
   end else begin
      n <= D ^ p;     
   end 
end    
    
//==========
// Positive Edge Triggered Flip-Flop
//==========
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      p <= '0;
   end else begin 
      p <= D ^ n;
   end 
end     
 
 
    
assign Q = n ^ p;    

    
endmodule :day57_v2



//==========================
// TEST BENCH 
//==========================
module day57_tb();

logic clk;
logic rstn;
logic D; 
logic Q; 

//==========
// Clock Generation
//==========
initial begin
   clk = 1'b0;
   forever #10 clk = ~clk;
end 

//==========
// RESET 
//==========
task RESET();
begin
      D = 1'b0;
      //
      rstn = 1'b1;
   @(posedge clk);
      rstn = 1'b0;
   repeat(2)@(posedge clk);
      rstn = 1'b1;    
end 
endtask

//===============
// MAIN STIMULUS 
//===============
initial begin
   RESET();
   repeat(2) @(posedge clk);
   D = 1'b1;
   #50;
   D = 1'b0;
   #50;
   D = 1'b1;
   #30;
   D = 1'b0;
   $finish;
end 




// DUT0 INSTANTIATION 
day57_v1 uday57_v1(.*);
day57_v2 uday57_v2(.*);


endmodule 
