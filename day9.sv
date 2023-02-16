`timescale 1ns / 1ps

module day9
#( parameter LFSRFUNCSEL = 0 )
(
   input logic       clk, 
   input logic       rstn,
   input logic [7:0] LFSR_Seed,
   output logic      LFSR_Out
    );
 
 
logic feedback; 
logic [7:0] LFSR;
 
    
genvar i;
generate
    case(LFSRFUNCSEL)
      0: begin assign feedback = LFSR[0] ^ LFSR[3] ^ LFSR[5];                   end 
      1: begin assign feedback = LFSR[1] ^ ~LFSR[2] ^ LFSR[5]^ LFSR[7];         end 
      2: begin assign feedback = LFSR[4] ^ LFSR[5] ^ LFSR[6];                   end 
      3: begin assign feedback = LFSR[1] ^ LFSR[2] ^ LFSR[3]^ ~LFSR[7];         end 
      default: begin  assign feedback = ~LFSR[0] ^ LFSR[2] ^ ~LFSR[4]^ LFSR[6]; end 
    endcase 
endgenerate     
  

always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
     LFSR <= LFSR_Seed;
   end else begin
     LFSR <= {LFSR[6:0],feedback};
   end 
end 

assign LFSR_Out = LFSR[7]; 
  
    
endmodule :day9


module day9_tb();

parameter LFSRFUNCSEL = 2;

logic clk; 
logic rstn;
logic [7:0] LFSR_Seed;
logic       LFSR_Out;


initial begin
clk = 1'b0;
fork
 forever #10 clk = ~clk; 
join

end 

task RESET();
begin
  rstn = 1'b1;
  repeat(2)@(posedge clk);
  rstn = 1'b0;
  repeat(2)@(posedge clk);
  rstn = 1'b1;
end 
endtask


initial begin
LFSR_Seed = 238;
RESET();

repeat(10) @(posedge clk);
$finish;
end 


day9
#( .LFSRFUNCSEL (LFSRFUNCSEL) )
uday9
(.*);



endmodule :day9_tb 
