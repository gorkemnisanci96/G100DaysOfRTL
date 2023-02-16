`timescale 1ns / 1ps


module day10
#(parameter DATAWIDTH = 32,
  parameter OPLENGTH  = 10)
(
  input logic clk,
  input logic rstn,
  input logic                    i_DataInReady,
  input logic [(DATAWIDTH-1):0]  i_DataIn,
  //
  output logic o_NotBusy, 
  //
  output logic                    o_DataOutReady,
  output logic [(DATAWIDTH-1):0]  o_DataOut
    );
    

localparam  [2:0] STATEWAIT = 3'b000; 
localparam  [2:0] OPERATION = 3'b111; 



logic [2:0]             state, state_next;
logic [(DATAWIDTH-1):0] data , data_next; 
logic                   op_start, op_start_next;
logic [(DATAWIDTH-1):0] o_DataOut_next; 
logic                   o_DataOutReady_next;
//
logic [(OPLENGTH-1):0][(DATAWIDTH-1):0] OpDataPipelineSim;    
logic [(OPLENGTH-1):0]                  OpReadyPipelineSim;    

 
 
 
    
always_comb
begin
   state_next          = state;
   data_next           = data;
   o_DataOut_next      = o_DataOut;
   o_DataOutReady_next = 1'b0;
   op_start_next       = 1'b0;
   case(state)
       STATEWAIT: 
       begin
         if(i_DataInReady == 1'b1)
         begin
                                              state_next = OPERATION;
           data_next  = i_DataIn;
           op_start_next = 1'b1;
         end 
       end 
       OPERATION: 
       begin
         op_start_next = 1'b0;
         
         if(OpReadyPipelineSim[(OPLENGTH-1)] == 1'b1)  // WAIT TO GET A OPERATIONDONE signal from the Operation Module 
         begin
                                              state_next       = STATEWAIT;
           o_DataOut_next      = OpDataPipelineSim[(OPLENGTH-1)];
           o_DataOutReady_next = 1'b1;
         end 
       end         
  endcase 
end     
    

assign o_NotBusy = (state == STATEWAIT);

    

// This Registers Simulate a "OPLENGTH-stage" Pipeline
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
     OpDataPipelineSim <= 0;
   end else begin
     OpDataPipelineSim <= {OpDataPipelineSim[OPLENGTH-2:0],data};
   end 
end     
    
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
     OpReadyPipelineSim <= 0;
   end else begin
     OpReadyPipelineSim <= {OpReadyPipelineSim[OPLENGTH-2:0],op_start};
   end 
end     
        
// REGISTERS     
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
       state          <= STATEWAIT;
       data           <= 0;
       o_DataOut      <= 0;
       o_DataOutReady <= 0;
       op_start       <= 0;
   end else begin
       state               <= state_next;
       data                <= data_next;
       o_DataOut           <= o_DataOut_next;
       o_DataOutReady      <= o_DataOutReady_next;
       op_start            <= op_start_next;
   end 
end        
    
    

endmodule



////////////////////////////////
//     TEST BENCH 
////////////////////////////////
module day10_tb ();



parameter DATAWIDTH = 32;
parameter OPLENGTH  = 10;
logic clk;
logic rstn;
logic                    i_DataInReady;
logic [(DATAWIDTH-1):0]  i_DataIn;
  //
logic o_NotBusy; 
  //
logic                    o_DataOutReady;
logic [(DATAWIDTH-1):0]  o_DataOut;


initial begin
clk = 1'b0;
fork
 forever #10 clk = ~clk;
join
end 

task RESET();
begin
    i_DataInReady = 1'b0;
    rstn = 1'b1;
    @(posedge clk);
    rstn = 1'b0;
    repeat(2) @(posedge clk);
    rstn = 1'b1;
end 
endtask

task SENDDATA(input logic [(DATAWIDTH-1):0] data);
begin
   @(posedge clk);
   i_DataInReady = 1'b1;
   i_DataIn   = data;
   @(posedge clk);
   i_DataInReady = 1'b0;
end 
endtask



initial begin
RESET();
repeat(10) @(posedge clk);
SENDDATA(12);
@(posedge clk iff (o_NotBusy==1'b1));
SENDDATA(20);
@(posedge clk iff (o_NotBusy==1'b1));
SENDDATA(35);
@(posedge clk iff (o_NotBusy==1'b1));
repeat(10) @(posedge clk);
$finish;
end 




day10
#(.DATAWIDTH (DATAWIDTH),
  .OPLENGTH  (OPLENGTH))
uday10
(.*);
    


endmodule 


