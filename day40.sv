

   `include "uvm_macros.svh"
    import uvm_pkg::*;


/////////////////////////////////
// UVM SEQUENCE ITEM    
////////////////////////////////
class my_data extends uvm_sequence_item;
  bit [2:0] number;
endclass 

/////////////////////////////////
// Interface   
////////////////////////////////
interface dut_if();
  logic [2:0] data;
endinterface


/////////////////////////////////
// DUT    
///////////////////////////////
module dut(dut_if intf);
           

endmodule 




/////////////////////////////////
// UVM SEQUENCER   
////////////////////////////////
// It is not required to create a custom sequencer. We can use the pre-defined uvm_sequencer class. 
class my_sequencer extends uvm_sequencer;
  `uvm_component_utils (my_sequencer)

  
  function new (string name="m_sequencer", uvm_component parent);
    super.new (name,parent);
  endfunction

  
    virtual function void build_phase (uvm_phase phase);
      $display("my_sequencer --> build_phase");
    
  endfunction
  
  
  
  
endclass 



/////////////////////////////////
// UVM SCOREBOARD    
////////////////////////////////
class my_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils (my_scoreboard);
  
  function new (string name = "my_scoreboard", uvm_component parent =null);
    super.new (name,parent);
  endfunction
  
  
  function void build_phase (uvm_phase phase);
    $display("my_scoreboard --> my_scoreboard");
  endfunction
  
  
endclass 







/////////////////////////////////
// UVM DRIVER   
////////////////////////////////
class my_driver extends uvm_driver;
  
  `uvm_component_utils (my_driver);
  
  function new(string name ="my_driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  
  virtual   dut_if dut_if1; // INTERFACE 1  
  
  
  
  virtual function void build_phase (uvm_phase phase);
    $display("my_driver --> BUILD_PHASE");
    if(! uvm_config_db #(virtual dut_if)::get(null,"","dut_if1",dut_if1))  // INTERFACE 2  
    begin
      `uvm_fatal (get_type_name (), "Failed to get the handle to the Virtual Interface named vif"); 
    end 
  endfunction 
  
  
  
  ////////////////////////
  // RUN PHASE 
  ////////////////////////
  virtual task run_phase (uvm_phase phase);
    $display("my_driver --> run_phase ");
  endtask 
  
  
  
  
  
endclass :my_driver 




/////////////////////////////////
// UVM MONITOR    
////////////////////////////////
class my_monitor extends uvm_monitor; 
  
  `uvm_component_utils (my_monitor);
  
  function new (string name ="my_monitor", uvm_component parent =null);
    super.new (name,parent); 
  endfunction
  

  virtual function void build_phase (uvm_phase phase);
    $display("my_monitor --> build_phase");
  endfunction 
  
  
  
endclass 




/////////////////////////////////
// UVM AGENT    
////////////////////////////////
// AGENT encapsulates a Sequencer, Driver, and Monitor into a single entity by
// instantiating and connecting the components together via TLM interfaces. 
class my_agent extends uvm_agent;
  
  `uvm_component_utils (my_agent)
  
  
  function new (string name ="my_agent", uvm_component parent =null);
    super.new (name,parent);
  endfunction
  
// Create Handles to the AGENT Components 
  my_driver                  m_drv0;
  my_monitor                 m_mon0;
  my_sequencer               m_seqr0;  
  
  
  virtual function void build_phase (uvm_phase phase);
    $display("my_agent --> build_phase--> create my_driver--my_monitor");
    m_drv0  = my_driver::type_id::create ("m_drv0",this);
    m_mon0  = my_monitor::type_id::create ("m_mon0",this);
    m_seqr0 = my_sequencer::type_id::create("m_seqr0",this);

  endfunction
  
  
  virtual function void connect_phase (uvm_phase phase);
    $display("my_agent --> connect_phase");    
  endfunction
  

  
  
endclass 







/////////////////////////////////
// UVM SEQUENCE   
////////////////////////////////
class my_sequence extends uvm_sequence;
  // Register with the factory
  // We use uvm_object_utils instead of uvm_component_utils for sequence because sequence is a uvm_transaction object. 
  `uvm_object_utils (my_sequence)
  `uvm_declare_p_sequencer (my_sequencer)
  
  function new (string name="my_sequence");
    super.new (name);
  endfunction
  
  
  task pre_body();
    $display("my_sequence --> pre_body ");
  endtask
  
  
  virtual task body();
    $display("my_sequence --> body ");
  endtask
  
  
  task post_body();
    $display("my_sequence --> post_body ");
  endtask
  
  
endclass 




/////////////////////////////////
// UVM ENVIRONMENT  
////////////////////////////////

class my_env extends uvm_env; 
   // UVM AGENT CREATE 
   // UVM SCOREBOARD CREATE 
  
  `uvm_component_utils (my_env)
  
  
  function new (string name= "my_env", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  my_agent          m_my_agent; // UVM AGENT 1 
  my_scoreboard     m_my_scoreboard;      // UVM SCOREBOARD 1
 
  
  virtual function void build_phase (uvm_phase phase);
    $display("my_env --> BUILD PHASE --> Create my_agent--my_scoreboard"); 
      m_my_agent = my_agent::type_id::create ("m_my_agent",this); // UVM AGENT 2 
      m_my_scoreboard      = my_scoreboard::type_id::create ("m_my_scoreboard",this); // UVM SCOREBOARD 2 
  endfunction 
  
  
endclass 







/////////////////////////////////
// UVM TEST 
////////////////////////////////
  class my_test extends uvm_test;
    // UVM ENVIONMENT CREATE 
    // UVM SEQUENCE CREATE 
    
    `uvm_component_utils(my_test)
    
    my_env m_top_env; //UVM ENVIRONMENT 1 
    
    
    

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    
    
     // BUILD PHASE 
    function void build_phase(uvm_phase phase);
      m_top_env = my_env::type_id::create ("m_top_env",this); // UVM ENVIRONMENT 2
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
      my_sequence m_seq = my_sequence::type_id::create("m_seq"); // UVM SEQUENCE 1  
      
      phase.raise_objection (this);
      // Start the sequence(m_seq) on a given sequencer(seqr) 
      m_seq.start(null); // UVM SEQUENCE 2 
      phase.drop_objection (this);
         
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

  dut_if dut_if1();
 dut udut(.intf (dut_if1) );
  
  
  initial begin
    $display("...module top...");
    uvm_config_db #(virtual dut_if)::set (null,"","dut_if1",dut_if1);
    run_test("my_test");
  end
  
  
endmodule
