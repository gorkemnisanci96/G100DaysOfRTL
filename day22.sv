// Least Recently Used Algorithm for N-Way Set Associative Cache 
// Clk: Clock
// rstn: Active low, Asyncronous Reset. 
// i_Access : It is high when there is an access
// i_AccessNum: It indicates the Block Number that is accessed when there is an access. 
// o_LRUNum : Least Recently Accessed Block Number 


module day22
  #(parameter N = 4)
  (
  input logic clk,
  input logic rstn, 
  //
  input  logic [$clog2(N):0]  i_AccessNum,
  input  logic                 i_Access,   
   output logic [$clog2(N):0]  o_LRUNum
  );
  
  
  logic [$clog2(N):0]  Count     [(N-1):0] ; 
  logic [$clog2(N):0] CountNext [(N-1):0];    
  logic [$clog2(N):0] o_LRUNumNext;
  
always_comb
begin
  CountNext = Count;

  if(i_Access == 1'b1)
  begin
    
     for(int i=0;i<N;i++)
     begin
       
       if(Count[i]>Count[i_AccessNum])
       begin
         CountNext[i] = Count[i] - 1; 
       end
    
     end 
    CountNext[i_AccessNum] = (N-1);
  end          
      
end 
  

always_comb
begin
  o_LRUNumNext = o_LRUNum;
  for(int i=0;i<N;i++)
  begin
    if(Count[i] == 0)
     begin
        o_LRUNumNext = i;
     end 
  end 
end   
  
  
  
  
  
  
/////////////////////////////////////////
//     COUNTER REGISTERS 
/////////////////////////////////////////  
  always_ff @(posedge clk or negedge rstn)
  begin
    
    if(!rstn)
    begin
      for(int i = 0;i<N;i++)
      begin
        Count[i] <= i;
      end 
      
    end else begin
      Count <= CountNext;
    end 
    
  end 
  
  
/////////////////////////////////////////
//     LRU OUTPUT REGISTER 
/////////////////////////////////////////  
  always_ff @(posedge clk or negedge rstn)
  begin
    
    if(!rstn)
    begin
       o_LRUNum <=0;
      
    end else begin
      o_LRUNum <= o_LRUNumNext;
    end 
    
  end 
    
endmodule :day22 


////////////////////////////////////
//         TEST BENCH 
////////////////////////////////////

module day22_tb();
  
parameter N = 8;

logic clk;
logic rstn;
  //
  logic [$clog2(N):0] i_AccessNum;
  logic                      i_Access;   
  logic [$clog2(N):0]  o_LRUNum;
 
// Clock Generation 
initial begin
clk = 1'b0;
fork
   forever #10 clk = ~clk;
join
  
end 
  
// RESET GENERATION 
  task RESET();
  begin
     i_AccessNum = 0;
     i_Access = 1'b0;
     rstn = 1'b1;
    @(posedge clk);
    rstn = 1'b0;
    repeat(2) @(posedge clk);
    rstn = 1'b1;
  end 
  endtask
 
  
  task ACCESS(input logic [$clog2(N):0] AccessNum);
  begin
    @(posedge clk);
    i_Access = 1'b1;
    i_AccessNum = AccessNum;
    @(posedge clk);
    i_Access = 1'b0;
    i_AccessNum = 0;
    repeat(2)@(posedge clk);
  end 
  endtask 
  
initial begin
  RESET();  
  ACCESS(6);
  ACCESS(1);
  ACCESS(2);
  ACCESS(0);
  ACCESS(3);
  ACCESS(2);
  ACCESS(1);
  ACCESS(1);
  ACCESS(0);
  ACCESS(2);
  ACCESS(0);
  ACCESS(4);
  ACCESS(7);
  
  
  repeat(30) @(posedge clk);
  $finish;
end 
  

  
//////////////////////////////  
// DUT INSTANTIATION   
////////////////////////////// 
  
day22
  #(.N (N))
uday22
  (.*);  
  
  
  initial begin
    $dumpfile("day22.vcd");
    $dumpvars(0, day22_tb);
  end  
  
endmodule :day22_tb 
