`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Traffic Lights 
//////////////////////////////////////////////////////////////////////////////////

module traffic_lights_moore(
   input  logic        clk, 
   input  logic        rstn,
   input  logic        carew, 
   output logic [5:0]  lights
    );
    
    
typedef enum{
   GNS_REW = 6'b001_100, 
   YNS_REW = 6'b010_100,
   RNS_GEW = 6'b100_001,
   RNS_YEW = 6'b100_010
} state_type; 

state_type cstate,nstate; 

always_comb 
begin 
   nstate = cstate;
   case(cstate)
      GNS_REW:begin if(carew==1'b1) begin nstate = YNS_REW;  end end 
      YNS_REW:begin                       nstate = RNS_GEW;      end 
      RNS_GEW:begin                       nstate = RNS_YEW;      end 
      RNS_YEW:begin                       nstate = GNS_REW;      end 
   endcase 
end     
    
    
always_ff @(posedge clk or negedge rstn)
begin 
   if(!rstn)
   begin
      cstate <= GNS_REW;
   end else begin
      cstate <= nstate;
   end 
end     
  
  
assign lights[5] = cstate[5];  
assign lights[4] = cstate[4];  
assign lights[3] = cstate[3];  
assign lights[2] = cstate[2];  
assign lights[1] = cstate[1];  
assign lights[0] = cstate[0];  
  
  
    

endmodule :traffic_lights_moore


//=================================
// TEST BENCH 
//=================================
module traffic_lights_moore_tb();

logic        clk;
logic        rstn;
logic        carew; 
logic [5:0]  lights;

initial begin 
   clk = 1'b0; 
   forever #10 clk = ~clk; 
end 



task RESET();
begin 
   carew <= 1'b0; 
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
   repeat(2) @(posedge clk); 
   carew <= 1'b1; 
   @(posedge clk);
   carew <= 1'b0;  
     
   $finish;  
end 


//==================================
// DUT Instantiation 
//==================================
traffic_lights_moore DUT(.*);
    

endmodule :traffic_lights_moore_tb
