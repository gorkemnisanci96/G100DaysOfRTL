// 4-bit sequential Multiplier 


module day60(
   input  logic clk, 
   input  logic rstn, 
   input  logic [3:0] A, 
   input  logic [3:0] B,
   input  logic      en,
   output logic [7:0] C
);
  
  
  
  typedef enum{IDLE,EX} state_type;
  state_type state, state_next;
  int count,count_next;
  logic [3:0] adder;
  logic [7:0] C_next;
  
  logic [8:0] temp,temp_next;
  
  always_comb 
  begin
    state_next = state;
    temp_next  = temp;
    count_next = count;
    C_next     = C;
    
    case(state)
      IDLE:
        begin
          if(en)
            begin
              temp_next  = {4'b0,B};
              count_next = '0;
                                        state_next = EX;
            end 
        end 
      EX:
        begin
          
          if(count < 4)
            begin
              adder      = temp[0] ? A : '0 ;             // Choose the adder 
              temp_next  = temp_next + {1'b0,adder,4'b0}; // add the adder to the shift reg 
              temp_next  = {1'b0,temp_next[8:1]};         // Shift the register 
              count_next = count + 1;
            end else begin
              C_next = temp[7:0];
              count_next = '0;
              temp_next  = '0;
                                         state_next = IDLE;
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
          count <= '0;
          temp  <= '0;
          C     <= '0;
        end else begin
          count <= count_next;
          temp  <= temp_next;
          C     <= C_next;          
        end 
    end 
  
  
  
  
  
  
endmodule 





module day60_tb();
  
  
logic       clk;
logic       rstn; 
logic [3:0] A; 
logic [3:0] B;
logic      en;
logic [7:0] C;  
  
  
initial begin
  clk = 1'b0;
  forever #10 clk = ~clk;
end 
  
  
task RESET();
 begin
      A    = '0;
      B    = '0;
      en   = '0;
      rstn = 1'b1;
      repeat(2) @(posedge clk);
      rstn = 1'b0;
      repeat(2) @(posedge clk);
      rstn = 1'b1;
      repeat(2) @(posedge clk);
 end 
endtask
  
  
  
initial  begin
  RESET();
  repeat(10) @(posedge clk);
  A = 7;
  B = 7;
  en = 1'b1;
  @(posedge clk);
  en = 1'b0;  
  repeat(20) @(posedge clk);
  $finish;
end 
  
  
  
    // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, day60);
  end
  
 
day60   uday60(.*);  
  
  
endmodule 
