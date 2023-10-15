`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 1 digic Decimal BCD (4-bit) multiply by 5. 


module bcd_mul_by_5(
   input  logic [3:0] i_num_bcd,
   output logic [7:0] o_num_bcd
);


assign o_num_bcd[7]   = 1'b0;
assign o_num_bcd[6]   = i_num_bcd[3];
assign o_num_bcd[5]   = i_num_bcd[2];
assign o_num_bcd[4]   = i_num_bcd[1];
assign o_num_bcd[3]   = 1'b0;
assign o_num_bcd[2]   = i_num_bcd[0];
assign o_num_bcd[1]   = 1'b0;
assign o_num_bcd[0]   = i_num_bcd[0];



endmodule :bcd_mul_by_5




module bcd_mul_by_5_tb();

logic [3:0] i_num_bcd;
logic [7:0] o_num_bcd;

initial begin 
  $display("INPUT     OUTPUT");
  for(int i =0;i<10;i++)
  begin
     i_num_bcd = i;
     #5;
     $display("%b %d  %b %b  %d%d)",i_num_bcd,i_num_bcd,o_num_bcd[7:4],o_num_bcd[3:0],o_num_bcd[7:4],o_num_bcd[3:0] );
  end 

end 



bcd_mul_by_5 ubcd_mul_by_5(.*);


endmodule 
