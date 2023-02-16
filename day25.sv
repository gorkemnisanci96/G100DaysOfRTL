////////////////////////////////////////////
// Find the Index of the first Set bit in sequence of bits(Index of the LSB is Zero)
// If the sequence does not have any zero, valid signal will be zero. 

module day25
  #(parameter DATAWIDTH = 16)
  (
    input  logic [(DATAWIDTH-1):0]     i_Sequence,  
    output logic [$clog2(DATAWIDTH):0] o_Index,
    output logic                       o_IndexValid
  );

  

logic flag ;  
  
assign o_IndexValid = ~flag;  
  
  
always_comb
begin
   flag = 1'b1;    
    
  for(int i =0;i<DATAWIDTH;i++)
  begin
     
    if((i_Sequence[i]==1'b1) && flag)
      begin
       o_Index = i;
       flag = 1'b0; 
      end 
    
  end 
  
  
end 
  
  
endmodule 



//////////////////////////////////////
//    TEST BENCH
//////////////////////////////////////

module day25_tb();
  
  
parameter DATAWIDTH = 16;

  logic [(DATAWIDTH-1):0]     i_Sequence; 
  logic [$clog2(DATAWIDTH):0] o_Index;  
  logic                       o_IndexValid;
  
  
initial begin
i_Sequence = 16'h0; // NO One Case   
#10   
i_Sequence = 16'h1; // Index Zero has one 
#10   
i_Sequence = 16'h01; // Index One has one    
#10   
i_Sequence = 16'h0100; // Index One has one    
#10     
i_Sequence = 16'hFFF0; // Index One has one    
#10       
i_Sequence = 16'hFFFF; // Index One has one    
#10     
i_Sequence = 16'h1234; // Index One has one    
#10           
i_Sequence = 16'h0; // Index One has one    
#10     
$finish;  
end 
  
  
  
  
day25
  #(.DATAWIDTH (DATAWIDTH))
uday25
  (.*);
  
 
initial $monitor("Num: %b  Index:%d IndexVAlid:%d ",i_Sequence,o_Index,o_IndexValid);  
  
  
  
endmodule :day25_tb 


