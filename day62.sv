// ARBITRATION --> Least Recently Granted has the highest priority
// 1 CC of access to each requester 




module day62
  (
    input  logic         clk, 
    input  logic         rstn, 
    input  logic [3:0]   req,
    output logic [3:0]   grant
);
  


  logic [2:0] LRG       [3:0];
  logic [2:0] LRG_next  [3:0];  
  logic [2:0] granted; 
  logic [3:0] grant_next;
  
  
  
//============================  
// ASSIGN grant
//============================  
logic break_flag;   

always_comb
  begin
    break_flag = '0;
    grant_next = '0;
    for(int k =0;k<4;k++)
      begin
        for(int m =0;m<4;m++)
       begin
         if((LRG[m]==k) && (req[m]==1'b1) && ~break_flag)
           begin
             grant_next[m] = 1'b1; 
             granted       = m;
             break_flag    = 1'b1;
             $display("-------------------");
             $display("[INFO] THE REQs %b ",req);
             $display("[INFO] THE REQ %d get the access",granted);
           end 
       end                  
      end 
  end 
  
  
  
always_ff @(posedge clk or negedge rstn)
   begin
      if(!rstn)
        begin
          grant   <= '0;
        end else begin
          grant   <= grant_next;          
        end 
    end 
  
  
  
  
  
  
  
  
  
//============================  
// UPDATE least Recently Granted Array   
//============================   

 always_comb
   begin
     LRG_next = LRG;
    for(int j=0;j<4;j++)
     begin
      if(LRG[j]> LRG[granted])
       begin
         LRG_next[j] = LRG_next[j] - 1; 
       end          
     end
     LRG_next[granted] = 3;
            for(int cnt =0; cnt<4; cnt++)
            begin
              $display("[INFO] LRG[%d] = %d ",cnt,LRG_next[cnt]);
            end 
   end 
  
  
  
  
  
  always_ff @(posedge clk or negedge rstn)
    begin
      if(!rstn)
        begin
         
           for(int i=0;i<4;i++)
            begin
              LRG[i]=i;
            end 
        end else begin
            LRG  <= LRG_next; 
        end 
    end 
  
  
  
  
  
  
endmodule 




//====================
// TEST BENCH
//====================
module day62_tb();
  
  
  
logic         clk;
logic         rstn; 
logic [3:0]   req;
logic [3:0]   grant;  
  

  
///////////  
// Clock Generation   
///////////   
initial begin
  clk = 1'b0;
  forever #10 clk = ~clk; 
end 
  
  
///////////  
// RESET TASK   
///////////   
task RESET();
 begin
  req = '0;
  // 
  rstn = 1'b1;
  repeat(2) @(posedge clk);
  rstn = 1'b0;
  repeat(2) @(posedge clk);    
  rstn = 1'b1;      
 end 
endtask 
  
  
//====================
// MAIN STIMULUS
//====================
initial begin
  RESET(); 
  // 
  req = 'b10;
  @(posedge clk);
  req = 'b01;
  @(posedge clk);
  req = 'b100;
  @(posedge clk);
  req = 'b1111;
  repeat(5) @(posedge clk);
  req = 'b0;  
  repeat(10) @(posedge clk);
  $finish;
end 
  
  
  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, day61);
  end
  
  
  
day62 uday62(.*);
    
  
  
endmodule 
