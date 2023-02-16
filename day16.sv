`timescale 1ns / 1ps
///////////////////////////////////////////
// Synchronous FIFO Memory 

module day16
#(parameter DATAWIDTH = 8,
  parameter FIFODEPTH = 5)
(
  input logic clk,
  input logic rstn,
  //
  input logic                   i_WrtEn,
  input logic [(DATAWIDTH-1):0] i_DataIn,
  //
  input  logic                   i_RdEn,
  output logic [(DATAWIDTH-1):0] o_DataOut,             
  //
  output logic                   o_Full,
  output logic                   o_Empty
    );
    
    
logic [(DATAWIDTH-1):0] FifoMem [(FIFODEPTH-1):0]; 
    
logic [$clog2(FIFODEPTH):0] counter;

logic [$clog2(FIFODEPTH):0] RdPtr;
logic [$clog2(FIFODEPTH):0] WrtPtr;


//////////////////////////////////////
//  MEMORY READ/WRITE REGISTER 
/////////////////////////////////////
always_ff @(posedge clk)
begin
   if(i_WrtEn && ~o_Full)
   begin
     FifoMem[WrtPtr] <= i_DataIn;
   end 
end 
    

assign o_DataOut = FifoMem[RdPtr];


//////////////////////////////////////
//  Pointer Calculations 
/////////////////////////////////////
///////////
//  WRITE POINTER  
///////////
always_ff @(posedge clk or negedge rstn)
begin 
   if(!rstn)
   begin
         WrtPtr <= 0;
   end else begin
      if(i_WrtEn && ~o_Full)
      begin
         WrtPtr <= WrtPtr + 1;
      end 
   end 
end 
///////////
//  READ POINTER  
///////////
always_ff @(posedge clk or negedge rstn)
begin 
   if(!rstn)
   begin
         RdPtr <= 0;
   end else begin
      if(i_RdEn && ~o_Empty)
      begin
         RdPtr <= RdPtr + 1;
      end 
   end 
end 

///////////
//  Counter Calculation 
///////////
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
     counter <= 0;
   end else if ( (i_WrtEn && i_RdEn) && o_Full)
   begin
     counter <= counter -1;
   end else if ( (i_WrtEn && i_RdEn) && o_Empty)
   begin
     counter <= counter + 1;
   end else if ( (i_WrtEn && i_RdEn))
   begin
     counter <= counter;
   end else if ( i_WrtEn && ~o_Full) 
   begin
     counter <= counter + 1;
   end else if (i_RdEn && ~o_Empty)
   begin
     counter <= counter - 1;
   end 
end 

assign o_Full  = (counter == (FIFODEPTH));
assign o_Empty = (counter == 0);



    
    
endmodule


module day16_tb();

parameter DATAWIDTH = 8;
parameter FIFODEPTH = 5;


logic clk;
logic rstn;
  //
logic                   i_WrtEn;
logic [(DATAWIDTH-1):0] i_DataIn;
  //
logic                   i_RdEn;
logic [(DATAWIDTH-1):0] o_DataOut;             
  //
logic                   o_Full;
logic                   o_Empty;

////////////////////
// CLOCK GENERATION
///////////////////
initial begin
clk = 1'b0;
fork
 forever #10 clk = ~clk;
join
end 

////////////////////
// RESET TASK
///////////////////
task RESET();
begin
   i_RdEn  = 1'b0;
   i_WrtEn = 1'b0;
   //
   rstn = 1'b1;
   @(posedge clk);
   rstn = 1'b0;
   repeat(2) @(posedge clk);
   rstn = 1'b1;
end 
endtask 

////////////////////////
//  PUSH TASK (Pushes Data Into the FIFO Mem)
//////////////////////
task PUSH(input logic [(DATAWIDTH-1):0] Data);
begin
  @(posedge clk);
    i_DataIn = Data;
    i_WrtEn = 1'b1;
  @(posedge clk);
    i_WrtEn = 1'b0;
end 
endtask 

/////////////////////
//  PULL TASK 
////////////////////
task PULL();
begin
  @(posedge clk); #1;
     i_RdEn = 1'b1;
     $display("THE DATA PULLED %d",o_DataOut); 
  @(posedge clk); #1;
     i_RdEn = 1'b0; 
     
end 
endtask 


initial begin
  RESET();
  PUSH(1);
  PUSH(2);
  PUSH(3);
  PUSH(4);
  PUSH(5);
  PUSH(6);
  // 
  PULL();
  PULL();
  PULL();
  PULL();
  PULL();
  PULL();
  //
  

  $finish; 
end 


////////////////////////
//  DUT INSTANTIATION 
///////////////////////
day16
#( .DATAWIDTH (DATAWIDTH),
   .FIFODEPTH (FIFODEPTH))
uday16
(.*);
    


endmodule :day16_tb 



