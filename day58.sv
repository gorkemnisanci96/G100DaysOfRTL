// RESET SYNCRONIZER.

module day58
  (
    input  logic       clk, 
    input  logic       rstn,
    output logic [7:0] counter  
  );
  
  
  logic sync_rstn0;
  logic sync_rstn1;  
  
  /////////////////////////////////
  // RESET SYNCRONIZER. To solve the reset deassertion. 
  /////////////////////////////////
  always_ff @(posedge clk or negedge rstn)
    begin
      if(!rstn)
        begin
          sync_rstn0 <= 1'b0;  
          sync_rstn1 <= 1'b0;            
        end else begin
          sync_rstn0 <= 1'b1;
          sync_rstn1 <= sync_rstn0;
        end 
    end 
  
  
  /////////////////////////////////
  // Counter 
  /////////////////////////////////  
  always_ff @(posedge clk or negedge rstn)
    begin
      if(!sync_rstn1)
        begin
         counter <= 0;
        end else begin
         counter <= counter + 1;
        end 
    end 
  
  
  
  
  
endmodule 



module day58_tb();
  
logic       clk; 
logic       rstn;
logic [7:0] counter;    


initial begin
  clk = 1'b0;
  forever #10 clk = ~clk;
end 
  
  
  
  task RESET();
    begin
       rstn = 1'b1;
       repeat(2) @(posedge clk);
       rstn = 1'b0;
      repeat(2) @(posedge clk); #2
       rstn = 1'b1;      
    end 
  endtask
  

  
initial begin
  RESET();
  repeat(5) @(posedge clk);
  RESET();
  repeat(5) @(posedge clk);
  $finish;
end 
  
  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, day55);
  end  
  
  
day55 uday55
  (
    .clk     (clk),
    .rstn    (rstn),
    .counter (counter) 
  ); 
  
  
endmodule 
