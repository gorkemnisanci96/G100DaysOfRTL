`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Vending Machine with Mealy FSM
//////////////////////////////////////////////////////////////////////////////////

module vending_machine_mealy(
   input  logic clk, 
   input  logic rstn, 
   input  logic D,
   input  logic N,
   output logic open
    );
    
typedef enum{
    CENT_0, 
    CENT_5,  
    CENT_10
} state_type; 

state_type cstate, nstate; 



always_comb 
begin 
    nstate = cstate; 
    open   = 1'b0;
    
   case(cstate)
      CENT_0: begin  
         if(D==1)      begin nstate = CENT_10;   open = 1'b0; end 
         else if(N==1) begin nstate = CENT_5;    open = 1'b0; end 
         else          begin nstate = CENT_0;    open = 1'b0; end 
      end 
      CENT_5: begin  
         if(D==1)      begin nstate = CENT_0;    open = 1'b1; end 
         else if(N==1) begin nstate = CENT_10;   open = 1'b0; end 
         else          begin nstate = CENT_5;    open = 1'b0; end 
      end 
      CENT_10: begin  
         if(D==1)      begin nstate = CENT_0;    open = 1'b1; end 
         else if(N==1) begin nstate = CENT_0;    open = 1'b1; end 
         else          begin nstate = CENT_10;   open = 1'b0; end 
      end 
   endcase
    
end 


//=============================
// State Register 
//=============================
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      cstate <= CENT_0; 
   end else begin
      cstate <= nstate;
   end 
end 


    
endmodule :vending_machine_mealy




module vending_machine_mealy_tb();

logic clk;
logic rstn; 
logic D;
logic N;
logic open;


initial begin 
   clk = 1'b0;
   forever #10 clk = ~clk;
end 


task RESET();
begin
   D = 1'b0;
   N = 1'b0;   
   rstn = 1'b1;
   repeat(2) @(posedge clk); 
   rstn = 1'b0;
   repeat(2) @(posedge clk);
   rstn = 1'b1;
end 
endtask 


initial begin 
   RESET(); 
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



vending_machine_mealy DUT(.*);


endmodule :vending_machine_mealy_tb 
