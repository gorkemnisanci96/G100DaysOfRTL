`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Parallel to Serial Converter With Ready/Valid Signals (LSB First)
// The Width of the Data is Parameterizable  
// The design keeps the each serial output "KEEP" CC steady.

module day20
#( parameter DATAWIDTH = 8,
   parameter KEEP = 3)
(
   input logic clk,
   input logic rstn, 
   //
   input logic [(DATAWIDTH-1):0] i_DataIn,
   input logic                   i_DataInReady,
   //
   output logic                  o_DataOut,
   output logic                  o_DataOutValid
    );
    
    
localparam S_IDLE    = 1'b0,
           S_CONVERT = 1'b1;

logic State, StateNext; 
logic [(DATAWIDTH-1):0]     Data,DataNext;
logic                       o_DataOutNext;
logic [$clog2(DATAWIDTH):0] Counter,CounterNext; 
logic                       o_DataOutValidNext;
logic [$clog2(DATAWIDTH):0] Counter2,Counter2Next;  
logic                       Check; 
 
 

 
 
 
always_comb
begin
   StateNext          = State;
   DataNext           = Data;
   CounterNext        = Counter;
   o_DataOutNext      = o_DataOut;
   o_DataOutValidNext = o_DataOutValid;
   Counter2Next       = Counter2;
   case(State)
      S_IDLE:
      begin
         Check =0;
         CounterNext = 0;
         if(i_DataInReady == 1'b1)
         begin
            DataNext = i_DataIn;
                                         StateNext = S_CONVERT;  
         end 
      end 
      S_CONVERT:
      begin
        if(Counter2 < (KEEP-1))
        begin
           Counter2Next = Counter2 + 1;
        end else begin
           Counter2Next = 0;
        end 
      
        Check = (o_DataOutValid ? (Counter2 == (KEEP-1))  : 1'b1);
       
       if(Check == 1'b1)
       begin
          if(Counter < DATAWIDTH )
          begin
             CounterNext = Counter + 1;
             o_DataOutNext = Data[Counter];
             o_DataOutValidNext = 1'b1;
          end else begin
             CounterNext = 0;
             o_DataOutValidNext = 1'b0;
                                             StateNext = S_IDLE; 
          end 
       end 
      end 
   endcase 
end 


////////////////////////////////
// STATE REGISTER 
////////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
       State <= S_IDLE; 
    end else begin
       State <= StateNext; 
    end 
end 


////////////////////////////////
// REGISTERS 
////////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
       Data           <= 0;
       Counter        <= 0;
       o_DataOutValid <= 0;   
       o_DataOut      <= 0; 
       Counter2       <= 0;
    end else begin
       Data           <= DataNext;
       Counter        <= CounterNext;
       o_DataOutValid <= o_DataOutValidNext; 
       o_DataOut      <= o_DataOutNext;  
       Counter2       <= Counter2Next;
    end 
end 




    
endmodule :day20 


module day20_tb();

parameter DATAWIDTH = 8;
parameter KEEP = 5;
//
logic clk;
logic rstn; 
//
logic [(DATAWIDTH-1):0] i_DataIn;
logic                   i_DataInReady;
//
logic                   o_DataOut;
logic                   o_DataOutValid;

// Clock Generation 
initial begin
   clk = 1'b0;
   fork
      forever #10 clk = ~clk;
   join
end 


// RESET TASK 
task RESET();
begin
    i_DataIn = 0;
    i_DataInReady = 1'b0;
    //
    rstn = 1'b1;
    @(posedge clk);
    rstn = 1'b0;
    repeat(2) @(posedge clk);
    rstn = 1'b1;
end 
endtask 

task SEND( input logic [(DATAWIDTH-1):0] Data );
begin
    @(posedge clk);
    i_DataIn      = Data;
    i_DataInReady = 1'b1;
    @(posedge clk);
    i_DataInReady = 1'b0;
    @(posedge clk);
    @(posedge clk iff(~o_DataOutValid));
end 
endtask



initial begin
  RESET();
  repeat(2) @(posedge clk);
  SEND(8'h15);
  SEND(8'h35);
  SEND(8'h12);
$finish;
end 


///////////////////////
// DUT INSTANTIATION 
//////////////////////
day20
#( .DATAWIDTH (DATAWIDTH),
   .KEEP      (KEEP))
uday20
(.*);
    



endmodule :day20_tb
