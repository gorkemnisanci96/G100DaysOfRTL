`timescale 1ns / 1ps
// Clock Divider Circuit for 2,3,4,5; 


module day21(
   input logic clk,
   input logic rstn,
//
   output logic o_clk_div2,
   output logic o_clk_div3,
   output logic o_clk_div4,
   output logic o_clk_div5
    );
    
logic [1:0] count_mod3;
logic [2:0] count_mod5;
logic sig1,sig2;

///////////////////////////////////
// CLOCK DIVIDE BY TWO CIRCUIT
///////////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
     o_clk_div2 <= 0;
   end else begin
     o_clk_div2 <= ~o_clk_div2;
   end
end   
  
///////////////////////////////////
// CLOCK DIVIDE BY THREE CIRCUIT
///////////////////////////////////   
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
     count_mod3 <= 0;
   end else begin
     //
     if(count_mod3== 2'd2)
     begin
        count_mod3 <= 0;
     end else begin
        count_mod3 <= count_mod3 + 1;
     end 
     // 
   end
end   

always_ff @(negedge clk)
begin
  sig1 <= count_mod3[0];
end 

assign o_clk_div3 = sig1 | count_mod3[1];
    
    
 ///////////////////////////////////
// CLOCK DIVIDE BY FOUR CIRCUIT
///////////////////////////////////
always_ff @(posedge o_clk_div2 or negedge rstn)
begin
   if(!rstn)
   begin
     o_clk_div4 <= 0;
   end else begin
     o_clk_div4 <= ~o_clk_div4;
   end
end   
     
     
 ///////////////////////////////////
// CLOCK DIVIDE BY FIVE CIRCUIT
///////////////////////////////////     
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
     count_mod5 <= 0;
   end else begin
     //
     if(count_mod5== 3'd4)
     begin
        count_mod5 <= 0;
     end else begin
        count_mod5 <= count_mod5 + 1;
     end 
     // 
   end
end        
     
always_ff @(negedge clk)
begin
  sig2 <= count_mod5[1];
end     
  
assign o_clk_div5 = sig2 |  count_mod5[2];
    
    
endmodule :day21



module day21_tb();

logic clk;
logic rstn;
//
logic o_clk_div2;
logic o_clk_div3;
logic o_clk_div4;
logic o_clk_div5;

initial clk = 1'b0;
always #10 clk = ~clk; 



initial begin
  rstn = 1'b1;
  @(posedge clk);
  rstn = 1'b0;
  repeat(2) @(posedge clk);
  rstn = 1'b1;
  
repeat(10) @(posedge clk);
$finish;
end 


//////////////////////////////
//     DUT INSTANTIATION 
//////////////////////////////
day21 uday21(.*);



endmodule :day21_tb 



