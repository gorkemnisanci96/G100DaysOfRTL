`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Clock Domain Crossing-Pulse Synchronization-Two Flip-Flop Synchronizer  

module day34
#(parameter REGNUM = 2)
( 
     input  logic clk2,
     input  logic rstn2, 
     input  logic flagInClk1, 
     output logic flagOutClk2
    );
    


logic [(REGNUM-1):0] regOut;

    
always_ff @(posedge clk2 or negedge rstn2)
begin

   if(!rstn2)
   begin
     regOut <= 0;
   end else begin
     regOut <= {regOut[REGNUM-2:0],flagInClk1};
   end 
   
end 
    
assign flagOutClk2 = regOut[REGNUM-1];    
    
    
endmodule:day34 



module day34_tb();

parameter REGNUM = 2;
parameter PERIOD1 = 10;
parameter PERIOD2 = 20;
logic clk1;
logic clk2;
logic rstn2; 
logic flagInClk1;
logic flagOutClk2;
    
// Clock Generation 
initial begin
  clk1 = 0;
  clk2 = 0;
end 
always #(PERIOD1/2) clk1 = ~clk1;
always #(PERIOD2/2) clk2 = ~clk2;

// RESET TASK
task RESET();
begin
    flagInClk1 = 1'b0;
    rstn2      = 1'b1;
    @(posedge clk2); 
    rstn2 = 1'b0;
    repeat(2)@(posedge clk2);
    rstn2 = 1'b1; 
end 
endtask

initial begin
RESET();
repeat(2) @(posedge clk1);
flagInClk1 = 1'b1;
@(posedge clk1);
flagInClk1 = 1'b0;

repeat(10) @(posedge clk1);
end 


////////////////////////////////
//  DUT INSTANTIATION 
///////////////////////////////
day34
#(.REGNUM (REGNUM))
uday34
(.*);
    

endmodule:day34_tb 
