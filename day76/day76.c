`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// CLK divide by 2/3 circuit  
// 1- Every 3rd cycle needs to be swallowed. 


  
module clk_divide_by_2_by_3(
   input logic clk100M, 
   input logic rstn, 
   output logic clk100M_2by3
);


logic [1:0] cnt;
logic clken;

always_ff @(posedge clk100M or negedge rstn)
begin
   if(!rstn)
   begin
      cnt <= '0; 
   end else begin
      if(cnt == 2'd2) begin cnt <= 0;               end 
      else            begin cnt <= cnt + 1;         end 
   end 
end 



always_latch
if(!rstn)
begin
   clken <= '0;
end else begin
   if(!clk100M) begin clken <= ~cnt[1];  end 
end   


assign clk100M_2by3 = clk100M & clken;



endmodule


module clk_divide_by_2_by_3_tb();

logic clk100M;
logic rstn; 
logic clk100M_2by3;


initial begin  
   clk100M = '0;
   forever #10 clk100M = ~clk100M; 
end 


task RESET();
begin
   rstn = 1'b1; 
   repeat(2) @(posedge clk100M);
   rstn = 1'b0;
   repeat(2) @(posedge clk100M);
   rstn = 1'b1;
end 
endtask 


initial begin 
   RESET(); 

   repeat(100) @(posedge clk100M);
   $finish; 
end 



clk_divide_by_2_by_3 DUT( .*);

endmodule
