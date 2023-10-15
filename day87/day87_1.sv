`timescale 1ns / 1ps


module fibonacci_sequence_sequential_ckt
#(parameter WIDTH = 5)
(
   input logic clk, 
   input logic rstn,
   output logic [(WIDTH-1):0] fib_num 
    );
    

logic [1:0][(WIDTH-1):0] array; 

    
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      fib_num <= '0; 
      array   <= '0; 
   end else begin
       if(array == '0) begin  
          fib_num <= 'd1;  
          array   <= {array[0],1'b1};
       end else begin 
          fib_num <= array[0] + array[1];
          array   <= {array[0],(array[0] + array[1])};
       end  
   end 
end 


endmodule :fibonacci_sequence_sequential_ckt



module fibonacci_sequence_sequential_ckt_tb ();
 
 
parameter WIDTH = 10; 
    
logic clk; 
logic rstn;
logic [(WIDTH-1):0] fib_num;    
    
initial begin
   clk = 1'b0;
   forever #10 clk = ~clk; 
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
   RESET(); 


   repeat(30) @(posedge clk);
   $finish; 
end  
 
 
fibonacci_sequence_sequential_ckt #(.WIDTH (WIDTH)) DUT  ( .*);   
    
endmodule 
