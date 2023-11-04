`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Vending Machine with One-Hot Encoding and Moore State Machine 
//////////////////////////////////////////////////////////////////////////////////


module vending_machine_moore_fsm(
   input  logic clk, 
   input  logic rstn, 
   input  logic D, 
   input  logic N, 
   output logic open
    );
    
    

enum{
   CENT_0  = 0,
   CENT_5  = 1,
   CENT_10 = 2,
   CENT_15 = 3
} state_index;

logic [3:0] cstate, nstate;    
    
 
always_comb 
begin
   nstate = '0; 
   open = 1'b0;
   case(1'b1)
      cstate[CENT_0]:  begin   
         if(N==1)        begin nstate[CENT_5]  = 1'b1; end 
         else if(D==1)   begin nstate[CENT_10] = 1'b1; end 
         else            begin nstate[CENT_0]  = 1'b1; end 
      end 
      cstate[CENT_5]:  begin   
         if(N==1)        begin nstate[CENT_10] = 1'b1; end 
         else if(D==1)   begin nstate[CENT_15] = 1'b1; end 
         else            begin nstate[CENT_5]  = 1'b1; end 
      end 
      cstate[CENT_10]: begin   
         if(N==1)        begin nstate[CENT_15] = 1'b1; end 
         else if(D==1)   begin nstate[CENT_15] = 1'b1; end 
         else            begin nstate[CENT_10] = 1'b1; end 
      end 
      cstate[CENT_15]: begin   
         open = 1'b1;
         if(N==1)        begin nstate[CENT_5]  = 1'b1; end 
         else if(D==1)   begin nstate[CENT_10] = 1'b1; end 
         else            begin nstate[CENT_0]  = 1'b1; end 
      end 
   endcase 

end  
 
 
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      cstate <= 4'b1;
   end else begin
      cstate <= nstate;   
   end 
end     
    
    
endmodule





module vending_machine_moore_fsm_tb();

logic clk; 
logic rstn; 
logic D; 
logic N; 
logic open;

initial begin 
   clk = 1'b0;
   forever #10 clk = ~clk; 
end 


//=============================
// RESET 
//=============================
task RESET();
begin
   D = 1'b0;
   N = 1'b0;
   rstn= 1'b1;
   repeat(2) @(posedge clk);   
   rstn= 1'b0;
   repeat(2) @(posedge clk);   
   rstn= 1'b1;
end 
endtask 



initial begin 
   RESET(); 
   repeat(2) @(posedge clk); 
   @(posedge clk); 
   D = 1'b0;
   N = 1'b1;
   @(posedge clk); 
   D = 1'b0;
   N = 1'b1;
   @(posedge clk); 
   D = 1'b1;
   N = 1'b0;
   @(posedge clk); 
   D = 1'b0;
   N = 1'b0;  
   @(posedge clk); 
   D = 1'b0;
   N = 1'b1;       
   @(posedge clk); 
   D = 1'b0;
   N = 1'b1;       
   @(posedge clk); 
   D = 1'b0;
   N = 1'b1;   
   @(posedge clk); 
   D = 1'b1;
   N = 1'b0;      
   @(posedge clk); 
   D = 1'b1;
   N = 1'b0;      
   @(posedge clk); 
   D = 1'b0;
   N = 1'b0;   
   $finish; 
end 




//============================
// DUT Instantiation 
//============================
vending_machine_moore_fsm DUT(.*);

endmodule :vending_machine_moore_fsm_tb
