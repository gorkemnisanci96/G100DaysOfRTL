`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////
// Simple PWM Signal Generator: Divide the Signal by 100 and generate a PWM signal with a given DUTY CYCLE 
// 
//


module day3
#(parameter DUTYCYCLE = 25)
(
  input logic clk, 
  input logic rstn, 
  output logic pwm 
    );
    
logic [($clog2(100)):0] count;    
 

assign pwm = (count < DUTYCYCLE) ? 1'b1 : 1'b0;


////////////////////////////////////////
// Generate a clock 
///////////////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin

  if(!rstn)
  begin
      count <= 0; 
  end else begin
    if(count == 99)
    begin
      count <= 0;
    end else begin
      count <= count + 1;
    end      
  end 
  
end 


endmodule :day3



module day3_tb();


parameter DUTYCYCLE = 25;

logic clk; 
logic rstn; 
logic pwm;

initial begin
  clk = 1'b0;
  forever #10 clk = ~clk; 
end 

initial begin
rstn = 1'b1; 
repeat(2) @(posedge clk);
rstn = 1'b0;
repeat(2) @(posedge clk);
rstn = 1'b1;

repeat(1500) @(posedge clk);
$finish;
end 






day3
#(.DUTYCYCLE (DUTYCYCLE))
uday3
(
  .clk  (clk), 
  .rstn (rstn), 
  .pwm  (pwm)
    );

endmodule :day3_tb
