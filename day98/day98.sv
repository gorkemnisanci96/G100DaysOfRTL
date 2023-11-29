`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// The following circuit generates random number from 1 to 6 when it receives a pulse,
//////////////////////////////////////////////////////////////////////////////////


module RNG_1_to_6(
   input logic clk,
   input logic rstn, 
   input logic pulse,
   output logic [2:0] o_rn
    );
    
    
 
 logic [2:0] cnt;
 
 
 
 always_ff @(posedge clk or negedge rstn)
 begin
    if(!rstn)
    begin
       cnt <= 3'b001;
    end else begin
       cnt[0] <= ~cnt[0];
       cnt[1] <= ((~cnt[0])&(~cnt[2])) | ((~cnt[1])&(cnt[0]));
       cnt[2] <= ((cnt[2])&(~cnt[1])) | ((cnt[1])&(cnt[0]));
    end 
 end    
  
  
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      o_rn <= 3'b001;
   end else begin
      if(pulse)
      begin
         o_rn <= cnt;
      end 
   end 
end   
  
    
    
endmodule :RNG_1_to_6


module RNG_1_to_6_tb();

logic       clk;
logic       rstn; 
logic       pulse;
logic [2:0] o_rn;
   
initial begin
   clk = 1'b0;
   forever #10 clk = ~clk;
end 

task RESET();
begin 
    pulse = 1'b0;
    //
    rstn = 1'b1;
    repeat(2) @(posedge clk);
    rstn = 1'b0;
    repeat(2) @(posedge clk);    
    rstn = 1'b1;
end 
endtask 

task gen_rn();
begin
   @(posedge clk);
   pulse <= 1'b1;
   @(posedge clk);
   pulse <= 1'b0;  
   #1;
   $display("Random Number: %d ",o_rn); 
end 
endtask



initial begin
   RESET(); 
   repeat(2) @(posedge clk);
   gen_rn();
   repeat(2) @(posedge clk);
   gen_rn();
   repeat(2) @(posedge clk);
   gen_rn();   
   repeat(2) @(posedge clk);
   gen_rn();   
   repeat(2) @(posedge clk);
   gen_rn();   
   repeat(2) @(posedge clk);
   gen_rn();         
   $finish;
end 

RNG_1_to_6 DUT(.*);


endmodule :RNG_1_to_6_tb
