// UVM Series 4: UVM example with Driver-Sequencer Connection 

// 


`include "uvm_macros.svh"

//////////////////////////////////////////
// DUT Interface 
//////////////////////////////////////////
interface display_num_intf;
  logic clk;
  int   num;
  
endinterface 


//////////////////////////////////////////
// DUT 
//////////////////////////////////////////
module display_num(display_num_intf intf);
  import uvm_pkg::*;
  
  logic [31:0] count = 32'd0; 
  
  always_ff @(posedge intf.clk)
  begin
    $display("%d: Number:%d",count,intf.num);
    count <= count + 1;
  end 
  
    
endmodule :display_num



package package1;

  import uvm_pkg::*;


//////////////////////////////////////////
// Sequence Item
//////////////////////////////////////////
  class my_seq_item extends uvm_sequence_item;
  
    `uvm_object_utils(my_seq_item)
    // When we decleare a class variable with a rand keyword, we can then use the <class object>.randomize() to randomize the variable.
    // as shown in the "my_sequence" class. 
    // Ref: https://www.chipverify.com/systemverilog/systemverilog-random-variables
    
    rand int num;
    
    // constraint is used to keep the value of the "num" in a certain range
    // Ref:https://www.chipverify.com/systemverilog/systemverilog-constraint-examples
    constraint c_num { num >= 0; num < 256; }
    
    function new (string name = "");
      super.new(name);
      $display("my_seq_item");
    endfunction
    

  endclass: my_seq_item

//////////////////////////////////////////
// Sequence 
//////////////////////////////////////////
class my_sequence extends uvm_sequence #(my_seq_item);
  
    `uvm_object_utils(my_sequence)
    
    function new (string name = "");
      super.new(name);
      $display("my_sequence");   
    endfunction
    
    my_seq_item  my_seq_item0;
  
    task body;
   if (starting_phase != null)
        starting_phase.raise_objection(this);

      repeat(8)
      begin
        my_seq_item0 = my_seq_item::type_id::create("my_seq_item0");
        
        start_item(my_seq_item0);
        
        if( !my_seq_item0.randomize() )
          `uvm_error("", "Randomize failed")

        finish_item(my_seq_item0);
      end
      
      if (starting_phase != null)
        starting_phase.drop_objection(this);
      
    endtask: body
   
  endclass: my_sequence


//////////////////////////////////////////
// Driver 
//////////////////////////////////////////
class my_driver extends uvm_driver #(my_seq_item);
  
    `uvm_component_utils(my_driver)

    virtual display_num_intf intf0;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      $display("...my_driver");
    endfunction
    
    function void build_phase(uvm_phase phase);
      
      if( !uvm_config_db #(virtual display_num_intf)::get(this, "", "display_num_intf", intf0) )
        `uvm_error("", "uvm_config_db::get failed")
    endfunction 
        
   
    task run_phase(uvm_phase phase);
      forever
      begin
        // Driver request a sequence_item from the sequencer using the 
        // get_next_item method through the seq_item_port. 
        // ref: https://www.chipverify.com/uvm/uvm-using-get-next-item
        seq_item_port.get_next_item(req);

        // Driving the DUT pins using the interface. 
        @(posedge intf0.clk);
        intf0.num  = req.num;
        
        // Driver lets the sequencer know that it is finished driving the transaction.
        seq_item_port.item_done();
      end
    endtask

  endclass: my_driver


//////////////////////////////////////////
// Env
//////////////////////////////////////////
  class my_env extends uvm_env;

    `uvm_component_utils(my_env)
    
    uvm_sequencer #(my_seq_item) seqr0;
    my_driver                    driver0;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
      $display("..my_env");
    endfunction
 
    
    function void build_phase(uvm_phase phase);
      // We use the create method to request factory to return a "uvm_sequencer #(my_seq_item)" type of class object. 
      seqr0   = uvm_sequencer #(my_seq_item)::type_id::create("seqr0", this);
      driver0 = my_driver::type_id::create("m_driv", this);
    endfunction

    
    function void connect_phase(uvm_phase phase);
      // Driver class contains a TLM port called "uvm_seq_item_pull_port" which is connected to a 
      // "uvm_seq_item_pull_export" in the sequencer in the connect phase of a UVM agent. 
      // ref:https://www.chipverify.com/uvm/uvm-driver-sequencer-handshake
      driver0.seq_item_port.connect( seqr0.seq_item_export );
    endfunction
    
  endclass: my_env


//////////////////////////////////////////
// Test 
//////////////////////////////////////////
  class my_test extends uvm_test;
  
    `uvm_component_utils(my_test)
    
    my_env env0;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
      $display(".my_test");
    endfunction
    
    function void build_phase(uvm_phase phase);
      env0 = my_env::type_id::create("env0", this);
    endfunction
    
    task run_phase(uvm_phase phase);
      my_sequence seq0;
      seq0 = my_sequence::type_id::create("seq0");
      if( !seq0.randomize() ) 
        `uvm_error("", "Randomize failed")
        
      seq0.starting_phase = phase;
      seq0.start( env0.seqr0 ); 
    endtask
     
  endclass: my_test



endpackage: package1




//////////////////////////////////////////
// Top
//////////////////////////////////////////
module top;

  import uvm_pkg::*;
  import package1::*;
  
  display_num_intf intf0 ();
  display_num      udisplay_num( .intf(intf0) );

    
  // Clock generator
  initial
  begin
    intf0.clk = 0;
    forever #5 intf0.clk = ~intf0.clk;
  end

  initial
  begin
    // We use the "set" statuc function of the class uvm_config_db to
    // set a variable in the configuration database. 
    // uvm_config_db #(T)::set(uvm_component cntxt,
    //                         string        inst_name,
    //                         string        field_name,
    //                         T             value)
    // ref: https://www.chipverify.com/uvm/using-config-db
    // ref: https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.1b/html/files/base/uvm_config_db-svh.html
    uvm_config_db #(virtual display_num_intf)::set(null, "*", "display_num_intf", intf0);
    //=========================================================================================
     // If the "uvm_top.finish_on_completion" is set, then run_test will call $finish after all phases are executed.
    // Ref: https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/base/uvm_root-svh.html
    uvm_top.finish_on_completion = 1;
    $display("top");
    run_test("my_test");
  end

endmodule: top
