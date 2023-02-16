`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  Keep the least significant '1' and make the rest of the array zero using Generate Constructs 
// 

module day2
#(parameter ARRAYSIZE = 4)
(
input logic [(ARRAYSIZE-1):0] array1,
output logic [(ARRAYSIZE-1):0] array1_out
 );


genvar i;
assign array1_out[0] = array1[0]; 
generate 
   for(i=1;i<ARRAYSIZE;i++)
   begin
       assign array1_out[i] = array1[i] &   (~|array1[(i-1):0]); 
   end 
endgenerate 


endmodule

///////////////////////////////////
// TEST BENCH 
///////////////////////////////////
module day2_tb();


parameter ARRAYSIZE = 7;

logic [(ARRAYSIZE-1):0] array1;
logic [(ARRAYSIZE-1):0] array1_out;

logic clk;
initial begin
 clk=1'b0;
 fork
  forever #10 clk = ~clk; 
 join
end 


initial begin
for(int k =0; k<25;k++)
begin
  @(posedge clk);
  for(int i=0;i<ARRAYSIZE;i++)
  begin
    array1[i] = $random; 
  end 
end 
end 

/////////////////
// The Module Instantiation 
/////////////////

day2
#(.ARRAYSIZE (ARRAYSIZE))
uday2 (.*);



endmodule :day2_tb



