`timescale 1ns / 1ps
///////////////////////////////////////////////////////
// Parallel to Serial Converter (LSB FIRST)
// The Valid Bit indicates that the single bit output is valid 

module day12
#(parameter DATAWIDTH = 8)
(
input logic clk,
input logic rstn,
//
input logic [(DATAWIDTH-1):0] i_Data, 
input logic                   i_DataReady, 
//
output logic                  o_SerialOutValid, 
output logic                  o_SerialOut
    );
    
    
logic [3:0] [7:0] MEM [1<<4];    
    
    
parameter IDLE=1'b0,
          SEND=1'b1;      

logic                       State,StateNext; 
logic [(DATAWIDTH-1):0]     DataReg,DataRegNext; 
logic                       SerialOutValidNext;
logic [$clog2(DATAWIDTH):0] SerialOutIndex,SerialOutIndexNext;
logic                       SerialOutNext;
   
always_comb
begin
StateNext          = State;
DataRegNext        = DataReg;
SerialOutValidNext = o_SerialOutValid;
SerialOutIndexNext = 0;
SerialOutNext      = o_SerialOut;
   case(State)
      IDLE:
      begin
        if(i_DataReady)
        begin
                                      StateNext = SEND;
        DataRegNext = i_Data; // Sample the Input data
        end 
      end 
      SEND:
      begin
        if(SerialOutIndex<DATAWIDTH)
        begin
          SerialOutValidNext = 1'b1; 
          SerialOutNext      = DataReg[SerialOutIndex];
          SerialOutIndexNext = SerialOutIndex + 1;
        end else begin
                                     StateNext = IDLE;
          SerialOutValidNext = 1'b0;
      end 
      end 
   endcase 


end     
    


////////////////////////////////
// REGISTERS 
///////////////////////////////

always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
   DataReg          <= 0;
   o_SerialOutValid <= 0;
   SerialOutIndex   <= 0;
   o_SerialOut      <= 0;  
  end else begin
   DataReg          <= DataRegNext;
   o_SerialOutValid <= SerialOutValidNext;
   SerialOutIndex   <= SerialOutIndexNext;
   o_SerialOut      <= SerialOutNext;
  end 
end 

////////////////////////////////
// STATE REGISTER 
///////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    State <= IDLE;
  end else begin
    State <= StateNext;
  end 
end 


    
endmodule




module day12_tb();

// 
parameter DATAWIDTH = 8;
//
logic clk;
logic rstn;
//
logic [(DATAWIDTH-1):0] i_Data;
logic                   i_DataReady; 
//
logic                  o_SerialOutValid;
logic                  o_SerialOut;
// 
 

////////////////////////////////
//  CLOCK GENERATION 
///////////////////////////////
initial begin
 clk = 1'b0;
 forever #10 clk = ~clk; 
end 

////////////////////////////////
//  RESET TASK 
///////////////////////////////
task RESET();
begin
  i_DataReady = 1'b0;
  rstn = 1'b1;
  @(posedge clk);
  rstn = 1'b0;
  repeat(2) @(posedge clk);
  rstn = 1'b1;
end 
endtask 

////////////////////////////////
//  SEND PARALLEL DATA 
///////////////////////////////
task SEND(input logic [(DATAWIDTH-1):0] data);
begin
    i_DataReady = 1'b0;
    @(posedge clk);
    i_DataReady = 1'b1;
    i_Data = data;
    @(posedge clk);
    i_DataReady = 1'b0;
end 
endtask 
 

initial begin
RESET();
repeat(2) @(posedge clk);
SEND(8'h12);
repeat(2) @(posedge clk);
@(posedge clk iff(o_SerialOutValid == 1'b0));
SEND(8'h34);
repeat(2) @(posedge clk);
@(posedge clk iff(o_SerialOutValid == 1'b0));
SEND(8'h55);
repeat(2) @(posedge clk);
@(posedge clk iff(o_SerialOutValid == 1'b0));
$finish;
end  
 
    


day12
#( .DATAWIDTH (DATAWIDTH))
uday12
(.*);

endmodule 
