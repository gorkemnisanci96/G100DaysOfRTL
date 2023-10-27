`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design a 8-bit counter mod 3 without using % operator. 



module counter_8bit_skip_by_3(
 input logic        clk,
 input logic        rstn, 
 output logic [7:0] cnt_out
);


logic [7:0] cnt0;
logic [1:0] cnt1;


always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      cnt1 <= '0; 
   end else begin
      
      if(cnt1==2)
      begin
         cnt1 <= 'd1;
      end else begin
         cnt1 <= cnt1 + 1;
      end 
      
   end   
end 



always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      cnt0 <= '0; 
   end else begin
      
      if(cnt1==2)
      begin
         cnt0 <= cnt0 + 2;
      end else begin
         cnt0 <= cnt0 + 1;
      end 
      
   end   
end 



assign cnt_out = cnt0;


endmodule



module counter_8bit_skip_by_3_tb();

logic        clk;
logic        rstn; 
logic [7:0]  cnt_out;


initial begin
clk = 0;
forever #10 clk = ~clk;
end 

task RESET();
begin
   rstn = 1'b1;
   repeat(3) @(posedge clk);
   rstn = 1'b0;   
   repeat(3) @(posedge clk);
   rstn = 1'b1;  

end 
endtask 


//============================
// Main Test Sequence 
//============================
initial begin
 RESET(); 


 $finish;
end 




counter_8bit_skip_by_3 ucounter_8bit_skip_by_3( .* );



endmodule :counter_8bit_skip_by_3_tb 
