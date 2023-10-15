`timescale 1ns / 1ps

module pattern_detector_generic
#(parameter WIDTH = 5)
(
    input logic clk, 
    input logic rstn, 
    input logic [(WIDTH-1):0] pattern, 
    input logic serial_in,
    output logic detected
);

logic [(WIDTH-1):0] lfsr; 
logic valid; 

always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      lfsr  <= 1'b1;
      valid <= 1'b0; 
   end else begin
      lfsr  <= {lfsr[WIDTH-2:0],serial_in}; 
      valid <= valid | lfsr[WIDTH-1]; 
   end 
end 


assign detected = valid ? (lfsr==pattern)  : 1'b0 ;



endmodule :pattern_detector_generic



module pattern_detector_generic_tb();

parameter WIDTH = 5;

logic               clk;
logic               rstn; 
logic [(WIDTH-1):0] pattern;
logic               serial_in;
logic               detected;

initial begin
   clk = 1'b0;
   forever #10 clk =~clk;
end 

task RESET();
begin
   rstn = 1'b1;
   repeat(2) @(posedge clk);
   rstn = 1'b0;
   repeat(2) @(posedge clk);
   rstn = 1'b1;      
end 
endtask 



initial begin
   pattern   = 'b11010;
   serial_in = 1'b0;
   RESET(); 
   
   for(int i=0;i<50;i++)
   begin
      @(posedge clk);
      serial_in = $urandom;
   end
   
   for(int i=0;i<5;i++)
   begin
      @(posedge clk);
      serial_in = pattern[i];
   end    

   for(int i=0;i<50;i++)
   begin
      @(posedge clk);
      serial_in = $urandom;
   end


   repeat(30) @(posedge clk);
   $finish; 
end 

pattern_detector_generic #( .WIDTH (WIDTH)) DUT (.*);


endmodule :pattern_detector_generic_tb 
