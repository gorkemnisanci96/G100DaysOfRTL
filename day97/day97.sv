`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Bubble Sort Algorithm to sort M, N-bit numbers 
//////////////////////////////////////////////////////////////////////////////////


module bubble_sort
#(parameter M=16,parameter N=8)
(
   input logic [(M-1):0][(N-1):0] i_array, 
   output logic [(M-1):0][(N-1):0] o_array
    );
    
logic [(M-1):0][(N-1):0] o_array_temp;    
logic [(N-1):0] temp;   
    
     
always_comb
begin
   o_array_temp = i_array;
   
   for(int i=M; i>0; i=i-1)
   begin
      for(int j=0; j<i; j=j+1)
      begin
          if( o_array_temp[j] < o_array_temp[j+1])begin 
              temp              = o_array_temp[j];
              o_array_temp[j]   = o_array_temp[j+1];     
              o_array_temp[j+1] = temp;
          end 
      end    
   end 

   o_array = o_array_temp;


end     



    
    
endmodule :bubble_sort


module bubble_sort_tb();
    
parameter M=8;
parameter N=8;
logic [(M-1):0][(N-1):0] i_array;
logic [(M-1):0][(N-1):0] o_array;


initial begin
   for(int i=7;i>=0;i=i-1)
   begin
      i_array[i] =i; 
   end 
   $display("Unsorted Array");
   for(int i=0;i<8;i=i+1)
   begin
    $display("array[%d]=%d",i,i_array[i]);
   end 
#10;
   $display("sorted Array");
   for(int i=0;i<8;i=i+1)
   begin
    $display("array[%d]=%d",i,o_array[i]);
   end 


end 

// DUT Instantiation
bubble_sort  #(.M (M),.N (N)) DUT (.*);


endmodule :bubble_sort_tb
