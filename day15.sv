`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////
// Greater Common Divisor 


module day15(
    input logic clk,
    input logic rstn, 
    // 
    input logic [7:0] i_num1,
    input logic [7:0] i_num2,
    input logic       i_InReady, 
    //
    output logic       o_DeviceReady, 
    //
    output logic [7:0] o_Gcd,
    output logic       o_OutReady    
    );
    
    
localparam S_IDLE   = 1'b0, 
           S_GCDCAL = 1'b1;    
    
logic State,StateNext; 
logic [7:0] Num1Reg,Num2Reg,Num1RegNext,Num2RegNext; 
logic       o_OutReadyNext;
logic [7:0] o_GcdNext; 

always_comb
begin
   Num1RegNext    = Num1Reg;
   Num2RegNext    = Num2Reg;
   StateNext      = State;
   o_OutReadyNext = 1'b0; 
   o_GcdNext      = o_Gcd;
   case(State)
     S_IDLE:
     begin
       if(i_InReady == 1'b1)
       begin
         Num1RegNext = i_num1;
         Num2RegNext = i_num2;
                                     StateNext = S_GCDCAL;
       end 
     end 
     S_GCDCAL:
     begin
      if(Num1Reg>Num2Reg)
      begin
         Num1RegNext = Num1Reg - Num2Reg;
      end else if (Num1Reg<Num2Reg)
      begin
         Num2RegNext = Num2Reg - Num1Reg;
      end else begin
        o_OutReadyNext = 1'b1; 
        o_GcdNext      = Num1Reg;
                                     StateNext = S_IDLE;
      end  
     end 
   endcase
end 

//////////////////////////////////////
// OUTPUT ASSIGNMENT 
//////////////////////////////////////
assign o_DeviceReady = (State == S_IDLE);





//////////////////////////////////////
//   STATE REGISTER 
//////////////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
     State <= S_IDLE;
   end else begin
     State <= StateNext; 
   end 
end 
 
 
 //////////////////////////////////////
//   REGISTERS 
//////////////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
       Num1Reg    <= 0;
       Num2Reg    <= 0;
       o_OutReady <= 1'b0; 
       o_Gcd      <= 0;
   end else begin
       Num1Reg    <= Num1RegNext;
       Num2Reg    <= Num2RegNext;
       o_OutReady <= o_OutReadyNext; 
       o_Gcd      <= o_GcdNext;
   end 
end    



    
endmodule :day15


///////////////////////////////////
//     TEST BENCH 
///////////////////////////////////


module day15_tb();



logic clk;
logic rstn; 
    // 
logic [7:0] i_num1;
logic [7:0] i_num2;
logic       i_InReady; 
    //
logic       o_DeviceReady;
    //
logic [7:0] o_Gcd;
logic       o_OutReady;    

// CLOCK GENERATION 
initial begin
clk = 1'b0;
fork
  forever #10 clk = ~clk;
join 
end 


// RESET TASK 
task RESET();
begin
    i_InReady = 1'b0;
    i_num1 = 0;
    i_num2 = 0;
    //
    rstn = 1'b1;
    @(posedge clk);
    rstn = 1'b0;
    repeat(2) @(posedge clk);
    rstn = 1'b1; 
end 
endtask 

// SEND NUMBER FOR GCD CALCULATIONS 
task GCD(input logic [7:0] num1,
         input logic [7:0] num2);
begin
     @(posedge clk iff(o_DeviceReady == 1'b1));
     i_num1 = num1;
     i_num2 = num2;
     i_InReady = 1'b1;
     @(posedge clk);
     i_InReady = 1'b0;
     @(posedge clk iff(o_OutReady == 1'b1));
     $display("THE GCD(%d,%d)=%d",num1,num2,o_Gcd);
end 
endtask




initial begin
  RESET();
  GCD(39,29); // NO COMMON DIVISOR 
  GCD(39,26); // GCD is 13 
  GCD(35,49); // GCD is 7
  repeat(30) @(posedge clk);
  $finish;
end 

//////////////////////////////
// DUT INSTANTIATION 
//////////////////////////////
day15 uday15(.*);


endmodule :day15_tb 
