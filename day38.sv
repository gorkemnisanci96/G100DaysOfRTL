`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// SV Classes 5: Parameterized Class Definitions  
//
//

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

   function void get_info();
     $display("Name:%s Age:%d",name,age);
   endfunction

endclass 


class dog extends animal;
 
   function new(input string i_name, input int i_age);
      super.new(i_name,i_age);
   endfunction
 
   // We overwrite the sound() function of the Parent Class. 
   function void sound();
     $display(" The dog says HOW!!");
   endfunction

endclass 


class cat extends animal;
 
   function new(input string i_name, input int i_age);
      super.new(i_name,i_age);
   endfunction
 
   // We overwrite the sound() function of the Parent Class. 
   function void sound();
      $display(" The CAT(%s,%d) says MEOW!!",name,age);
   endfunction

endclass :cat


class animal_cage #(type T);

    static T cage[$];
    
    static function void cage_animal(T l);
       cage.push_back(l);
    endfunction :cage_animal


    static function void list_animals();
      $display("The Cage List:");
      foreach(cage[i])
        cage[i].get_info();
    endfunction : list_animals
    
    
endclass: animal_cage 


/////////////////////////////
// MODULE 
/////////////////////////////
module day38();

  dog dog0;
  dog dog1;
  dog dog2;
  dog dog3;
  //
  cat cat0;
  cat cat1;
  cat cat2;
  cat cat3;



initial begin
  //
  dog0 = new(.i_name("dog0"), .i_age(1));
  dog1 = new(.i_name("dog1"), .i_age(2));
  dog2 = new(.i_name("dog2"), .i_age(3));
  dog3 = new(.i_name("dog3"), .i_age(4));
  //
  cat0 = new(.i_name("cat0"), .i_age(5));
  cat1 = new(.i_name("cat1"), .i_age(4));
  cat2 = new(.i_name("cat2"), .i_age(3));
  cat3 = new(.i_name("cat3"), .i_age(1));  
  //
  animal_cage#(dog)::cage_animal(dog0);
  animal_cage#(dog)::cage_animal(dog1);
  animal_cage#(dog)::cage_animal(dog2);
  animal_cage#(dog)::cage_animal(dog3);
  //
  animal_cage#(cat)::cage_animal(cat0);
  animal_cage#(cat)::cage_animal(cat1);
  animal_cage#(cat)::cage_animal(cat2);
  animal_cage#(cat)::cage_animal(cat3);
  //
  // Lets print the List of Animals in the cage.  
  $display("THE DOGS");
  animal_cage#(dog)::list_animals();
  $display("THE CATS");
  animal_cage#(cat)::list_animals();
  //
  //
$finish;
end 


endmodule
