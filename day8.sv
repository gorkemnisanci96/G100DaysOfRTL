`timescale 1ns / 1ps
//////////////////////////////////////////////
// Find the Maximum and The Second Maximum number in a stream of Values.
// The numbers will Start with a Start Flag and End With Last Flag 
// Sequencial Logic 

module day8
#(parameter DATAWIDTH = 8)
(
input  logic clk,
input  logic rstn, 
input  logic Start, 
input  logic Last, 
input  logic [(DATAWIDTH-1):0] DataIn,
output logic [(DATAWIDTH-1):0] Max,
output logic [(DATAWIDTH-1):0] SecondMax
    );

localparam [1:0] S0 = 2'b00,
                 S1 = 2'b01,
                 S2 = 2'b10;    
    
logic [(DATAWIDTH-1):0] MaxNext;
logic [(DATAWIDTH-1):0] SecondMaxNext;    
logic [1:0] State, StateNext;    
    
always_comb 
begin
StateNext       = State;
MaxNext         = Max; 
SecondMaxNext   = SecondMax; 

   case(State)
      S0:
      begin
       if(Start == 1'b1) 
       begin
                                          StateNext = S1;
        MaxNext   = DataIn;
       end 
      end 
      S1:
      begin
                                          StateNext = S2;
        if(DataIn >= Max) begin MaxNext       = DataIn; SecondMaxNext = Max;  end 
        else              begin SecondMaxNext = DataIn;                       end 
      end 
      S2:
      begin
        // 
        if(DataIn > Max)              begin MaxNext       = DataIn; SecondMaxNext = Max;  end 
        else if (DataIn > SecondMax ) begin SecondMaxNext = DataIn;                       end 
        //
        if(Last == 1'b1)
        begin
                                          StateNext = S0; 
        end 
      end 
   endcase 
end     


//////////////////////////////
//  STATE REGISTER 
//////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    State <= S0;
  end else begin
    State <= StateNext;
  end 
end 


//////////////////////////////
//  Max REGISTER 
//////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    Max <= 0;
  end else begin
    Max <= MaxNext;
  end 
end 


//////////////////////////////
//  SecondMax REGISTER 
//////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    SecondMax <= 0;
  end else begin
    SecondMax <= SecondMaxNext;
  end 
end 
    
endmodule



module day8_tb();

parameter DATAWIDTH = 8;

logic clk;
logic rstn;
logic Start; 
logic Last; 
logic [(DATAWIDTH-1):0] DataIn;
logic [(DATAWIDTH-1):0] Max;
logic [(DATAWIDTH-1):0] SecondMax;

///////////////////////    
// CLOCK GENERATION    
//////////////////////     
initial begin
clk = 1'b0;
fork
 forever #10 clk = ~clk;
join

end 
  
///////////////////////    
// RESET TASK 
//////////////////////   
task RESET();
begin
   rstn = 1'b1; 
   repeat(2)@(posedge clk);
   rstn = 1'b0;
   repeat(2)@(posedge clk);
   rstn = 1'b1; 
end 
endtask  
  
  
  
  
initial begin
RESET();
Start = 1'b0;
Last  = 1'b0;
repeat(2)@(posedge clk);
Start = 1'b1;
DataIn = 78;
@(posedge clk);
Start = 1'b0;
DataIn = 12;
@(posedge clk);
DataIn = 14;
@(posedge clk);
DataIn = 7;
@(posedge clk);
DataIn = 50;
@(posedge clk);
DataIn = 47;
@(posedge clk);
DataIn = 58;
@(posedge clk);
Last  = 1'b1;
DataIn = 12;
@(posedge clk);
Last  = 1'b0;
repeat(20)@(posedge clk);
Start = 1'b0;
Last  = 1'b0;
repeat(2)@(posedge clk);
Start = 1'b1;
DataIn = 78;
@(posedge clk);
Start = 1'b0;
DataIn = 12;
@(posedge clk);
DataIn = 14;
@(posedge clk);
DataIn = 7;
@(posedge clk);
DataIn = 50;
@(posedge clk);
DataIn = 47;
@(posedge clk);
DataIn = 170;
@(posedge clk);
Last  = 1'b1;
DataIn = 200;
@(posedge clk);
Last  = 1'b0;
repeat(20)@(posedge clk);


Start = 1'b0;
Last  = 1'b0;
repeat(2)@(posedge clk);
Start = 1'b1;
DataIn = 200;
@(posedge clk);
Start = 1'b0;
DataIn = 12;
@(posedge clk);
DataIn = 14;
@(posedge clk);
DataIn = 7;
@(posedge clk);
DataIn = 200;
@(posedge clk);
DataIn = 47;
@(posedge clk);
DataIn = 170;
@(posedge clk);
Last  = 1'b1;
DataIn = 200;
@(posedge clk);
Last  = 1'b0;
repeat(20)@(posedge clk);
$finish;
end   
  
     
///////////////////////    
// MODULE INSTANTIATION     
//////////////////////    
day8
#( .DATAWIDTH (DATAWIDTH))
uday8
(.*);    

  
endmodule :day8_tb 
