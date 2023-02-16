// Clock Gating with Latch 



module day58();
  
logic clk;
logic gclk;
logic lout;
logic enable;
  
  
initial begin
  clk = 1'b0;
  forever #10 clk = ~clk;
end 
  
  initial begin
    enable = '0;
    repeat(10) @(posedge clk);
    enable = 1'b1;
    repeat(10) @(posedge clk);
    enable = '0;
    repeat(10) @(posedge clk);
    $finish;
  end 
  
  
  
  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, day58);
  end
  
  
always_latch
  begin
    if(!clk) begin  lout <= enable; end 
  end 
  
  
assign gclk = clk & lout;   
  
  
  
  
  
endmodule 
