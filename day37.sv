`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// SV Classes 4: Static Methods and Variables   
// Memory for a static class member is allocated as soon as we define the class. 
// We have only one copy of the static variable no matter how many times we instantiate the class to create new objects.
// Reference: UVM Primer: An Introduction to the Universal Verification Methodology
//
//

//////////////////////////////////////
/// Example 1 : Declera a static variable 
/////////////////////////////////////


class animal;
  static int animal_count = 0;
  string name="";
  int    age=0;

  function new(input string i_name, input int i_age);
     name = i_name;
     age  = i_age;
     animal_count++;
  endfunction
  
  function void get_info();
     $display("Name:%s Age:%d",name,age);
  endfunction
  
endclass 


class dog extends animal;

   function new(input string i_name, input int i_age);
      super.new(i_name,i_age);
   endfunction


endclass 

class dogcage;
  // We created a queue of class variables 
  // We need to use push_back() to push onto the queue 
  static dog cage[$]; 
endclass 


module day37();

dog dog0;
dog dog1;
dog dog2;
dog dog3;


initial begin

dog0 = new(.i_name("dog0"), .i_age(1));
dog1 = new(.i_name("dog1"), .i_age(2));
dog2 = new(.i_name("dog2"), .i_age(3));
dog3 = new(.i_name("dog3"), .i_age(4));
//
$display("Total Number of animals is %d",animal::animal_count);
// PUSH THE DOG Objects to the dog cage 
dogcage::cage.push_back(dog0);
dogcage::cage.push_back(dog1);
dogcage::cage.push_back(dog2);
dogcage::cage.push_back(dog3);
// All the dogs are in the cage 
foreach(dogcage::cage[i])
    dogcage::cage[i].get_info();
    
end 


endmodule :day37
