// Code your design here
// Count the number of ones in the Input Data and output the Total 


module day24 
  #(parameter DATAWIDTH = 16)
  (
    
    input logic [(DATAWIDTH-1):0]      i_DataIn,
    output logic [$clog2(DATAWIDTH):0] o_TotalOnes
  );
  
  

always_comb
  begin
    o_TotalOnes = 0;
    
    for(int i =0;i<DATAWIDTH;i++)
    begin
      o_TotalOnes = o_TotalOnes + i_DataIn[i];        
    end 
    
  end 
  
  
  
  
  
endmodule 



///////////////////////////////////
//    TEST BENCH 
//////////////////////////////////

module day24_tb();
  
parameter DATAWIDTH = 16;  
  
logic [(DATAWIDTH-1):0]      i_DataIn;
logic [$clog2(DATAWIDTH):0]  o_TotalOnes;  
  
  
  
initial begin
i_DataIn = 0;
#10
i_DataIn = 16'b1011111100011111;  
#10
i_DataIn = 16'b1;   
#10
i_DataIn = 16'b1111000010101111; 
#10
i_DataIn = 16'hFFFF;  
#10
i_DataIn = 16'hFFFE;       
#10
  
$finish;  
end 
  
  
////////////////////////  
// DUT INSTANTIATION   
////////////////////////    
day24 
  #(.DATAWIDTH (DATAWIDTH))
uday24
  (
    .i_DataIn     (i_DataIn),
    .o_TotalOnes  (o_TotalOnes)
  ); 

  
 initial $monitor("Num: %b TotalOnes:%d",i_DataIn,o_TotalOnes);  
  
  
endmodule 

