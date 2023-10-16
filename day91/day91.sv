`timescale 1ns / 1ps

module dff(
   input  logic clk, 
   input  logic rstn, 
   input  logic D,
   output logic Q, 
   output logic Qn 
);


always_ff @(posedge clk or negedge rstn)
begin
 
   if(!rstn)
   begin
      Q <= '0; 
   end else begin
      Q <= D;
   end 
end 

assign Qn = ~Q;

endmodule :dff 


module ripple_counter(
    input logic        clk, 
    input logic        rstn, 
    output logic [3:0] cnt
);


logic q0,q1,q2,q3;
logic qn0,qn1,qn2,qn3;

dff dff0(
   .clk   (clk),
   .rstn  (rstn),
   .D     (qn0),
   .Q     (q0),
   .Qn    (qn0)
);

dff dff1(
   .clk   (qn0),
   .rstn  (rstn),
   .D     (qn1),
   .Q     (q1),
   .Qn    (qn1)
);

dff dff2(
   .clk   (qn1),
   .rstn  (rstn),
   .D     (qn2),
   .Q     (q2),
   .Qn    (qn2)
);

dff dff3(
   .clk   (qn2),
   .rstn  (rstn),
   .D     (qn3),
   .Q     (q3),
   .Qn    (qn3)
);


assign cnt[0] = q0;
assign cnt[1] = q1;
assign cnt[2] = q2;
assign cnt[3] = q3;






endmodule :ripple_counter 



module ripple_counter_tb();

logic        clk; 
logic        rstn; 
logic [3:0]  cnt;

   
   
initial begin
   clk = 1'b0;
   forever #10 clk = ~clk;
end 

task RESET();
begin
   rstn = 1'b1;
   repeat(2) @(posedge clk); 
   rstn = 1'b0;
   repeat(2) @(posedge clk);
   rstn = 1'b1;
end 
endtask 
   
   
initial begin 
   RESET();
   
   
   repeat(10) @(posedge clk);
   $finish;
end    
   
ripple_counter DUT(.*);


endmodule :ripple_counter_tb
