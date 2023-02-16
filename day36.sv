`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class Series 3: Polymorphism & Virtual Methods 
// Polymorphism allows the use of a variable of the base class type to hold subclass 
// objects and to reference the methods of those subclasses directly from the superclass variable.  


class animal;
  string name = "";
  int    age  = 0;
  
  function new (input string i_name,input int i_age);
     name = i_name;
     age  = i_age;
     $display("You created a %d years old Animal called %s ",age,name);
  endfunction
  
  virtual function void sound();
   $fatal(1, "Generic animals dont have a sound.");
  endfunction :sound 


endclass :animal


class dog extends animal;
 
   function new(input string i_name, input int i_age);
      super.new(i_name,i_age);
   endfunction
 
   // We overwrite the sound() function of the Parent Class. 
   function void sound();
      $display(" The dog says how!!");
   endfunction

endclass :dog


class cat extends animal;
 
   function new(input string i_name, input int i_age);
      super.new(i_name,i_age);
   endfunction
 
   // We overwrite the sound() function of the Parent Class. 
   function void sound();
      $display(" The CAT(%s,%d) says MEOW!!",name,age);
   endfunction

endclass :cat





module day36();

dog dog1;
animal animal1; 
cat cat1;
animal animal2; 

initial begin
    dog1 = new(.i_name("Odi"), .i_age(5));
    cat1 = new(.i_name("Pufi"), .i_age(1)); 
  //dog1.sound();
  //
  animal1 = new(.i_name("Bobi"), .i_age(2)); 
  animal1.sound();
  animal1 = dog1;
  animal1.sound();
  //
  animal2 = cat1;
  animal2.sound();
  
#10
$finish;
end 


endmodule :day36
