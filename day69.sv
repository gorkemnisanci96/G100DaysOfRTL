`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module BOOTH_MUL_ALGO
#(parameter SIZE = 4)
(
   input  logic                clk,
   input  logic                rstn,
   input  logic                start,
   input  logic                num1_signed,
   input  logic                num2_signed,
   input  logic [(SIZE-1):0]   num1,
   input  logic [(SIZE-1):0]   num2,
   output logic [(2*SIZE-1):0] result,
   output logic                ready
    );
    
    
enum logic {IDLE,EXECUTION} cstate,nstate;        
    
    
  
    
logic [(SIZE):0]    A_next,A;
logic [(SIZE+1):0]      Q_next,Q;
logic [(SIZE):0]    M_next,M;


logic [(2*SIZE):0]      result_next; 
logic                   ready_next;

logic [$clog2(SIZE+3):0]  cnt,cnt_next;




always_comb begin
   nstate      = cstate;
   A_next      = A;
   Q_next      = Q;
   M_next      = M;
   result_next = result;
   cnt_next    = cnt;
case(cstate)
   IDLE:
    begin
       ready_next = '0;
       if(start)
       begin
          A_next = '0;
          Q_next = num2_signed ? {num2[(SIZE-1)],num2,1'b0}: {1'b0,num2,1'b0};
          M_next = num1_signed ? {num1[(SIZE-1)],num1}: {1'b0,num1};
          result_next = '0;
          cnt_next    = '0;
                                      nstate=EXECUTION;
       end 
    end 
   EXECUTION:
      begin
          case(Q[1:0])
             2'b01   : begin A_next = A + M; end 
             2'b10   : begin A_next = A - M; end           
          endcase 
          Q_next = {A_next[0],Q[(SIZE+1):1]};
          A_next = {A_next[SIZE],A_next[SIZE:1]};
          cnt_next    = cnt + 1;;
          if(cnt == (SIZE+1)) 
          begin      
             result_next = {A,Q[(SIZE+1):1]};
             ready_next  = 1'b1;
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
      A        <= '0;
      Q        <= '0;
      M        <= '0;
      ready    <= '0;
      result   <= '0; 
      cnt      <= '0;
   end else begin
      cstate   <= nstate;
      A        <= A_next;
      Q        <= Q_next;
      M        <= M_next;
      result   <= result_next;  
      cnt      <= cnt_next;
      ready    <= ready_next;
   end 
end     
    
    
        
endmodule : BOOTH_MUL_ALGO 




module BOOTH_MUL_ALGO_tb();

parameter SIZE = 32;
logic               clk;
logic               rstn;
logic               start;  
logic               num1_signed;
logic               num2_signed;
logic [(SIZE-1):0]  num1;
logic [(SIZE-1):0]  num2;
logic [(2*SIZE-1):0]    result;
logic               ready;
//
logic [(SIZE-1):0]  t_num1;
logic [(SIZE-1):0]  t_num2;
logic t_num1_signed,t_num2_signed;
logic [(2*SIZE-1):0]   t_result;
int t_mod;
int error = 0;
// Clock Generation
initial begin
   clk = 1'b0;
   forever #10 clk = ~clk;
end 


// Reset Task 
task RESET();
   error  =0;
   rstn = 1'b1;
   repeat(2) @(negedge clk);
   rstn = 1'b0;   
   repeat(2) @(negedge clk);
   rstn = 1'b1;   
endtask 



task SEND(   input  logic [(SIZE-1):0]   inum1,
             input  logic [(SIZE-1):0]   inum2,
             input  logic      inum1_signed,
             input  logic      inum2_signed,
             input  logic [(2*SIZE-1):0]   expected);
begin
    @(posedge clk);
       start       <= 1'b1;
       num1        <= inum1;
       num2        <= inum2;
       num1_signed <= inum1_signed;
       num2_signed <= inum2_signed;
    @(posedge clk);
       start       <= '0;
       num1        <= '0;
       num2        <= '0;   
    @(posedge clk iff ready);
    if (result != expected)begin error++; $display("ERROR! sign1:%b num1:%b sign2:%b num2:%b EXPECTED:%h != ACTUAL:%h",inum1_signed,inum1,inum2_signed,inum2,expected,result); end
    else $display("ALL GOOD! EXPECTED:%h == ACTUAL:%h",expected,result);   
end 
endtask 



initial begin
   RESET();

   t_mod = ((1<<(SIZE-1))+1);
   for(int i=0;i<1000;i++)
   begin
      t_num1_signed = $urandom%2;
      t_num2_signed = $urandom%2;
      
      if(t_num1_signed)
      begin
       t_num1 = $urandom%t_mod;
      end else begin 
       t_num1 = $urandom;
      end 
      //
      if(t_num2_signed)
      begin
       t_num2 = $urandom%t_mod;
      end else begin 
       t_num2 = $urandom;
      end 
      //
      t_result = (t_num1 * t_num2);
      t_result = ({2*SIZE{(t_num1_signed ^ t_num2_signed)}} ^ t_result) +  (t_num1_signed ^ t_num2_signed);
      t_num1   = ({SIZE{t_num1_signed}} ^ t_num1) +  t_num1_signed; 
      t_num2   = ({SIZE{t_num2_signed}} ^ t_num2) +  t_num2_signed; 
      //
      SEND( .inum1        (t_num1),
            .inum2        (t_num2),
            .inum1_signed (t_num1_signed),
            .inum2_signed (t_num2_signed),
            .expected     (t_result));
     //    
   end 

   if(error == 0) begin       $display("TEST DONE ! NO ERROR !");   end
                  else begin  $display("ERRORS ! %d Errors ",error); end  


$finish;
end 




BOOTH_MUL_ALGO 
#(.SIZE (SIZE))
DUT
(.*);


endmodule:BOOTH_MUL_ALGO_tb


