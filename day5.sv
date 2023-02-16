`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////
// day5_2d: Traverse a 2D-Matrix 
// day5_3d: Traverse a 3D-Matrix 



module day5_2d
#(parameter WIDTH  = 5, 
  parameter HEIGHT = 8)
(
  input logic clk, 
  input logic rstn, 
  output logic [($clog2(WIDTH)):0]  x, 
  output logic [($clog2(HEIGHT)):0] y
    );
    
logic [($clog2(WIDTH)):0]  x_next;
logic [($clog2(HEIGHT)):0] y_next;



always_comb 
begin
   x_next = x;
   y_next = y;
   
   if(y < (HEIGHT-1))
   begin
     y_next = y + 1;
   end else begin
     y_next = 0;
     if(x < (WIDTH-1))
     begin
       x_next = x + 1;
     end else begin
       x_next = 0;
     end  
   end 
end 




////////////////////////////////
// X REGISTER 
///////////////////////////////

always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    x <= 0;
  end else begin
    x <= x_next;
  end
end 


////////////////////////////////
// Y REGISTER 
///////////////////////////////

always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    y <= 0;
  end else begin
    y <= y_next;
  end
end 

        
endmodule : day5_2d


module day5_3d
#(parameter X_AXIS=3,
  parameter Y_AXIS=4,
  parameter Z_AXIS=5)
(
  input logic clk,
  input logic rstn, 
  output logic [($clog2(X_AXIS)):0] x,
  output logic [($clog2(Y_AXIS)):0] y,
  output logic [($clog2(Z_AXIS)):0] z
);


logic [($clog2(X_AXIS)):0] x_next;
logic [($clog2(Y_AXIS)):0] y_next;
logic [($clog2(Z_AXIS)):0] z_next;

always_comb
begin
  x_next = x;
  y_next = y;
  z_next = z;
  
  if(z < (Z_AXIS-1))
  begin
     z_next = z + 1;   
  end else begin
     z_next = 0; 
     if( y < (Y_AXIS-1))
     begin
       y_next = y + 1;
     end else begin
       y_next = 0;
       if(x < (X_AXIS-1))
       begin
         x_next = x + 1;
       end else begin
         x_next = 0; 
         z_next = 0; 
       end 
     end 
  end        
  

end 








/////////////////////////////
//  X REGISTER 
/////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    x <= 0;
  end else begin
    x <= x_next;
  end 
end 

/////////////////////////////
//  Y REGISTER 
/////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    y <= 0;
  end else begin
    y <= y_next;
  end 
end 

/////////////////////////////
//  Z REGISTER 
/////////////////////////////
always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn)
  begin
    z <= 0;
  end else begin
    z <= z_next;
  end 
end 




endmodule :day5_3d


///////////////////////////////////
//
//        TEST BENCH 
//
/////////////////////////////////// 



module day5_tb();



parameter WIDTH  = 5; 
parameter HEIGHT = 8;
//
parameter X_AXIS = 5;
parameter Y_AXIS = 3;
parameter Z_AXIS = 2;

logic clk; 
logic rstn;
logic [($clog2(WIDTH)):0]  x_2d;
logic [($clog2(HEIGHT)):0] y_2d;
//
logic [($clog2(X_AXIS)):0] x_3d;
logic [($clog2(Y_AXIS)):0] y_3d;
logic [($clog2(Z_AXIS)):0] z_3d;


// Clock Generation
initial begin
clk = 1'b0;

 fork
  forever #10 clk = ~clk;
 join

end 

// RESET TASK
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


repeat(30) @(posedge clk);
$finish;
end 


// DUT 1 Interpretation 
day5_2d
#(.WIDTH  (WIDTH), 
  .HEIGHT (HEIGHT)) 
uday5_2d
(
 .clk   (clk),
 .rstn  (rstn),
 .x     (x_2d),
 .y     (y_2d)
  );


// DUT 2 Interpretation 
day5_3d
#( .X_AXIS (X_AXIS),
   .Y_AXIS (Y_AXIS),
   .Z_AXIS (Z_AXIS)
) 
uday5_3d
(
 .clk   (clk),
 .rstn  (rstn),
 .x     (x_3d),
 .y     (y_3d),
 .z     (z_3d)
  );





endmodule:day5_tb 
