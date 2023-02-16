`timescale 1ns / 1ps
// FIX PRIORITY ARBITER 
// We can use the PRIORITYLSB change the Priority of the Design
// PRIORITYLSB = 1 --> LSB has the highest priority 
// PRIORITYLSB = 0 --> MSB has the highest priority 



module day18_v1
  #(parameter DEVICENUM   = 10,
    parameter PRIORITYLSB = 1)
  (
    input  logic                   clk,     
    input  logic                   rstn,     
    input  logic [(DEVICENUM-1):0] i_Req, 
    output logic [(DEVICENUM-1):0] o_Gnt  
  );
  
logic [(DEVICENUM-1):0] o_GntNext; 
  
genvar i; 
  
generate
  // THE LSB has the highest priority   
  if(PRIORITYLSB == 1'b1)
  begin
  
     assign o_GntNext[0] = i_Req[0];
     for(i=1 ;i<DEVICENUM;i++)
     begin
       assign o_GntNext[i] = i_Req[i] & (~|i_Req[(i-1):0]); 
     end
     
  end else begin
  
     assign o_GntNext[(DEVICENUM-1)] = i_Req[(DEVICENUM-1)];
     for(i=(DEVICENUM-2);i>=0;i--)
     begin
      assign o_GntNext[i] = i_Req[i] & ~|i_Req[(DEVICENUM-1):(i+1)];
     end 
     
  end 
endgenerate   
  
  
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      o_Gnt <= 0;
   end else begin
      o_Gnt <= o_GntNext;
   end 
end   
  
  
  
  
  
  
  
endmodule :day18_v1



module day18_v2
#(parameter DEVICENUM   = 10,
  parameter PRIORITYLSB = 1)
(
    input logic clk,
    input logic rstn, 
    // 
    input  logic [(DEVICENUM-1):0] i_Req, 
    output logic [(DEVICENUM-1):0] o_Gnt  
);


logic [(DEVICENUM-1):0] o_GntNext; 

integer i;
logic flag;
always_comb 
begin
   flag = 1'b1;
   
   
   
   if(PRIORITYLSB== 1'b1)
   begin
   
      for(i=0;i<DEVICENUM;i++)
      begin
         if((i_Req[i]==1'b1) && flag)
         begin
            o_GntNext[i] = 1'b1;
            flag = 0;
         end else begin
            o_GntNext[i] = 1'b0;
         end
      end
               
   end else begin
   
     for(i = (DEVICENUM-1);i>=0 ; i--)
     begin
     
        if( (i_Req[i]==1'b1) && flag)
        begin
           o_GntNext[i] = 1'b1;
           flag         = 1'b0;
        end else begin
          o_GntNext[i]  = 1'b0;
        end  
   
     end
   end 
end 


////////////////////////////////////////
//  REGISTERS 
///////////////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin

  if(!rstn)
  begin
     o_Gnt <= 0;
  end else begin
     o_Gnt <= o_GntNext;
  end 
  
end 



endmodule :day18_v2







module day18_tb();

parameter DEVICENUM   = 10;
parameter PRIORITYLSB = 0;
logic                   clk;   
logic                   rstn;  
logic [(DEVICENUM-1):0] i_Req;
logic [(DEVICENUM-1):0] o_Gnt_v1;  
logic [(DEVICENUM-1):0] o_Gnt_v2;  


initial begin
 clk = 1'b0;
 fork
  forever #10 clk = ~clk;
 join
end 

task RESET();
begin
      i_Req = 0;
    //
      rstn = 1'b1;
    @(posedge clk);
      rstn = 1'b0;
    repeat(2) @(posedge clk);
      rstn = 1'b1;
end 
endtask 





initial begin
RESET();

  for(int i=0;i<100;i++)
  begin
     @(posedge clk);
     i_Req = $random;
  end 

$finish;
end 


////////////////////////////////
// DUT 1 INSTANTIATION 
////////////////////////////////
day18_v1
  #(.DEVICENUM   (DEVICENUM ),
    .PRIORITYLSB (PRIORITYLSB))
uday18_v1
  (
  .clk      (clk),     
  .rstn     (rstn),     
  .i_Req    (i_Req), 
  .o_Gnt    (o_Gnt_v1)    
  );

////////////////////////////////
// DUT 2 INSTANTIATION 
////////////////////////////////  

day18_v2
  #(.DEVICENUM   (DEVICENUM ),
    .PRIORITYLSB (PRIORITYLSB))
uday18_v2
  (
  .clk      (clk),     
  .rstn     (rstn),     
  .i_Req    (i_Req), 
  .o_Gnt    (o_Gnt_v2)    
  );  
  
  
 ///////////////////////////
 //  ASSERTIONS 
 /////////////////////////// 
always_comb 
begin
   a1: assert (o_Gnt_v1 == o_Gnt_v2) else $error("It's gone wrong %0t",$time);

end 
  
endmodule :day18_tb 
