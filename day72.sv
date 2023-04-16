`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Difference between "==" and "===" operator
// 1
// ==  tests logical equality (tests for 1 and 0, all other will result in x)
// === tests 4-state logical equality (tests for 1, 0, z and x)
// 2
// == can be synthesized into a hardware (x-nor gate)
// === can't be synthesized as x is not a valid logic level in digital

module equality_op();



logic a,b;


initial begin
$display(" = = VS = = =");
// TEST 1
a = 1'bx;
b = 1'bx;
$display("1=(%b==%b)=%b  (%b===%b)=%b",a,b,(a==b),a,b,(a===b));
#10
// TEST 2
a = 1'b1;
b = 1'bx;
$display("1=(%b==%b)=%b  (%b===%b)=%b",a,b,(a==b),a,b,(a===b));
#10
// TEST 3
a = 1'b0;
b = 1'bx;
$display("1=(%b==%b)=%b  (%b===%b)=%b",a,b,(a==b),a,b,(a===b));
#10
// TEST 4
a = 1'bz;
b = 1'bz;
$display("1=(%b==%b)=%b  (%b===%b)=%b",a,b,(a==b),a,b,(a===b));
#10
// TEST 5
a = 1'b1;
b = 1'bz;
$display("1=(%b==%b)=%b  (%b===%b)=%b",a,b,(a==b),a,b,(a===b));
#10
// TEST 6
a = 1'b0;
b = 1'bz;
$display("1=(%b==%b)=%b  (%b===%b)=%b",a,b,(a==b),a,b,(a===b));
#10
// TEST 7
a = 1'bx;
b = 1'bz;
$display("1=(%b==%b)=%b  (%b===%b)=%b",a,b,(a==b),a,b,(a===b));
#10
// TEST 8
a = 1'b0;
b = 1'b0;
$display("1=(%b==%b)=%b  (%b===%b)=%b",a,b,(a==b),a,b,(a===b));
#10
// TEST 9
a = 1'b1;
b = 1'b0;
$display("1=(%b==%b)=%b  (%b===%b)=%b",a,b,(a==b),a,b,(a===b));
#10
$display(" != VS != =");
// TEST 1
a = 1'bx;
b = 1'bx;
$display("1=(%b!=%b)=%b  (%b!==%b)=%b",a,b,(a!=b),a,b,(a!==b));
#10
// TEST 2
a = 1'b1;
b = 1'bx;
$display("1=(%b!=%b)=%b  (%b!==%b)=%b",a,b,(a!=b),a,b,(a!==b));
#10
// TEST 3
a = 1'b0;
b = 1'bx;
$display("1=(%b!=%b)=%b  (%b!==%b)=%b",a,b,(a!=b),a,b,(a!==b));
#10
// TEST 4
a = 1'bz;
b = 1'bz;
$display("1=(%b!=%b)=%b  (%b!==%b)=%b",a,b,(a!=b),a,b,(a!==b));
#10
// TEST 5
a = 1'b1;
b = 1'bz;
$display("1=(%b!=%b)=%b  (%b!==%b)=%b",a,b,(a!=b),a,b,(a!==b));
#10
// TEST 6
a = 1'b0;
b = 1'bz;
$display("1=(%b!=%b)=%b  (%b!==%b)=%b",a,b,(a!=b),a,b,(a!==b));
#10
// TEST 7
a = 1'bx;
b = 1'bz;
$display("1=(%b!=%b)=%b  (%b!==%b)=%b",a,b,(a!=b),a,b,(a!==b));
#10
// TEST 8
a = 1'b0;
b = 1'b0;
$display("1=(%b!=%b)=%b  (%b!==%b)=%b",a,b,(a!=b),a,b,(a!==b));
#10
// TEST 9
a = 1'b1;
b = 1'b0;
$display("1=(%b!=%b)=%b  (%b!==%b)=%b",a,b,(a!=b),a,b,(a!==b));
#10
$display(" THE IF & ELSE STATEMENT ");
// TEST 1
a = 1'bx;
b = 1'bx;
if(a==b)begin  $display("if(%b==%b) == TRUE  ",a,b);    end 
   else begin  $display("if(%b==%b) == FALSE ",a,b);    end 
// TEST 2
if(a===b)begin $display("if(%b===%b) == TRUE  ",a,b);    end 
    else begin $display("if(%b===%b) == FALSE ",a,b);    end 
// TEST 3
if(a>b)begin $display("if(%b>%b) == TRUE  ",a,b);    end 
  else begin $display("if(%b>%b) == FALSE ",a,b);    end 
    
$finish;
end 






endmodule :equality_op
