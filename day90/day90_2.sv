`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 



module pattern_detector_fsm
#(parameter WIDTH = 5, parameter PATTERN = 5'b10110)
(
    input logic clk, 
    input logic rstn, 
    input logic serial_in,
    output logic detected
);

initial begin
$display("[0]= %b ",PATTERN[0]);
$display("[1]= %b ",PATTERN[1]);
$display("[2]= %b ",PATTERN[2]);
$display("[3]= %b ",PATTERN[3]);
$display("[4]= %b ",PATTERN[4]);


end 


typedef enum{
   idle,
   bit0,
   bit1,
   bit2,
   bit3,
   bit4
} state; 

state cstate,nstate;

always_comb 
begin
   nstate = cstate;
   detected = 1'b0;
   case(cstate)
      idle: begin  
                    if(serial_in == PATTERN[0]) nstate=bit0; end 
      bit0: begin 
                    if(serial_in == PATTERN[1]) nstate=bit1;
                    else nstate=idle;
      end 
      bit1: begin 
                    if(serial_in == PATTERN[2]) nstate=bit2;
                    else nstate=idle; 
      end 
      bit2: begin 
                    if(serial_in == PATTERN[3]) nstate=bit3;
                    else nstate=idle; 
      end 
      bit3: begin 
                   if(serial_in == PATTERN[4]) detected = 1'b1;
                    nstate=idle;  
      end 
   endcase 
end 


always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      cstate <= idle;
   end else begin
      cstate <= nstate;
   end 
end 




endmodule :pattern_detector_fsm



module pattern_detector_fsm_tb();

parameter WIDTH   = 5;
parameter PATTERN = 5'b10110;

logic               clk;
logic               rstn; 
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
      serial_in = PATTERN[i];
   end    

   for(int i=0;i<50;i++)
   begin
      @(posedge clk);
      serial_in = $urandom;
   end


   repeat(30) @(posedge clk);
   $finish; 
end 

pattern_detector_fsm #( .WIDTH (WIDTH)) DUT (.*);


endmodule :pattern_detector_fsm_tb 
