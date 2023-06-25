`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// tree Least Recently Algorithm for 8-Way Set Associative Cache  
//////////////////////////////////////////////////////////////////////////////////
`define line0_and 7'b0_0_1_0_1_1_1
`define line1_and 7'b1_0_1_0_1_1_1
`define line2_and 7'b1_1_0_0_1_1_1
`define line3_and 7'b1_1_1_0_1_1_1
`define line4_and 7'b1_1_1_1_0_0_1
`define line5_and 7'b1_1_1_1_1_0_1
`define line6_and 7'b1_1_1_1_1_1_0
`define line7_and 7'b1_1_1_1_1_1_1

`define line0_or  7'b0_0_0_0_0_0_0
`define line1_or  7'b1_0_0_0_0_0_0
`define line2_or  7'b0_1_0_0_0_0_0
`define line3_or  7'b0_1_1_0_0_0_0
`define line4_or  7'b0_0_0_1_0_0_0
`define line5_or  7'b0_0_0_1_1_0_0
`define line6_or  7'b0_0_0_1_0_1_0
`define line7_or  7'b0_0_0_1_0_1_1





module tree_lru
  (
  input  logic        clk,
  input  logic        rstn, 
  //
  input  logic [7:0]  i_access_line,
  input  logic        i_access_en,   
  output logic [7:0]  o_lru_line
  );
  
  
 logic [6:0] lru_tree; 
 logic [7:0]  mux0,mux1,mux2,mux3,mux4,mux5,mux6;
 
 
 
 always_ff @(posedge clk or negedge rstn)
 begin
    if(!rstn)
    begin
       lru_tree <= '0;    
    end else begin
       if(i_access_en)
       begin
          case(i_access_line)  
             'd0: lru_tree <= (lru_tree & `line0_and) | `line0_or;
             'd1: lru_tree <= (lru_tree & `line1_and) | `line1_or;
             'd2: lru_tree <= (lru_tree & `line2_and) | `line2_or;
             'd3: lru_tree <= (lru_tree & `line3_and) | `line3_or;
             'd4: lru_tree <= (lru_tree & `line4_and) | `line4_or;
             'd5: lru_tree <= (lru_tree & `line5_and) | `line5_or;
             'd6: lru_tree <= (lru_tree & `line6_and) | `line6_or;
             'd7: lru_tree <= (lru_tree & `line7_and) | `line7_or;
          endcase 
       end 
    end  
 end 
 

//==================================== 
// Mux Tree for Least Recently Used Line 
//==================================== 
 always_comb
 begin
    mux0 =  lru_tree[0] ? 'd6 : 'd7; 
    mux2 =  lru_tree[2] ? 'd4 : 'd5; 
    mux4 =  lru_tree[4] ? 'd2 : 'd3; 
    mux6 =  lru_tree[6] ? 'd0 : 'd1; 
    //
    mux1 =  lru_tree[1] ? mux2 : mux0; 
    mux5 =  lru_tree[5] ? mux6 : mux4; 
    //
    mux3 =  lru_tree[3] ? mux5 : mux1;  
 end 
 
 
always_ff @(posedge clk or negedge rstn)
begin
   if(!rstn)
   begin
      o_lru_line <= '0;
   end else begin
      o_lru_line <= mux3;
   end 
end 
 
  
  
endmodule :tree_lru



//=========================================
// TEST BENCH 
//=========================================
module tree_lru_tb();
parameter N = 8;

logic        clk;
logic        rstn; 
//
logic [7:0]  i_access_line;
logic        i_access_en;   
logic [7:0]  o_lru_line;
 
// Clock Generation 
initial begin
clk = 1'b0;
fork
   forever #10 clk = ~clk;
join
  
end 
  
//=======================  
// RESET GENERATION
//=======================  
  task RESET();
  begin
    i_access_line = '0;
    i_access_en   = '0;
    //
    rstn          = 1'b1;
    @(posedge clk);
       rstn = 1'b0;
    repeat(2) @(posedge clk);
       rstn = 1'b1;
  end 
  endtask
  
  
//=======================  
// ACCESS SIGNAL GENERATION
//=======================  
  task ACCESS(input logic [7:0] access_line);
  begin
    @(posedge clk);
       i_access_en   = 1'b1;
       i_access_line = access_line;
    @(posedge clk);
       i_access_en   = '0;
       i_access_line = '0;
    repeat(2)@(posedge clk);
  end 
  endtask 
  
initial begin
  RESET();
  repeat(10) @(posedge clk);  
  ACCESS(0);
  ACCESS(1);
  ACCESS(2);
  ACCESS(3);
  ACCESS(4);
  ACCESS(5);
  ACCESS(6);
  ACCESS(7);
  ACCESS(2);
  ACCESS(1);
  ACCESS(4);
  repeat(30) @(posedge clk);
  $finish;
end 
  

  
//////////////////////////////  
// DUT INSTANTIATION   
////////////////////////////// 
tree_lru utree_lru
  (.*);  







endmodule :tree_lru_tb 


