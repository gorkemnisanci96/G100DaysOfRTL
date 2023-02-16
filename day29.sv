`timescale 1ns / 1ps

// UART TX MODULE INTERFACE 


module day29
#(parameter WIDTH = 5 )
(
    input logic       i_Send,
    input logic [7:0] i_Data, 
    //
    input logic clk,
    input logic rstn,
    output logic o_TX,
    output logic o_TXValid
    );
    
    
localparam [3:0] S_IDLE   = 4'd0,
                 S_START  = 4'd1,
                 S_BIT0   = 4'd2,
                 S_BIT1   = 4'd3,
                 S_BIT2   = 4'd4,
                 S_BIT3   = 4'd5,    
                 S_BIT4   = 4'd6,
                 S_BIT5   = 4'd7,
                 S_BIT6   = 4'd8,
                 S_BIT7   = 4'd9, 
                 S_STOP   = 4'd10;                  
                                    
                                    
logic [3:0] State,   StateNext; 
logic [7:0]             Data,    DataNext; 
logic [$clog2(WIDTH):0] Count,   CountNext;      
logic o_TXValidNext;
logic o_TXNext;




always_comb 
begin
   DataNext  = Data;
   CountNext = Count;
   StateNext = State;
   o_TXValidNext = o_TXValid;
   o_TXNext  = o_TX; 
   
   case(State)
     S_IDLE:
     begin
        if(i_Send == 1'b1)
        begin
                                            StateNext = S_START;
        DataNext = i_Data;                                    
        CountNext = 0;
        o_TXNext = 1'b0;
        o_TXValidNext = 1'b1;
        end
     end 
     S_START:
     begin
     
        if(Count<WIDTH)
        begin
           CountNext = Count + 1;
        end else begin
           CountNext = 0;
           o_TXNext = Data[0];
                                            StateNext = S_BIT0;           
        end  
     
     end 
     S_BIT0:
     begin
     
        if(Count<WIDTH)
        begin
           CountNext = Count + 1;
        end else begin
           CountNext = 0;
           o_TXNext = Data[1];           
                                            StateNext = S_BIT1;           
        end 
              
     end 
     S_BIT1:
     begin
     
        if(Count<WIDTH)
        begin
           CountNext = Count + 1;
        end else begin
           CountNext = 0;
           o_TXNext = Data[2];            
                                            StateNext = S_BIT2;           
        end 
                 
     end      
     S_BIT2:
     begin
     
        if(Count<WIDTH)
        begin
           CountNext = Count + 1;
        end else begin
           CountNext = 0;
           o_TXNext = Data[3];            
                                            StateNext = S_BIT3;           
        end    
          
     end      
     S_BIT3:
     begin
     
        if(Count<WIDTH)
        begin
           CountNext = Count + 1;
        end else begin
           CountNext = 0;
           o_TXNext = Data[4];            
                                            StateNext = S_BIT4;           
        end       
        
     end 
     S_BIT4:
     begin
     
        if(Count<WIDTH)
        begin
           CountNext = Count + 1;
        end else begin
           CountNext = 0;
           o_TXNext = Data[5];            
                                            StateNext = S_BIT5;           
        end     
               
     end 
     S_BIT5:
     begin
     
        if(Count<WIDTH)
        begin
           CountNext = Count + 1;
        end else begin
           CountNext = 0;
           o_TXNext = Data[6];            
                                            StateNext = S_BIT6;           
        end     
            
     end      
     S_BIT6:
     begin
     
        if(Count<WIDTH)
        begin
           CountNext = Count + 1;
        end else begin
           CountNext = 0;
           o_TXNext = Data[7];            
                                            StateNext = S_BIT7;           
        end    
              
     end        
     S_BIT7:
     begin
     
        if(Count<WIDTH)
        begin
           CountNext = Count + 1;
        end else begin
           CountNext = 0;
           o_TXNext = 1'b1;            
                                            StateNext = S_STOP;           
        end
                 
     end  
     S_STOP:
     begin
     
        if(Count<WIDTH)
        begin
           CountNext = Count + 1;
        end else begin
           CountNext = 0;
           o_TXNext = 1'b1;   
           o_TXValidNext = 1'b0;         
                                            StateNext = S_IDLE;           
        end   
          
     end                 


   endcase 

end



always_ff @(posedge clk or negedge rstn)
begin
   
   if(!rstn)
   begin
      Data      <= 0;
      Count     <= 0;
      State     <= S_IDLE;
      o_TXValid <= 0;
      o_TX      <= 0; 
   end else begin
      Data      <= DataNext;
      Count     <= CountNext;
      State     <= StateNext;
      o_TXValid <= o_TXValidNext;
      o_TX      <= o_TXNext;    
   end 

end 


endmodule



module day29_tb();

parameter WIDTH =5;
logic       i_Send;
logic [7:0] i_Data; 
logic       clk;
logic       rstn;
logic       o_TX;
logic       o_TXValid;

initial begin
 clk = 1'b0;
 forever #10 clk = ~clk;
end 

task RESET();
begin
   // 
   i_Send = 1'b0;
   i_Data = 0;
   //
   rstn = 1'b1;
   @(posedge clk);
   rstn = 1'b0;
   repeat(2) @(posedge clk);
   rstn = 1'b1;
end 
endtask 

task SEND(input logic [7:0] Data);
begin
   i_Send = 1'b0;
   @(posedge clk);
   i_Send = 1'b1;
   i_Data = Data;
   @(posedge clk);
   i_Send = 1'b0;
   @(posedge clk);
   @(posedge clk iff(!o_TXValid));
end 
endtask



initial begin
RESET();
SEND(8'h12);
SEND(8'hFF);
SEND(8'h01);
SEND(8'h02);
$finish;
end 






day29
#( .WIDTH (WIDTH) )
uday29
(.*);

endmodule :day29_tb
