`timescale 1ns / 1ps


module rising_and_falling_edge_cnt
#(parameter WIDTH = 5)
(
   input logic               clk, 
   input logic               rstn,
   input logic               A, 
   output logic [(WIDTH-1):0] cnt_rising, 
   output logic [(WIDTH-1):0] cnt_falling    
    );


logic prev;    
    
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      cnt_rising  <= '0;
      cnt_falling <= '0;
      prev        <= '0;
   end else begin
      prev <= A; 
      
      if((A == 1'b1) && (prev == 1'b0)) begin 
         cnt_rising  <= cnt_rising + 1;   
      end 

      if((A == 1'b0) && (prev == 1'b1)) begin 
         cnt_falling <= cnt_falling + 1;   
      end    
   
   end 
end     
    
    
endmodule :rising_and_falling_edge_cnt


module rising_and_falling_edge_cnt_tb();
    
    
parameter WIDTH = 5;


logic               clk;
logic               rstn;
logic [(WIDTH-1):0] cnt_rising;
logic [(WIDTH-1):0] cnt_falling; 
logic               A;

initial begin
   clk = 1'b0;
   forever #10 clk = ~clk;
end 


task RESET();
begin
   A = 1'b0;
   //
   rstn = 1'b1;
   repeat(2) @(posedge clk);
   rstn = 1'b0; 
   repeat(2) @(posedge clk);
   rstn = 1'b1;    
end 
endtask



initial begin
   RESET(); 
   
   for(int i =0;i<30;i++)
   begin
      @(posedge clk);
      A <= $urandom;   
   end 
   
   repeat(30) @(posedge clk);
   $finish;
end 


rising_and_falling_edge_cnt #(.WIDTH (WIDTH)) DUT (.*);



endmodule 
