`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// THE circuit is designed to detect the sequence 'b1010 with MEALY state machine and overlapping
//////////////////////////////////////////////////////////////////////////////////


module sequence_detector_MealyFSM_Overlapping(
   input  logic clk, 
   input  logic rstn, 
   input  logic i_stream, 
   output logic o_detected  
    );
    
    
    
logic [1:0] cstate;    
    
    
    
always_ff @(posedge clk or negedge rstn)
begin 

   if(!rstn)
   begin 
      cstate <= '0; 
   end else begin
      cstate[0] <= i_stream;
      cstate[1] <= (i_stream&cstate[1]&(~cstate[0])) | ((~i_stream)&cstate[0]);
   end 
   
end     
    
assign o_detected = (~i_stream)&cstate[1]&cstate[0];
    
    
    
endmodule :sequence_detector_MealyFSM_Overlapping


module sequence_detector_MealyFSM_Overlapping_TB();

logic clk; 
logic rstn; 
logic i_stream; 
logic o_detected;  
   
   
initial begin 
   clk = 1'b0;
   forever #10 clk = ~clk; 
end    
   
task RESET();
begin
   i_stream = 1'b0;  
   //
   rstn <= 1'b1;
   repeat(2) @(posedge clk);
   rstn <= 1'b0;
   repeat(2) @(posedge clk); 
   rstn <= 1'b1;
end 
endtask    
   
   
initial begin 
   RESET();
   @(posedge clk); 
   i_stream <= 1'b0;
   @(posedge clk); 
   i_stream <= 1'b0;
   @(posedge clk); 
   i_stream <= 1'b1;
   @(posedge clk); 
   i_stream <= 1'b0;
   @(posedge clk); 
   i_stream <= 1'b1;
   @(posedge clk); 
   i_stream <= 1'b0;
   @(posedge clk); 
   i_stream <= 1'b1;  
   @(posedge clk); 
   i_stream <= 1'b0;
   @(posedge clk); 
   i_stream <= 1'b1;
   @(posedge clk); 
   i_stream <= 1'b0;
   @(posedge clk); 
   i_stream <= 1'b0;
   @(posedge clk); 
   i_stream <= 1'b1;      
   @(posedge clk); 
   i_stream <= 1'b0;  
   @(posedge clk); 
   i_stream <= 1'b1; 
   @(posedge clk); 
   i_stream <= 1'b0;     
   repeat(100) @(posedge clk);
   $finish; 
end    
   
//=======================================
// DUT Instantiation    
//=======================================   
sequence_detector_MealyFSM_Overlapping DUT(.*);   
   
endmodule :sequence_detector_MealyFSM_Overlapping_TB
