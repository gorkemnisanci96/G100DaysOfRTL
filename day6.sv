`timescale 1ns / 1ps
// Find the Second highest value in the given N values.Fully Combinational  
// Version 1 
// If there are two Max Values, Max and SecondMax Will be same. 
// Version 2 
// Second Max Value can not be same as the max value. This versin has a valid signal which is low when all the numbers are same.  



module day6_v1
#(parameter DataWidth = 8,
  parameter ArraySize = 10)
(
input  logic [(DataWidth-1):0] i_array [(ArraySize-1):0], 
output logic [(DataWidth-1):0] o_second_max
);


logic [(DataWidth-1):0] max;


always_comb
begin
   if(i_array[0]>i_array[1])
   begin
     max          = i_array[0];
     o_second_max = i_array[1];
   end else begin
     max          = i_array[1];
     o_second_max = i_array[0];
   end 
   //
   for(int i = 2; i<ArraySize;i++)
   begin
      if(i_array[i]>max)
      begin
        o_second_max = max;
        max          = i_array[i];
      end else if(i_array[i]>o_second_max)
      begin
        o_second_max = i_array[i];      
      end 
   end   
end 
endmodule :day6_v1




// Code your design here


module day6_v2
  #(parameter DATAWIDTH = 8,
    parameter NUM = 10)
  (
    input  logic [(NUM-1):0][(DATAWIDTH-1):0] i_array , // PACKED ARRAY 
    output logic [(DATAWIDTH-1):0] o_SecondMax_v2,
    output logic o_SecondMax_v2_Valid 
  
  );
  
logic flag;
assign o_SecondMax_v2_Valid = flag;  
 
logic  [(DATAWIDTH-1):0] Max; 
 
  
always_comb 
begin
  o_SecondMax_v2 = {NUM{1'bx}};
  flag = 1'b0;
  Max = i_array[0];
  for(int i=1;i<NUM;i++)
  begin
    if(i_array[i]>Max)
     begin
       Max = i_array[i];
     end 
  end
  
  for(int i=0; i<NUM;i++)
  begin
    
    if((i_array[i]!=Max) && ~flag)
    begin
      o_SecondMax_v2 = i_array[i]; 
      flag = 1'b1;
    end 
   
  end 

  for(int i=0; i<NUM;i++)
  begin
    if(flag && (i_array[i]>o_SecondMax_v2) && (i_array[i]!=Max) )
    begin
      o_SecondMax_v2 = i_array[i];
    end   
  end   
      
  
end 
  
  
  
  
  
  
  
  
  
endmodule :day6_v2










module day6_tb();

parameter DataWidth = 8;
parameter ArraySize = 10;

logic [(DataWidth-1):0] i_array_v1 [(ArraySize-1):0];
logic  [(ArraySize-1):0][(DataWidth-1):0] i_array_v2;
logic [(DataWidth-1):0] o_second_max;
logic [(DataWidth-1):0] o_SecondMax_v2;
logic o_SecondMax_v2_Valid;

initial begin
   i_array_v1 = {8,8,1,2,3,4,5,6,7,7};
   #100;
   i_array_v1 = {1,8,2,2,3,4,4,6,5,7};
   #100;
   i_array_v1 = {5,5,5,5,5,5,5,5,5,5};
   #100;
   i_array_v1 = {55,5,23,62,5,5,4,55,5,111};
   #100;  
   
   $finish;
end 


always_comb
begin
  for(int i =0;i<ArraySize;i++)
  begin
     i_array_v2[i] = i_array_v1[i]; 
  end 
end 




///////////////////////////////
//  DUT INSTANTIATION 
///////////////////////////////
day6_v1
#(.DataWidth (DataWidth),
  .ArraySize (ArraySize))
uday6_v1
(
  .i_array         (i_array_v1), 
  .o_second_max    (o_second_max)
);


day6_v2
  #(.DATAWIDTH (DataWidth),
    .NUM (ArraySize))
uday6_v2
  (
    .i_array              (i_array_v2), // PACKED ARRAY 
    .o_SecondMax_v2       (o_SecondMax_v2),
    .o_SecondMax_v2_Valid (o_SecondMax_v2_Valid)
  
  );



endmodule :day6_tb 
