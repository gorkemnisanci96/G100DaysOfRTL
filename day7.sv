`timescale 1ns / 1ps
////////////////////////////////////////////////////
// System verilog Assertions Examples  
// 
// 

module day7_1();

logic clk;
logic rstn;

initial begin
clk=1'b0;
fork
 forever #10 clk = ~clk;
join
end 


////////////////////////////////////////////////////
//   EXAMPLE 1 
////////////////////////////////////////////////////
logic Req;
logic Ack;

initial begin
  rstn = 0;
  // Case 1 : Ack comes in CC2 after the Req and rstn = 0 
  // AckCheck1 : This failes at time:130ns because the request did not come 
  // AckCheck2 : AckCheck2 did not fail because, the check is disabled when the rstn==0.
  // AckCheck3 : This does not fail because the property passes when we get the ACK in 1cc or 2cc.
  Req = 1'b0;
  Ack = 1'b0;
  repeat(5) @(posedge clk);
  Req = 1'b1;
  @(posedge clk);
  Req = 1'b0;
  @(posedge clk);
  Ack = 1'b1;
  @(posedge clk);
  Ack = 1'b0;
  repeat(10) @(posedge clk);
  // Case 2 :
  // Now they all fail because the rstn = 1 and ACK does not come in CC1 or CC2.
  rstn = 1;
  Req = 1'b0;
  Ack = 1'b0;
  repeat(5) @(posedge clk);
  Req = 1'b1;
  @(posedge clk);
  Req = 1'b0;
  repeat(2)@(posedge clk);
  Ack = 1'b1;
  @(posedge clk);
  Ack = 1'b0;
  repeat(10) @(posedge clk);
  // Case3: 
  rstn = 1;
  Req = 1'b0;
  Ack = 1'b0;
  repeat(5) @(posedge clk);
  Req = 1'b1;
  @(posedge clk);
  Req = 1'b0;
  Ack = 1'b1;
  @(posedge clk);
  Ack = 1'b0;
  repeat(10) @(posedge clk);
    
   
   
   $finish;
end 



    
// Assertion Check 1 
property AckCheck1;  
@(posedge clk)
Req |-> ##1 Ack;
endproperty

assert property(AckCheck1) $display($time, " AckCheck1 PASS");
                     else $display($time, " AckCheck1 FAILED");

// Assertion Check 2 
property AckCheck2;  
@(posedge clk) disable iff(!rstn)
Req |-> ##1 Ack;
endproperty

assert property(AckCheck2) $display($time, " AckCheck2 PASS");
                     else $display($time, " AckCheck2 FAILED");

// Assertion Check 3 
property AckCheck3;  
@(posedge clk) disable iff(!rstn)
Req |-> ##[1:2] Ack;
endproperty

assert property(AckCheck3) $display($time, " AckCheck3 PASS");
                     else $display($time, " AckCheck3 FAILED");


    
endmodule :day7_1





module day7_2();

logic clk;
logic rstn;

initial begin
clk=1'b0;
fork
 forever #10 clk = ~clk;
join
end 



////////////////////////////////////////////////////
//   EXAMPLE 1 
////////////////////////////////////////////////////

logic a;
logic b;

initial begin
a= 1'b0;
b= 1'b0;
repeat(4) @(posedge clk);
a = 1'b1;
b = 1'b1;
@(posedge clk);
a = 1'b0;
@(posedge clk);
b = 1'b0;

$finish;
end 


//--We perform all the checks at the posedge of clk.-- 


// Property 1 
// $stable(a) Function Checks, where the signal is stable or not.
// The signal a is low everywhere other than the period (70-90 ns)
// So the abCheck1 fails on the 90ns and 110ns.   
property abCheck1;
  @(posedge clk) $stable(a);
endproperty 

assert property(abCheck1) $display($time, " abCheck1 PASS");
                     else $display($time, " abCheck1 FAIL");
          

                     
// Property 2 
// This check is checking if the signal "b" is stable or not
// The signal b is high only between 70-110 ns.
// So the abCheck2 fails on the 90ns.    
property abCheck2;
  @(posedge clk) $stable(b);
endproperty 

assert property(abCheck2) $display($time, " abCheck2 PASS");
                     else $display($time, " abCheck2 FAIL");                     


                   
// Property 3 
// This property is checking if it detects rising edge of the a.    
// It test the signal 'a', it fails everwhere other than time 90ns because at 70ns a has a rising edge. 
// 
property abCheck3;
  @(posedge clk) $rose(a);
endproperty 

assert property(abCheck3) $display($time, " abCheck3 PASS");
                     else $display($time, " abCheck3 FAIL");     
 
 
  
// Property 4 
// The abCheck4 checks the falling edge of the signal a every rising edge of the clk.
// The signal a is low everywhere other than the period (70-90 ns)
// So it fails everywhere other than 110ns. 
//
property abCheck4;
  @(posedge clk) $fell(a);
endproperty 

assert property(abCheck4) $display($time, " abCheck4 PASS");
                     else $display($time, " abCheck4 FAIL");     

                 


    
endmodule :day7_2
