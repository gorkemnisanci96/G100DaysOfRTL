`timescale 1ns / 1ps
/////////////////////////////////////////
// Class Series 2 : Inheritance-Extending Classes 
// The inheritance allows us to extend a "parent" class to create an other "child" class. 
// This allows us to add new features to a class by not changing the original class.

class rectangle;
    int l;
    int w; 
      
    function new(input int length, input int width);
       l = length;
       w = width;
    endfunction
    
    function int area();
       return l*w;
    endfunction
    
    task displaysides();
    begin
       $display("The Length: %d The Width:%d  ",l,w);
    end 
    endtask
    
        
endclass :rectangle 


class square extends rectangle; 
   int s; 

   function new(input int side);
      // We can call the Parent Class method 
      super.new( .length(side), .width(side));
      s = side;
   endfunction


endclass 


module day35();


rectangle rec1;
square seq1;

   initial begin
      rec1 = new(.length(3), .width(5) );
      seq1 = new(.side(7));
      
      $display("The Rec1 area %d ", rec1.area());
      // The Square can use the Parent Class Area() Function 
      $display("The seq1 area %d ", seq1.area());
      //
      rec1.displaysides();
      seq1.displaysides();
      //
      $display("The rec1 length %d ",rec1.l);
      //
      $display("The seq1 Side %d ", seq1.s);
   #10  
   $finish;   
   end 

endmodule :day35
