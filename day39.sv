// UVM series 1: UVM Phases.  
//  Reading: https://www.chipverify.com/uvm/uvm-phases



   `include "uvm_macros.svh"
    import uvm_pkg::*;




  class my_test extends uvm_test;
    `uvm_component_utils(my_test)
    

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    
    
     // BUILD PHASE 
    function void build_phase(uvm_phase phase);
      $display("...my_test --> build_phase function ...");
    endfunction   
    
    // CONNECT PHASE 
    function void connect_phase(uvm_phase phase);
      $display("...my_test --> connect_phase function ...");
    endfunction
    
    // END OF ELABORATION PHASE 
    function void end_of_elaboration_phase(uvm_phase phase);
      $display("...my_test --> end_of_elaboration_phase function ...");
    endfunction   
    
    // START OF SIMULATION PHASE 
    function void start_of_simulation_phase(uvm_phase phase);
      $display("...my_test --> start_of_simulation_phase function ...");
    endfunction   
    
    // RUN PHASE 
    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      #10;
      $display("...my_test --> run_phase task ...");
      phase.drop_objection(this);
    endtask
    
    // EXTRACT PHASE 
    function void extract_phase(uvm_phase phase);
      $display("...my_test --> extract_phase function ...");
    endfunction      
    
    // CHECK PHASE 
    function void check_phase(uvm_phase phase);
      $display("...my_test --> check_phase function ...");
    endfunction         
    
    // REPORT PHASE 
    function void report_phase(uvm_phase phase);
      $display("...my_test --> report_phase function ...");
    endfunction         

    // FINAL PHASE 
    function void final_phase(uvm_phase phase);
      $display("...my_test --> final_phase function ...");
    endfunction        
    

  endclass



module top;
  import uvm_pkg::*;

  
  initial begin
    $display("...module top...");
    run_test("my_test");
  end
  
  
endmodule

