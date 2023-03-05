`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module unsigned_mul_method1
#(parameter SIZE = 4)
(
   input  logic                clk,
   input  logic                rstn,
   input  logic                start,  
   input  logic [(SIZE-1):0]   num1,
   input  logic [(SIZE-1):0]   num2,
   output logic [(2*SIZE-1):0] result,
   output logic                ready
    );
    
    
enum logic {IDLE,EXECUTION} cstate,nstate;    
    
    

logic [(2*SIZE-1):0]    num1_next,num1_reg;
logic [(SIZE-1):0]      num2_next,num2_reg;
logic [(2*SIZE-1):0]    result_next; 
logic                   ready_next;
logic [(2*SIZE-1):0]    temp;
logic [$clog2(SIZE):0]  cnt,cnt_next;




always_comb begin
   nstate=cstate;

case(cstate)
   IDLE:
    begin
       ready_next = '0;
       if(start)
       begin
          num1_next = num1;
          num2_next = num2;
          result_next = '0;
          cnt_next    = '0;
                                      nstate=EXECUTION;
       end 
    end 
   EXECUTION:
      begin
         temp        =  {(2*SIZE){num2_reg[0]}} & num1_reg;
         result_next = result + temp;
         num2_next   = num2_reg >> 1;
         num1_next   = num1_reg << 1;
         cnt_next    = cnt + 1;;
         if(cnt == SIZE) 
         begin      
            ready_next = 1'b1;
                                     nstate=IDLE; 
         
         end 
      end 
endcase 

end 
    
    
    
    
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      cstate   <= IDLE;
      ready    <= '0;
      num1_reg <= '0; 
      num2_reg <= '0; 
      result   <= '0; 
      cnt      <= '0;
   end else begin
      cstate   <= nstate;
      num1_reg <= num1_next; 
      num2_reg <= num2_next;
      result   <= result_next;  
      cnt      <= cnt_next;
      ready    <= ready_next;
   end 
end     
    
    
    
    
endmodule :unsigned_mul_method1




module unsigned_mul_method1_tb();

parameter SIZE = 32;
logic               clk;
logic               rstn;
logic               start;  
logic [(SIZE-1):0]  num1;
logic [(SIZE-1):0]  num2;
logic [(2*SIZE-1):0]    result;
logic               ready;
//
logic [(SIZE-1):0]  t_num1;
logic [(SIZE-1):0]  t_num2;
logic [(2*SIZE-1):0]   t_result;
// Clock Generation
initial begin
   clk = 1'b0;
   forever #10 clk = ~clk;
end 


// Reset Task 
task RESET();
   rstn = 1'b1;
   repeat(2) @(negedge clk);
   rstn = 1'b0;   
   repeat(2) @(negedge clk);
   rstn = 1'b1;   
endtask 



task SEND(   input  logic [(SIZE-1):0]   inum1,
             input  logic [(SIZE-1):0]   inum2,
             input  logic [(2*SIZE-1):0]   expected);
begin
    @(posedge clk);
       start <= 1'b1;
       num1  <= inum1;
       num2  <= inum2;
    @(posedge clk);
       start <= '0;
       num1  <= '0;
       num2  <= '0;   
    @(posedge clk iff ready);
    if (result != expected) $display("ERROR! EXPECTED:%h != ACTUAL:%h",expected,result);
    else $display("ALL GOOD! EXPECTED:%h == ACTUAL:%h",expected,result);   
end 
endtask 



initial begin
   RESET();
   SEND( .inum1 (32'b0010),.inum2 (32'b0011), .expected(64'b0000_0110));
   SEND( .inum1 (32'b1111),.inum2 (32'b1111), .expected(64'b1110_0001));
   SEND( .inum1 (32'hFFFFFFFF),.inum2 (32'hFFFFFFFF), .expected(64'hFFFF_FFFE_0000_0001));

   for(int i=0;i<100;i++)
   begin
      t_num1 = $random;
      t_num2 = $random;
      t_result = t_num1 * t_num2;
      SEND( .inum1 (t_num1),.inum2 (t_num2), .expected(t_result));
   end 


$finish;
end 




unsigned_mul_method1
#(.SIZE (SIZE))
DUT
(.*);


endmodule:unsigned_mul_method1_tb
 
