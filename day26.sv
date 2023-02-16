`timescale 1ns / 1ps
////////////////////////////////////////
// Receive a data and send a byte at a time. Least Significant byte First.



module day26
#(parameter DATAWIDTH =16)
(
   input logic clk,
   input logic rstn,
   //
   input logic [(DATAWIDTH-1):0] i_Data,
   input logic                   i_DataRdy,
   //
   output logic [7:0]            o_ByteOut,
   output logic                  o_ByteOutValid
    );
    
    

localparam MOD = DATAWIDTH%8;
localparam BYTENUM = DATAWIDTH/8;
localparam S_IDLE = 1'b0,
           S_SEND = 1'b1;


logic State,StateNext; 
logic [BYTENUM:0][7:0]    Data,DataNext; 
logic [7:0]               o_ByteOutNext;
logic                     o_ByteOutValidNext;
logic [$clog2(BYTENUM):0] Count,CountNext;

always_comb
begin
  StateNext = State;
  DataNext  = Data; 
  o_ByteOutValidNext = o_ByteOutValid;
  CountNext = Count; 
  o_ByteOutNext = o_ByteOut;
case(State)
   S_IDLE:
   begin
     o_ByteOutValidNext = 1'b0;
     if(i_DataRdy == 1'b1)
     begin
       DataNext = i_Data;
                                StateNext = S_SEND;
       CountNext = 1'b0;
     end 
   
   
   end 
   S_SEND:
   begin
   
      if(Count<BYTENUM)
      begin
         CountNext = Count + 1;
         o_ByteOutNext = Data[Count];
         o_ByteOutValidNext = 1'b1;
      end else if (MOD!=0) begin
         o_ByteOutNext = Data[Count];
         o_ByteOutValidNext = 1'b1; 
         CountNext = 0;
                                StateNext = S_IDLE;    
      end else begin
          CountNext = 0;
         o_ByteOutValidNext = 1'b0;
                                StateNext = S_IDLE;     
      end      
   end 
endcase


end 


/////////////////////////////////////
//     STATE REGISTER 
/////////////////////////////////////  
  always_ff @(posedge clk or negedge rstn)
    begin
      
      if(!rstn)
        begin
          State <= S_IDLE;
        end else begin
          State <= StateNext;
        end 
      
    end 
  
/////////////////////////////////////
//     REGISTERS 
/////////////////////////////////////    
  
  always_ff @(posedge clk or negedge rstn)
    begin
      
      if(!rstn)
        begin
          Data           <= 0; 
          Count          <= 0;
          o_ByteOutValid <= 1'b0;
          o_ByteOut      <= 0; 
        end else begin
          Data           <= DataNext; 
          Count          <= CountNext;
          o_ByteOutValid <= o_ByteOutValidNext;     
          o_ByteOut      <= o_ByteOutNext;
        end 
      
    end 
    
endmodule



module day26_tb();

parameter DATAWIDTH =20;

logic clk;
logic rstn; 
logic [(DATAWIDTH-1):0] i_Data;
logic                   i_DataRdy;
logic [7:0]             o_ByteOut;
logic                   o_ByteOutValid;


initial begin
clk = 1'b0;
  forever #10 clk = ~clk;
end 

task RESET();
begin
    i_DataRdy = 1'b0;
    //
    rstn = 1'b1;
    @(posedge clk)
    rstn = 1'b0;
    repeat(2)@(posedge clk);
    rstn = 1'b1;
end 
endtask

    
initial begin
RESET();
@(posedge clk)
i_DataRdy = 1'b1;
i_Data    = 20'h81234;
@(posedge clk)
i_DataRdy = 1'b0;
@(posedge clk)
i_DataRdy = 1'b1;
i_Data    = 20'h12345;
@(posedge clk)
i_DataRdy = 1'b0;
$finish;
end  
 
    
    
day26
#(.DATAWIDTH (DATAWIDTH))
uday26
(.*);




endmodule :day26_tb 
