// UVM Series 3: Simple UVM example with uvm_test,uvm_env,uvm_drive, and interface  


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


////////////////////////////////
// UVM DRIVER 
///////////////////////////////
class display_num_driver extends uvm_driver;
  `uvm_component_utils (display_num_driver)
  
  virtual display_num_intf  intf0;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction 
  

  function void build_phase(uvm_phase phase);
    
    $display("...UVM_DRIVER"); 
    uvm_config_db #(virtual display_num_intf)::get(null, "*", "display_num_intf", intf0); 
  endfunction 
  
  
  task run_phase(uvm_phase phase);
   forever begin
    @(posedge intf0.clk);
    intf0.num <= $random;
   end 
  endtask 
  
  
  
endclass :display_num_driver





////////////////////////////////
// UVM ENVIRONMENT 
///////////////////////////////
class display_num_env extends uvm_env; 
  `uvm_component_utils(display_num_env)
  
  display_num_driver driver0;
  
  
  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  
  function void build_phase(uvm_phase phase);
    $display("..UVM_ENV"); 
    driver0 = display_num_driver::type_id::create("driver0",this);
  endfunction 
  
  
endclass 



////////////////////////////////
// UVM TEST 
///////////////////////////////
class display_num_test extends uvm_test;
  
  `uvm_component_utils(display_num_test)
  
  
  display_num_env env0;
  
  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    $display(".UVM_TEST");    
    env0 = display_num_env::type_id::create("env0", this);
  endfunction
  
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #200;
    phase.drop_objection(this);
  endtask :run_phase 
  
 
endclass :display_num_test 



endpackage :package1





module top;
  
  
import uvm_pkg::*; 
import package1::*; 

  display_num_intf  intf0();
  display_num       udisplay_num(.intf (intf0)); 
  
  ////////////////////////
  // Clock Generation 
  ////////////////////////
  initial intf0.clk = 1'b0;
  always #10 intf0.clk = ~intf0.clk; 

  
  
  
  initial begin
    $display("UVM_TOP");
    uvm_config_db #(virtual display_num_intf)::set(null, "*", "display_num_intf", intf0);
    run_test("display_num_test");
  end 
  
  
  
  
endmodule :top 
