/////////////////////////////////////////////
// Gray Code Counter


module day23
  #( parameter MOD = 10 )
  (
  input logic clk,
  input logic rstn, 
  //
    output logic [$clog2(MOD):0] o_GrayCount   
  );
  
 
  logic [$clog2(MOD):0] BinCount;   
  
  always_ff @(posedge clk or negedge rstn)
  begin
    
    if(!rstn)
    begin
      BinCount <= 0;
    end else begin
      if(BinCount == (MOD-1))
      begin
        
    
      end else begin
        BinCount <= BinCount + 1;
      end 
      
      
    end 
    
  end 
  
  
  
assign o_GrayCount = (BinCount >> 1) ^ BinCount;    
  
  
  
endmodule 




module GraytoBin 
  #(parameter DATAWIDTH = 10)
  (
    input logic [(DATAWIDTH-1):0] i_GrayIn,
    output logic  [(DATAWIDTH-1):0] o_BinOut 
  );
  
  
always_comb 
begin
 
 for (int i=0; i<DATAWIDTH; i++)
 begin
   o_BinOut[i] = ^(i_GrayIn >> i);   
 end 
  
end 

  
  
  
  
  
endmodule 


/////////////////////////////
//   TEST BENCH 
////////////////////////////


// Code your testbench here
// or browse Examples

module day23_tb();

 
parameter MOD = 10;
  logic clk;
  logic rstn;
  logic [$clog2(MOD):0] o_GrayCount; 
  logic [$clog2(MOD):0] o_BinOut;
 
initial begin
  clk = 1'b0;
  fork
    forever #10 clk = ~clk;
  join
end 
  

  task RESET();
  begin
    
    rstn = 1'b0;
    @(posedge clk);
    rstn = 1'b1;
    repeat(2) @(posedge clk);
    rstn = 1'b1;
    
  end 
  endtask
  
  
initial begin
  RESET();  
  
  
  repeat(30) @(posedge clk);
  $finish;
end 
  
  initial $monitor("%b -- > Binary %b ",o_GrayCount,o_BinOut); 
  
  
  
  
day23
  #( .MOD (MOD))
uday23
  (
    .clk         (clk),
    .rstn        (rstn), 
  //
    .o_GrayCount (o_GrayCount)   
  );
   
 
  
  
GraytoBin 
  #(.DATAWIDTH ($clog2(MOD)+1))
uGraytoBin
  (
   .i_GrayIn    (o_GrayCount),
   .o_BinOut    (o_BinOut)
  );  
  
  
  
endmodule 

