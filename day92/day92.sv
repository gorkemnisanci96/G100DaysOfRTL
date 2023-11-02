`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: The circuit Below Compares the two signed binary numbers and generates two flags.
// o_greater == 1 if A>B 
// o_equal   == 1 if A==B
// o_greater == 0 if A<=B 
// o_equal   == 0 if A!=B
//////////////////////////////////////////////////////////////////////////////////


module unsigned_comparison
#(parameter WIDTH=4)
(
 input logic [(WIDTH-1):0] A, 
 input logic [(WIDTH-1):0] B, 
 output logic              o_greater, 
 output logic              o_equal  
    );
    
 
logic [(WIDTH-1):0] B_ones_comp; 
logic [WIDTH:0]     sum_result; 
 
assign B_ones_comp = ({WIDTH{1'b1}} ^ B);  
 
assign sum_result  = {1'b0,A} + {1'b0,B_ones_comp} + 1;
 
assign o_greater   = sum_result[WIDTH] & ~o_equal; 
assign o_equal     = ~|sum_result[WIDTH-1:0]; 

 
endmodule :unsigned_comparison



module signed_comparison
#(parameter WIDTH=4)
(
 input logic [(WIDTH-1):0] A, 
 input logic [(WIDTH-1):0] B, 
 output logic              o_greater, 
 output logic              o_equal  
    );
    
 logic   greater_unsigned; 
 logic   equal_unsigned;        
    
always_comb 
begin
   case({A[WIDTH-1],B[WIDTH-1]})
      2'b00:begin  o_greater = greater_unsigned; o_equal=equal_unsigned;  end 
      2'b01:begin  o_greater = 1'b1;             o_equal= 1'b0;           end 
      2'b10:begin  o_greater = 1'b0;             o_equal= 1'b0;           end 
      2'b11:begin  o_greater=greater_unsigned;   o_equal=equal_unsigned;  end 
   endcase 
end 

unsigned_comparison
#(.WIDTH (WIDTH-1))
unsigned_comparison
(
 .A           (A[WIDTH-2:0]), 
 .B           (B[WIDTH-2:0]), 
 .o_greater   (greater_unsigned), 
 .o_equal     (equal_unsigned)
    );   





endmodule :signed_comparison     
    
    





module binary_comparison_tb ();
 parameter WIDTH=4;
 
 logic [(WIDTH-1):0] A; 
 logic [(WIDTH-1):0] B; 
 logic               o_greater_unsigned,o_greater_signed; 
 logic               o_equal_unsigned,o_equal_signed;      


initial begin
   A = 4'b1011;
   B = 4'b1011;
   #(10);
   $display("UNSIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_unsigned,o_equal_unsigned);
   $display("SIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_signed,o_equal_signed);
   A = 4'b0000;
   B = 4'b0000;
   #(10);
   $display("UNSIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_unsigned,o_equal_unsigned);
   $display("SIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_signed,o_equal_signed);
   #(10);
   A = 4'b1111;
   B = 4'b1111;
   #(10);
   $display("UNSIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_unsigned,o_equal_unsigned);
   $display("SIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_signed,o_equal_signed);
   #(10);   
   A = 4'b1000;
   B = 4'b1000;
   #(10);
   $display("UNSIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_unsigned,o_equal_unsigned);
   $display("SIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_signed,o_equal_signed);
   #(10);    

   A = 4'b1111;
   B = 4'b1000;
   #(10);
   $display("UNSIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_unsigned,o_equal_unsigned);
   $display("SIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_signed,o_equal_signed);
   #(10);    
   A = 4'b1011;
   B = 4'b1100;
   #(10);
   $display("UNSIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_unsigned,o_equal_unsigned);
   $display("SIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_signed,o_equal_signed);
   #(10);       
   A = 4'b1101;
   B = 4'b1100;
   #(10);
   $display("UNSIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_unsigned,o_equal_unsigned);
   $display("SIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_signed,o_equal_signed);
   #(10);         
   A = 4'b1101;
   B = 4'b1110;
   #(10);
   $display("UNSIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_unsigned,o_equal_unsigned);
   $display("__SIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_signed,o_equal_signed);
   #(10);    

   A = 4'b1101;
   B = 4'b0000;
   #(10);
   $display("UNSIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_unsigned,o_equal_unsigned);
   $display("__SIGNED A:%b > B:%b Greater:%b Equal:%b",A,B,o_greater_signed,o_equal_signed);
   #(10);    

   
   $finish;
end 



unsigned_comparison #(.WIDTH (WIDTH))
unsigned_comparison_dut
(.A (A),
 .B (B),
 .o_greater (o_greater_unsigned),
 .o_equal   (o_equal_unsigned) );



signed_comparison #(.WIDTH (WIDTH))
signed_comparison_dut
(.A (A),
 .B (B),
 .o_greater (o_greater_signed),
 .o_equal   (o_equal_signed) );


endmodule :binary_comparison_tb 
