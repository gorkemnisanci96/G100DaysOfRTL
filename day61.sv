// Paramatrazible N-bit sequential Multiplier for SIGNED numbers 



module day61
  #(parameter N=4)
  (
   input logic              clk, 
   input logic              rstn,
    input logic [(N-1):0]   num1,
    input logic [(N-1):0]   num2,
   input logic              en, 
   output logic [(2*N-1):0] result  
  );
  
  
  typedef enum{IDLE,EX} state_type;
  state_type            state, state_next;
  logic [(2*N-1):0]     temp , temp_next;  
  logic [$clog2(N):0] index, index_next;
  logic [(2*N-1):0] result_next; 
  logic [(N-1):0]  to_add;
  logic [(N-1):0]  num1_2scomp;
  always_comb
    begin
      state_next  = state;
      result_next = '0; 
      index_next  = index;
      
      case(state)
        IDLE: begin
        
          if(en)
            begin
              temp_next  ='0;
              index_next ='0;
                                 state_next = EX;
            end 
        
        end   
        EX: 
          begin
            $display("INDEX:%d",index);
            if(index<N)
              begin
                if(index == (N-1))
                  begin
                    $display("INDEX == N-1");
                    num1_2scomp  =   ({N{1'b1}} ^ num1) + 1;
                    to_add    = (num2[index] ? num1_2scomp : 0) + temp[(2*N-1):(N)]; // Add Zero or the 2's comp of num1 
                  end else begin
                      to_add    = (num2[index] ? num1 : 0) + temp[(2*N-1):(N)]; // Add Zero or the num1  
                  end 
                 $display("to_add = %b",to_add);
                $display(" 1 temp = %b --> temp_next = %b",temp,temp_next);
                 temp_next = {to_add[N-1],to_add,temp[(N-1):1]};  // Arithmetic Shift to right      
                $display("2 temp = %b --> temp_next = %b",temp,temp_next);
                 index_next = index + 1;
              end else begin
                                   result_next = temp;
                                   state_next  = IDLE;                      
              end 
          end 
      endcase
      
    end 

  
  always_ff @(posedge clk or negedge rstn)
    begin
      if(!rstn)
        begin
          state <= IDLE;
        end else begin
          state <= state_next;
        end 
    end 
  

  always_ff @(posedge clk or negedge rstn)
    begin
      if(!rstn)
        begin
          index  <= '0;
          temp   <= '0;
          result <= '0;
        end else begin
          index  <= index_next;
          temp   <= temp_next;
          result <= result_next;
        end 
    end 
  
  
  

endmodule 







module day61_tb();
  
  // Number of Bits 
  parameter N = 16;
  
  logic             clk; 
  logic             rstn;
  logic [(N-1):0]   num1;
  logic [(N-1):0]   num2;
  logic             en;
  logic [(2*N-1):0] result;   
  
  
  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk; 
  end 
  
  
  task RESET();
    begin
        num1 = '0;
        num2 = '0; 
        en   = '0;
        rstn = 1'b1;
        repeat(2) @(posedge clk);
        rstn = 1'b0;  
        repeat(2) @(posedge clk);
        rstn = 1'b1;         
    end 
  endtask 
  
  // Stimulus 
  initial begin
    RESET();
    repeat(2) @(posedge clk);
    num1 = 7;
    num2 = -35;
    en = 1'b1;
    @(posedge clk);
    en = 1'b0;
    repeat(20) @(posedge clk);
    
    $finish;
  end 
  
  
  
  
  // Module Instantiation 
  day61 #( .N (N)) uday61 (.*); 
  
  
    // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, day61);
  end
  
endmodule 
