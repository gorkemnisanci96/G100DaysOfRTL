`timescale 1ns / 1ps
// OUTPUT ENCODED STATES 

// OUTPUT TABLE (Moore Machine: Output Values are determined by solely by its current state) 
// STATE |x0 | rd | ds |  
// IDLE  | 0 | 0  | 0  |  
// READ  | 0 | 0  | 1  | 
// DLY   | 1 | 0  | 1  | 
// DONE  | 0 | 1  | 0  | 



module day56 (
   input  logic clk, 
   input  logic rstn,
   input  logic go, 
   input  logic ws, 
   output logic rd,
   output logic ds
);

typedef enum logic [2:0] {
 //        x0_ds rd
  IDLE = 3'b0_00,
  READ = 3'b0_01,
  DLY  = 3'b1_01,
  DONE = 3'b0_10,
  XXX  = 'x
} state_type;

  
state_type state, next; 
  
  
//============================
// State Register
//============================
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn) begin state <= IDLE; end 
  else      begin state <= next; end 
end 

  
  
//============================
// Next State Combinational always Block 
//============================
always_comb begin
  next = XXX; 
  case(state)
    IDLE:
    begin 
       if(go) begin next = READ;  end 
       else   begin next = IDLE;  end  
    end 
    READ:begin next = DLY; end 
    DLY: 
      begin
        if(!ws) begin next = DONE;  end 
        else    begin next = READ;  end 
      end 
    DONE:       begin next = IDLE;  end 
    default:    begin next = XXX;   end 
  endcase 
  
end 


//============================
// Output Assignment 
//============================
// Outputs are assigned directly from the state register bits 
assign ds = state[1];
assign rd = state[0]; 
        
        
endmodule :day56


//==========================================
// TEST BENCH 
//==========================================
module day56_tb();

logic clk;
logic rstn;
logic rd;
logic go;
logic ws;
logic ds;

//=========================
// CLOCK GENERATION 
//=========================
initial begin
   clk = '0;
   forever #10 clk = ~clk;
end 


//=========================
// RESET TASK 
//=========================
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


//=========================
// GO Flag Generation 
//=========================
task GO(input logic i_ws = 1'b0);
begin
   @(posedge clk);
   wait((uday56.state==uday56.IDLE))
   @(posedge clk);
   go <= 1'b1;
   ws <= i_ws;
   @(posedge clk);
   go <= 1'b0;
   if(i_ws)
   begin
      repeat(5) @(posedge clk);
      ws <= '0;
   end 
end 
endtask


initial begin
 
RESET();
GO(.i_ws (1'b0));
GO(.i_ws (1'b1));

$finish;
end 


// DUT Instantiation 
day56 uday56(.*);


endmodule :day56_tb
