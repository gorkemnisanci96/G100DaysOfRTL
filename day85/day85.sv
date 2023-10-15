`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 


module count_1s_in_a_bus #(parameter width=8)(
   input logic [width-1:0] bus, 
   output logic [$clog2(width):0] sum
  );
  
  
always_comb 
begin
   sum = '0; 
   for(int i=0;i<width;i++)
   begin
      sum = sum + bus[i];
   end 
end   
  
  

endmodule


module count_1s_in_a_bus_tb();

parameter                width=8;
logic [width-1:0]       bus;
logic [$clog2(width):0] sum;


initial begin

   for(int i=0;i<10;i++)
   begin
      bus = $urandom; 
      #3;
      $display("BUS: %b  SUM: %d ",bus,sum);
   end  
   
   $finish;
end 

count_1s_in_a_bus  #(.width (width)) ucount_1s_in_a_bus(.*);

endmodule 
