///////////////////////////////////////////////
// X-Optimism and X-Pasimism 
// Verilog has four logic values 
// 0
// 1
// X: Unknown 
// Z: HighImpedance (Un-diriven, tri-stated Signal)
// Resources 
// 1- http://www.verilogpro.com/systemverilog-verilog-x-optimism/
// 2- https://sutherland-hdl.com/papers/2013-DVCon_In-love-with-my-X_paper.pdf
// 3- https://www.verilogpro.com/systemverilog-verilog-x-optimism-pessimism/

module day27();


////////////////////////////////
// EXAMPLE 1  
////////////////////////////////
// X-Optimistic Design 
// In this example, we dont define the "sel" signal 
// and the MUX below selects the ELSE case, which does not correctly represents the 
// physical circuit.
// So the a value becomes 1'b1 in this example when sel1==1'bx 
logic sel;
logic a1;

always_comb
begin
   
   if(sel)
   begin
      a1 = 1'b0;
   end else begin
      a1 = 1'b1;
   end 

end 


////////////////////////////////
// EXAMPLE 2  
////////////////////////////////
// This example is similar to the above example but we create the MUX with a Case 
// Statement. Again the behaviour is different then the intendent behaviout.
// The case statement does not match with anyone of the cases so the a2 will
// keep its value.  

logic a2;

always_comb 
begin
   case(sel)
     1'b0: a2 = 1'b0;
     1'b1: a2 = 1'b1;
   endcase 
end 

////////////////////////////////
// EXAMPLE 3  
////////////////////////////////
// The transition to X can create a fake posedge. 
// The list of transitions that creates posedge transitions 
// 0 -> 1 
// 0 -> X 
// 0 -> Z 
// X -> 1
// Z -> 1 
// Example below shows two of the cases above to generate
// Rising edge that is triggering a register with an adder circuit. 

logic a3;
logic [8:0] a4 = 1'b0;

initial begin
// Rising Edge 1 
#10
a3 = 1'b1; 
#10
// Rising Edge 2 
a3 = 1'b0;
#10
a3 = 1'bx;
#10

$finish;
end 


always_ff @(posedge a3)
begin
   a4 <=  a4 + 1'b1;
end 

////////////////////////////////
// EXAMPLE 5
////////////////////////////////
// X-Pesimistic if/else Design 

logic a5;

always_comb 
begin
     a5 = 1'b0;
    if(sel)
    begin
       a5 = 1'b0;
    end else if (!sel)
    begin
       a5 = 1'b1;    
    end else begin
       a5 = 1'bx;    
    end 
    
end 

////////////////////////////////
// EXAMPLE 6
////////////////////////////////
// X-Pesimistic Aproach 

logic a6;

always_comb 
begin
    a6 = 1'b0; // Initialize the signal to zero to see that we are setting the value to the x. 
   case(sel)
      1'b0:    a6 = 1'b0;
      1'b1:    a6 = 1'b1;
      default: a6 = 1'bx;
   endcase 
end 

////////////////////////////////
// EXAMPLE 7
//////////////////////////////// 

logic a7;
logic sel2;

initial begin
#10 ;
sel2 = 1'b0;
#10;
sel2 = 1'b1;
#10;
sel2 = 1'bx;
#10;

end 

always_comb begin
  //
  assert(sel2 === 1'bx) $error("SEL IS X"); 
   else $display ("OK. SEL IS NOT X, SEL == %b",sel2); 
   // 
  if (sel)
  begin
    a7 = 1'b0;
  end else begin
    a7 = 1'b1;
  end 
end

   
endmodule :day27 
