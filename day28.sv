`timescale 1ns / 1ps
///////////////////////////////////////////////////////
// Introduction to  System Verilog Classes. 
// Learning Outcomes
// 1- Define a Class with a constructor and a display method  
// 2- Declare class objects and use the class methods 
// Resources:
// 1- https://www.chipverify.com/systemverilog/systemverilog-class

class MyPacket;
   bit [2:0] header;
   bit       encode;
   bit [2:0] mode;
   bit [7:0] data;
   bit       stop;
   
   function new (input bit [2:0] header= 3'h1 , input bit  [2:0] mode = 3'h5);
      this.header = header;
      this.encode = 0;
      this.mode = mode;
      this.stop = 1'b1;
   endfunction

   function display();
       $display("Header = 0x%0h, Encode = %0b, Mode= 0x%0h, Stop= %0b",
                this.header, this.encode, this.mode, this.stop);
   endfunction


endclass 

module day28();
////////////////////////////
//  EXAMPLE 1 
////////////////////////////
// Define Class Objects 
MyPacket packet0, packet1;


initial begin
   packet0 = new(3'h2,2'h3);
   packet0.display();
   //
   packet1 = new(3'h1,3'h2);
   packet1.display();
   //
   // Accessing the Elements 
   $display("The Packet0 Header %b",packet0.header); 
   //
   // Modifiyin an array elements 
   packet0.header = 3'h7;
   $display("The Packet0 Header After Modification %b",packet0.header); 
$finish;
end 
////////////////////////////
//  EXAMPLE 1 
////////////////////////////
// Define array of Class Objects 
MyPacket packet[3];

initial begin
  for(int i=0;i<3;i++)
  begin
     packet[i] = new();
     packet[i].display();
  end 

end 






endmodule
