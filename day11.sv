`timescale 1ns / 1ps
/////////////////////////////////
// LFSR with parameterized DEPTH and feedback XOR Function
// The LFSRFUNC chooses which bits of the LFSR will be XORed and feed back 


module day11
#(parameter LFSRDEPTH = 10,
  parameter [(LFSRDEPTH-1):0] LFSRFUNC  = 25  )
(
 input logic clk,
 input logic rstn, 
 input logic [(LFSRDEPTH-1):0] i_Seed,
 output logic o_LFSR_Out
    );
    
    
logic feedback;

logic [(LFSRDEPTH-1):0] LFSR;

always_comb
begin
  feedback = 1'b0;
  for(int i=0;i<LFSRDEPTH;i++)
  begin
     if(LFSRFUNC[i] == 1'b1)
     begin
       feedback = feedback ^ LFSR[i];   
     end 
  end 
end 




/////////////////////////////
//   SHIFT REGISTER 
/////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
     LFSR <= i_Seed;
  end else begin
     LFSR <= {LFSR[(LFSRDEPTH-2):0],feedback};
  end 
end     
    
assign o_LFSR_Out=LFSR[(LFSRDEPTH-1)];    
    


    
    
    
endmodule :day11


///////////////////////////////////
//         TEST BENCH 
//////////////////////////////////

module day11_tb();

parameter LFSRDEPTH = 10;
parameter [(LFSRDEPTH-1):0] LFSRFUNC  = 25;


initial $display("THE LFSR FUNC: %b ",LFSRFUNC);


logic clk;
logic rstn; 
logic [(LFSRDEPTH-1):0] i_Seed;
logic o_LFSR_Out;

/////////////////////////
// Clock Generation 
/////////////////////////

initial begin
clk = 1'b0;
fork
 forever #10 clk = ~clk;
join
end 

/////////////////////////
// RESET TASK
/////////////////////////
task RESET();
begin
  rstn = 1'b1;
  @(posedge clk);
  rstn = 1'b0;
  repeat(2) @(posedge clk); 
  rstn = 1'b1; 
end 
endtask 


initial begin
i_Seed = $random;
RESET();


repeat(10) @(posedge clk);
$finish;
end 


////////////////////////
//   MODULE INSTANTIATION 
///////////////////////
day11
#(.LFSRDEPTH (LFSRDEPTH),
  .LFSRFUNC  (LFSRFUNC)  )
uday11
(
 .clk         (clk),
 .rstn        (rstn), 
 .i_Seed      (i_Seed),
 .o_LFSR_Out  (o_LFSR_Out)
    );




endmodule :day11_tb 
