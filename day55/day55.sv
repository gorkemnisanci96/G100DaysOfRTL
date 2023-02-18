`timescale 1ns / 1ps
// ONE-HOT-3 Always Block State Machine 

module ONE_HOT_3_ALWAYS_BLOCK_STATE_MACHINE(
    input  logic clk,
    input  logic rstn,
    output logic rd,
    input  logic go,
    input  logic ws,
    output logic ds
    );
    
enum {
  IDLE = 0,
  READ = 1,
  DLY  = 2, 
  DONE = 3
} state_index;
 
logic [3:0] state, next; 




always_comb begin
  next = '0; 
  unique case (1'b1)
    state[IDLE]: 
        begin
          if(go) begin next[READ] = 1'b1; end 
          else   begin next[IDLE] = 1'b1; end 
        end 
    state[READ]: begin next[DLY]  = 1'b1;   end 
    state[DLY]: 
      begin
        if(!ws)  begin next[DONE] = 1'b1; end
        else     begin next[READ] = 1'b1; end 
      end 
    state[DONE]: begin next[IDLE] = 1'b1;  end 
    
  endcase 
  
end 

//==============================
// STATE REGISTER 
//==============================
always_ff @(posedge clk or negedge rstn)
  begin
    if(!rstn) begin
       state         <= '0;
       state[IDLE]   <= 1'b1; 
    end else begin
       state         <= next; 
    end 
  end 



//==============================
// OUTPUT REGISTERS 
//==============================
always_ff @(posedge clk or negedge rstn)
  begin
  
    if(!rstn) begin
      rd <= 1'b0;
      ds <= 1'b0; 
    end else begin
      rd <= 1'b0;
      ds <= 1'b0; 
      unique case(1'b1)
          next[READ]: begin rd <= 1'b1; ds <= 1'b0;  end 
          next[DLY]:  begin rd <= 1'b0; ds <= 1'b1;  end
          next[DONE]: begin rd <= 1'b1; ds <= 1'b1;  end
      endcase
    end   
  
  end     
    
    
    
endmodule :ONE_HOT_3_ALWAYS_BLOCK_STATE_MACHINE



//==========================================
// TEST BENCH 
//==========================================
module ONE_HOT_3_ALWAYS_BLOCK_STATE_MACHINE_tb();

logic clk;
logic rstn;
logic rd;
logic go;
logic ws;
logic ds;

initial begin
   clk = '0;
   forever #10 clk = ~clk;
end 


task RESET();
begin
   go = 1'b0;
   ws = 1'b0;
   rstn = 1'b1;
   @(posedge clk);
   rstn = 1'b0;
   repeat(2) @(posedge clk);
   rstn = 1'b1;
end 
endtask



task GO();
begin
   @(posedge clk);
   go = 1'b1;
   @(posedge clk);
   go = 1'b0;
end 
endtask


initial begin
 
RESET();
GO();

$finish;
end 


// DUT Instantiation 
ONE_HOT_3_ALWAYS_BLOCK_STATE_MACHINE uONE_HOT_3_ALWAYS_BLOCK_STATE_MACHINE(.*);


endmodule :ONE_HOT_3_ALWAYS_BLOCK_STATE_MACHINE_tb
