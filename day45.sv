// System Verilog Events

//////////////////////////////////
///  event Example 
/////
module day45_1();
  
  
 event event_1; 
 event event_2;   
 event event_3; 
  
  
  // Thread 1 : Wait for 30ns and trigger the event 1.
  // Wait for event_3 and terminate the program.
  initial begin
    #30 -> event_1;
    @(event_3);
    $display("The Event_3 is triggered time[%0t]",$time);
    $finish; 
  end 
  
  
  
  // Thread 2: Wait for the event_1 to be triggered
  // Then wait for 20ns and trigger the event_2  
  initial begin
    @(event_1);  
    $display("The Event_1 is triggered time[%0t]",$time);
    #20 -> event_2; 
  end 
  
  
  //Thread 3:  Wait for the event_2 to be triggered
  // wait for 10ns and trigger event_3
  initial begin
    wait(event_2.triggered);
    $display("The Event_2 is triggered time[%0t]",$time);
    #10 -> event_3;
  end 
  

  
  
endmodule 



//////////////////////////////////
///  wait_order Example 
/////
// It waits the events to be triggered in order. If the events are triggered out-of-order, it generates and error.  

module day45_2();
  
  
 event event_1; 
 event event_2; 
 event event_3; 

 initial begin
   #20 -> event_1;
   #20 -> event_2;   
   #20 -> event_3;
   //
   $finish;
 end 
   
initial begin
  
  wait_order(event_1,event_2,event_3)
    $display("[MSG1]-Events are executed in order");
  else 
    $display("[MSG2]-Events are not executed in order");
  
end 

endmodule 

