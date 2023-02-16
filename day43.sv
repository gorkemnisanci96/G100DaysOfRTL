// UVM Example with APB protocol 
// Includes: 
// Top --> Test --> ENV --> Agent --> Sequencer(seq_item) <-- Connection between sequence and driver.  
//                                --> Driver(seq_item)    --> Drive DUT. 
//                                --> Monitor             <-- Monitor DUT. 
////////////////////////////////////////
// Future Work:  
// Add Squence Item Functions 
// Add a scoreboard for self checks 



`include "uvm_macros.svh"


/////////////////////////////////
// INTERFACE 
/////////////////////////////////
interface apb_intf 
  #(parameter PADDRWIDTH  = 32,
    parameter DATAWIDTH   = 32, 
    parameter SLAVENUMBER = 8 )
   (input logic PCLK);
  
   logic [1:0]                   CMD;
   logic [(PADDRWIDTH-1):0]      CMDADDR;
   logic [(DATAWIDTH-1):0]       CMDDATA;
   logic [$clog2(SLAVENUMBER):0] CMDSLAVENUM;  
   //
   logic                       PRESETn;
   logic                       PPROT; 
   logic [(SLAVENUMBER-1):0]   PSEL;
   logic [(PADDRWIDTH-1):0]    PADDR;
   logic                       PENABLE;
   logic                       PWRITE; 
   logic [(DATAWIDTH-1):0]     PWDATA; 
   logic [(DATAWIDTH/8-1):0]   PSTRB;
   logic                       PREADY; 
   logic [(DATAWIDTH-1):0]     PRDATA;
   logic                       PSLVERR; 
  
  
  
endinterface :apb_intf

/////////////////////////////////////////
//  APB MASTER MODULE 
/////////////////////////////////////////
module apb_master
#(parameter PADDRWIDTH  = 32,
  parameter DATAWIDTH   = 32, 
  parameter SLAVENUMBER = 2 )
(
   //TOP MODULE-APB_MASTER INTERFACE 
   input logic [1:0]                   i_CMD,        // CMD=00 --> NO TRANSFER --CMD=01 --> WRITE TRANSFER--CMD=10 --> READ TRANSFER 
   input logic [(PADDRWIDTH-1):0]      i_CMDADDR,
   input logic [(DATAWIDTH-1):0]       i_CMDDATA,
   input logic [$clog2(SLAVENUMBER):0] i_CMDSLAVENUM, // CHECK IF WE NEED IT.  
   // APB MASTER-APB BRIDGE INTERFACE 
   input logic                      PCLK,
   input logic                      PRESETn,
   //
   output logic                     o_PPROT, 
   //
   output logic [(SLAVENUMBER-1):0] o_PSEL,
   //
   output logic [(PADDRWIDTH-1):0]  o_PADDR,
   //
   output logic                     o_PENABLE,
   output logic                     o_PWRITE, 
   output logic [(DATAWIDTH-1):0]   o_PWDATA, 
   output logic [(DATAWIDTH/8-1):0] o_PSTRB,
   //
   input  logic                     i_PREADY, 
   input  logic [(DATAWIDTH-1):0]   i_PRDATA,
   //
   input  logic                     i_PSLVERR 
    );
  
  
  
  
    
localparam [1:0] S_IDLE   = 2'b00, 
                 S_SETUP  = 2'b01, 
                 S_ACCESS = 2'b10;
//
localparam STROBENUMBER =(DATAWIDTH/8); 

//////////////////////////////////
// Signal Declerations 
//////////////////////////////////
logic [(SLAVENUMBER-1):0] o_PSEL_Next;
logic [(PADDRWIDTH-1):0]  o_PADDR_Next;
logic                     o_PENABLE_Next;
logic                     o_PWRITE_Next; 
logic [(DATAWIDTH-1):0]   o_PWDATA_Next;
logic [(DATAWIDTH/4-1):0] o_PSTRB_Next;
//
logic [1:0] State, State_Next;
   
 
// Protection type. Initialized to Zero    
assign o_PPROT = 0;   
   
   
   
    
    
always_comb 
begin
  State_Next     = State;
  o_PWRITE_Next  = o_PWRITE;  
  o_PADDR_Next   = o_PADDR;
  o_PADDR_Next   = o_PADDR;
  o_PSEL_Next    = o_PSEL;
  o_PENABLE_Next = o_PENABLE;
  o_PSTRB_Next   = o_PSTRB; 
   case(State)
     S_IDLE:
     begin
        o_PWRITE_Next  = 1'b0;
        o_PSEL_Next    = 0;
        o_PENABLE_Next = 1'b0;
        
        if(i_CMD == 2'b01)
        begin
                                             State_Next = S_SETUP;
           o_PWRITE_Next = 1'b1;
           o_PADDR_Next  = i_CMDADDR;
           o_PWDATA_Next = i_CMDDATA;
           o_PSEL_Next[i_CMDSLAVENUM]   = 1'b1;    
           //
           // 
           o_PSTRB_Next = {STROBENUMBER{1'b1}};
    
        end else if(i_CMD == 2'b10)
        begin
                                             State_Next = S_SETUP;
           o_PWRITE_Next = 1'b0;
           o_PADDR_Next  = i_CMDADDR;
           o_PWDATA_Next = i_CMDDATA;
           o_PSEL_Next[i_CMDSLAVENUM]   = 1'b1;  
           //
           // 
           o_PSTRB_Next = 0;                  
        end  
     end 
     S_SETUP: 
     begin
                                             State_Next = S_ACCESS;
     o_PENABLE_Next = 1'b1;
     end 
     S_ACCESS:
     begin
            
          if(i_PREADY == 1'b1)
          begin
                                             State_Next = S_IDLE;
                                             
             o_PENABLE_Next = 1'b0;
             o_PSEL_Next    = 0;
             o_PSTRB_Next   = 0;
             if(i_CMD == 2'b01)
             begin
                                             State_Next = S_SETUP;
                o_PWRITE_Next = 1'b1;
                o_PADDR_Next  = i_CMDADDR;
                o_PWDATA_Next = i_CMDDATA;
                o_PSEL_Next[i_CMDSLAVENUM]   = 1'b1;
                //
                // 
                o_PSTRB_Next = {STROBENUMBER{1'b1}};        
             end else if(i_CMD == 2'b10)
             begin
                                             State_Next = S_SETUP;
                o_PWRITE_Next = 1'b0;
                o_PADDR_Next  = i_CMDADDR;
                o_PWDATA_Next = i_CMDDATA;
                o_PSEL_Next[i_CMDSLAVENUM]   = 1'b1;        
                //
                // 
                o_PSTRB_Next = {STROBENUMBER{1'b0}};            
             end    
          end
     end 
   endcase 
end     
    

////////////////////////////////////////
//  STATE REGISTER 
///////////////////////////////////////
always_ff @(posedge PCLK or negedge PRESETn)
begin
  if(!PRESETn)
  begin
    State <= S_IDLE;
  end else begin
    State <= State_Next;
  end 
end 

////////////////////////////////////////
//  STATE REGISTER 
///////////////////////////////////////   
always_ff @(posedge PCLK or negedge PRESETn)
begin
   if(!PRESETn)
   begin
     o_PSEL     <= 0;
     o_PADDR    <= 0;
     o_PENABLE  <= 0;
     o_PWRITE   <= 0; 
     o_PWDATA   <= 0;
     o_PSTRB    <= 0;    
   end else begin
     o_PSEL     <= o_PSEL_Next;
     o_PADDR    <= o_PADDR_Next;
     o_PENABLE  <= o_PENABLE_Next;
     o_PWRITE   <= o_PWRITE_Next; 
     o_PWDATA   <= o_PWDATA_Next;
     o_PSTRB    <= o_PSTRB_Next;      
   end 
end 

endmodule :apb_master




//////////////////////////////////////
// APB UVM PACKAGE 
//////////////////////////////////////

package apbuvm;

  import uvm_pkg::*;


////////////////////////////////
// SEQUENCE ITEM 
////////////////////////////////
class apb_seq_item_rw extends uvm_sequence_item;
  
  `uvm_object_utils(apb_seq_item_rw)
  
  
  function new(string name="");
     super.new(name);
   endfunction
  
   typedef enum {WRITE_NoWait,WRITE_Wait, READ_NoWait, READ_Wait} op;
   rand bit   [31:0]          addr;      
   rand logic [31:0]          data;    
   rand op                    apb_op;
   rand logic [3:0]           slave_num;
  
endclass :apb_seq_item_rw 


////////////////////////////////
// APB MONITOR 
////////////////////////////////
class apb_monitor extends uvm_monitor;

  virtual apb_intf intf0;

  uvm_analysis_port#(apb_seq_item_rw) monitor_analysis_port;

  `uvm_component_utils(apb_monitor)

   function new(string name, uvm_component parent = null);
     super.new(name, parent);
     monitor_analysis_port = new("monitor_analysis_port", this);
   endfunction: new
   
   ////////////
   // BUILD PHASE
   ///////////
   virtual function void build_phase(uvm_phase phase);
     virtual apb_intf temp_if;
     //
     if (!uvm_config_db#(virtual apb_intf)::get(null, "*", "apb_intf", intf0)) begin
            `uvm_fatal("apb_driver", "Failed to get the handle to the interface")
     end
     //
   endfunction

  
   ////////////
   // MONITOR RUN PHASE 
   ///////////
   virtual task run_phase(uvm_phase phase);
     super.run_phase(phase);
     $display("MONITOR RUN PHASE");
     forever begin
     apb_seq_item_rw monitor_transaction;
       
       @(posedge intf0.PCLK);
          if(intf0.CMD == 2'b01)
          begin
            monitor_transaction = apb_seq_item_rw::type_id::create("monitor_transaction", this);
            $display("MONITORED A WRITE TRANSACTION"); 
             
            
            monitor_analysis_port.write(monitor_transaction); 
          end else if(intf0.CMD == 2'b10)
          begin
            monitor_transaction = apb_seq_item_rw::type_id::create("monitor_transaction", this); 
            $display("MONITORED A READ TRANSACTION");  
             
            
            
            monitor_analysis_port.write(monitor_transaction);   
          end 
     
     end 
       
   endtask: run_phase

endclass: apb_monitor



/////////////////////////////////
// APB DRIVER  
/////////////////////////////////
class apb_driver extends uvm_driver#(apb_seq_item_rw);
  
  `uvm_component_utils(apb_driver)
   
   virtual apb_intf  intf0;
   int transaction_count = 0;

   function new(string name,uvm_component parent = null);
      super.new(name,parent);
     $display("....DRIVER");
   endfunction

  
   ////////
   // DRIVER BUILD PHASE 
   ////////
   function void build_phase(uvm_phase phase);
     // 
     if (!uvm_config_db#(virtual apb_intf)::get(null, "*", "apb_intf", intf0)) begin
            `uvm_fatal("apb_driver", "Failed to get the handle to the interface")
     end
     //
   endfunction


  
   ////////
   // DRIVER RUN PHASE 
   ////////  
   virtual task run_phase(uvm_phase phase);
     super.run_phase(phase);
     
    
    RESET();
    forever begin
       apb_seq_item_rw apb_item;
      
       seq_item_port.get_next_item(apb_item);
       $display("THE TRANSACTION %d",transaction_count);
       
       case(apb_item.apb_op)
         apb_seq_item_rw::WRITE_NoWait : begin $display("--WRITE with No Wait--");   WRITE_NoWait(.addr(apb_item.addr), .data(apb_item.data),.slavenum(apb_item.slave_num));    end  
         apb_seq_item_rw::WRITE_Wait   : begin $display("--WRITE with Wait--");      WRITE_Wait(  .addr(apb_item.addr), .data(apb_item.data),.slavenum(apb_item.slave_num));    end
         apb_seq_item_rw::READ_NoWait  : begin $display("--READ  with No Wait--");   READ_NoWait( .addr(apb_item.addr),                      .slavenum(apb_item.slave_num));    end  
         apb_seq_item_rw::READ_Wait    : begin $display("--READ  with Wait--");      READ_Wait(   .addr(apb_item.addr),                      .slavenum(apb_item.slave_num));    end
       endcase
      
      
       seq_item_port.item_done();
       transaction_count++;
     end
     
   endtask: run_phase

  
  
  //////////
  //  WRITE WITH NO WAIT STATE 
  //////////
   virtual protected task WRITE_NoWait(input  logic [31:0] addr,
                                       input  logic [31:0] data,
                                       input  logic        slavenum);
      intf0.PREADY = 1'b0;
     @(posedge intf0.PCLK);
      intf0.CMD         <= 2'b01;
      intf0.CMDADDR     <= addr;   
      intf0.CMDDATA     <= data; 
      intf0.CMDSLAVENUM <= slavenum;     
     @(posedge intf0.PCLK);
      intf0.CMD         <= 2'b00;
     repeat(1)@(posedge intf0.PCLK);  
      intf0.PREADY = 1'b1;          // PREADY signal is the response of the slave module to the APB Master. 
     @(posedge intf0.PCLK);  
      intf0.PREADY = 1'b0;      
     
   endtask :WRITE_NoWait
  

    
  //////////
  //  WRITE WITH WAIT STATE 
  ////////// 
  virtual protected task WRITE_Wait(   input  logic [31:0] addr,
                                       input  logic [31:0] data,
                                       input  logic        slavenum);
      intf0.PREADY = 1'b0;
     @(posedge intf0.PCLK);
      intf0.CMD         <= 2'b01;
      intf0.CMDADDR     <= addr;   
      intf0.CMDDATA     <= data; 
      intf0.CMDSLAVENUM <= slavenum;     
     @(posedge intf0.PCLK);
      intf0.CMD         <= 2'b00;
     repeat(3)@(posedge intf0.PCLK);  
      intf0.PREADY = 1'b1; // PREADY signal is the response of the slave module to the APB Master. 
     @(posedge intf0.PCLK);  
      intf0.PREADY = 1'b0;      
     
   endtask :WRITE_Wait  
  
  
  
  //////////
  //  READ WITH NO WAIT STATE 
  //////////   
  virtual protected task READ_NoWait(  input  logic [31:0] addr,
                                       input  logic        slavenum);
      intf0.PREADY = 1'b0;
     @(posedge intf0.PCLK);
      intf0.CMD         <= 2'b10;
      intf0.CMDADDR     <= addr;   
      intf0.CMDSLAVENUM <= slavenum;     
     @(posedge intf0.PCLK);
      intf0.CMD         <= 2'b00;
     repeat(1)@(posedge intf0.PCLK);
      intf0.PRDATA = 32'hdead_cafe; // PRDATA signal is the response of the slave module to the APB Master. 
      intf0.PREADY = 1'b1;          // PREADY signal is the response of the slave module to the APB Master. 
     @(posedge intf0.PCLK);  
      intf0.PREADY = 1'b0;      
     
   endtask :READ_NoWait   
  
  
  
  //////////
  //  READ WITH WAIT STATE 
  //////////   
  virtual protected task READ_Wait(    input  logic [31:0] addr,
                                       input  logic        slavenum);
      intf0.PREADY = 1'b0;
     @(posedge intf0.PCLK);
      intf0.CMD         <= 2'b10;
      intf0.CMDADDR     <= addr;   
      intf0.CMDSLAVENUM <= slavenum;     
     @(posedge intf0.PCLK);
      intf0.CMD         <= 2'b00;
    repeat(3)@(posedge intf0.PCLK);
      intf0.PRDATA = 32'hdead_cafe; // PRDATA signal is the response of the slave module to the APB Master. 
      intf0.PREADY = 1'b1;          // PREADY signal is the response of the slave module to the APB Master. 
     @(posedge intf0.PCLK);  
      intf0.PREADY = 1'b0;      
     
   endtask :READ_Wait   
    
  //////////
  //  RESET
  //////////   
  virtual protected task RESET();
      intf0.PRESETn = 1'b1;
      @(posedge intf0.PCLK);
      intf0.PRESETn = 1'b0;
      repeat(2)@(posedge intf0.PCLK);
      intf0.PRESETn = 1'b1;
      repeat(5)@(posedge intf0.PCLK);
   endtask :RESET  
    
  
endclass :apb_driver



/////////////////////////////////
// APB AGENT   
/////////////////////////////////
class apb_agent extends uvm_agent;
  
   uvm_sequencer #(apb_seq_item_rw) sqr0;
   apb_driver                       drv0;
   apb_monitor                      mon0;

   virtual apb_intf  intf0;

  
   `uvm_component_utils_begin(apb_agent)
       `uvm_field_object(sqr0, UVM_ALL_ON)
       `uvm_field_object(drv0, UVM_ALL_ON)
       `uvm_field_object(mon0, UVM_ALL_ON)
   `uvm_component_utils_end
  

   function new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction

  
   //////////
   // AGENT BUILD PHASE 
   //////////  
   virtual function void build_phase(uvm_phase phase);
     
      sqr0   = uvm_sequencer #(apb_seq_item_rw)::type_id::create("sqr0", this);
      drv0   = apb_driver::type_id::create("drv0", this);
      mon0   = apb_monitor::type_id::create("mon0", this);
      
      if (!uvm_config_db#(virtual apb_intf)::get(null, "*", "apb_intf", intf0)) begin
             `uvm_fatal("apb_agent", "Failed to get the handle to the interface")
      end
     
   endfunction: build_phase

  
  
   //////////
   // AGENT CONNECT PHASE 
   //////////  
   virtual function void connect_phase(uvm_phase phase);
     drv0.seq_item_port.connect(sqr0.seq_item_export);
     uvm_report_info("apb_agent:", "connect_phase, Driver is Connected to the sequencer");
   endfunction
  
  
endclass: apb_agent



/////////////////////////////////
// APB BASE SEQUENCE 
/////////////////////////////////
class apb_seq_base extends uvm_sequence#(apb_seq_item_rw);
  
  `uvm_object_utils(apb_seq_base)
  
  
  function new(string name="");
    super.new(name);
    $display("...SEQ");
  endfunction
  
  
  task body();
    apb_seq_item_rw apb_item;
    
    repeat(10) begin
       apb_item = apb_seq_item_rw::type_id::create(.name("apb_item"),.contxt(get_full_name()));
       start_item(apb_item);
       assert (apb_item.randomize());
       finish_item(apb_item);
     end
    
  endtask
  

endclass :apb_seq_base




/////////////////////////////////
// APB ENV 
/////////////////////////////////
class apb_env  extends uvm_env;
 
   `uvm_component_utils(apb_env);

   apb_agent         agt0;
   virtual apb_intf  intf0;

   function new(string name, uvm_component parent = null);
      super.new(name, parent);
      $display("...ENV");
   endfunction

  
   function void build_phase(uvm_phase phase);
     agt0 = apb_agent::type_id::create("agt0", this);
     
     if (!uvm_config_db#(virtual apb_intf)::get(null, "*", "apb_intf", intf0)) begin
       `uvm_fatal("apb_env", "Failed to get the handle to the interface")
     end
     
   endfunction: build_phase
  
  
endclass : apb_env  


/////////////////////////////////
// TEST
/////////////////////////////////
class apb_test extends uvm_test;
  
  `uvm_component_utils(apb_test)
  
  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
  apb_env  env0;
  virtual  apb_intf intf0;
  
  
  
  
  
  //////////
  // BUILD_PHASE 
  //////////
  function void build_phase(uvm_phase phase);
    $display(".BUILD_PHASE");
    
    env0 = apb_env::type_id::create("env0", this);
    
    
    // Get the handle to the interface 
    if (!uvm_config_db#(virtual apb_intf)::get(null, "*", "apb_intf", intf0)) begin
      `uvm_fatal("apb_test:build_phase", "Failed to get the handle to the interface")
    end 

  endfunction
  
  //////////
  // RUN_PHASE 
  //////////  
  task run_phase (uvm_phase phase);
    apb_seq_base apb_seq;
    apb_seq = apb_seq_base::type_id::create("apb_seq");
    
    
    phase.raise_objection( this, "Starting APB BASE SEQUENCE" );
    $display("%t Starting sequence apb_seq run_phase",$time);
    apb_seq.start(env0.agt0.sqr0);
    #100ns;
    phase.drop_objection( this , "Finished APB BASE SEQUENCE" );
  endtask 
  
  
  
endclass :apb_test  



endpackage 






//////////////////////////////////////////
// Top
//////////////////////////////////////////
module top;

  import uvm_pkg::*;
  import apbuvm::*;
  
  parameter PADDRWIDTH  = 32;
  parameter DATAWIDTH   = 32; 
  parameter SLAVENUMBER = 8; 
  
  logic clk;
  
  // Clock Generation 
  initial begin
   clk = 1'b0;
   forever #10 clk = ~clk;
  end 
  
  
  apb_intf #(.PADDRWIDTH (PADDRWIDTH), .DATAWIDTH (DATAWIDTH), .SLAVENUMBER (SLAVENUMBER))       intf0 (.PCLK(clk));
 
  ////////
  // APB MASTER 
  ////////
  apb_master
    #(.PADDRWIDTH  (PADDRWIDTH),
      .DATAWIDTH   (DATAWIDTH), 
      .SLAVENUMBER (SLAVENUMBER))
  uapb_master
(
   //TOP MODULE-APB_MASTER INTERFACE 
   .i_CMD         (intf0.CMD),      
   .i_CMDADDR     (intf0.CMDADDR),
   .i_CMDDATA     (intf0.CMDDATA),
   .i_CMDSLAVENUM (intf0.CMDSLAVENUM), 
    // 
   .PCLK          (intf0.PCLK), 
   .PRESETn       (intf0.PRESETn), 
   //
   .o_PPROT       (intf0.PPROT), 
   //
   .o_PSEL        (intf0.PSEL), 
   //
   .o_PADDR       (intf0.PADDR),
   //
   .o_PENABLE     (intf0.PENABLE),
   .o_PWRITE      (intf0.PWRITE),
   .o_PWDATA      (intf0.PWDATA), 
   .o_PSTRB       (intf0.PSTRB),
   //
   .i_PREADY      (intf0.PREADY), 
   .i_PRDATA      (intf0.PRDATA),
   //
   .i_PSLVERR     (intf0.PSLVERR) 
    );
  
  
  
  initial
  begin
    uvm_config_db #(virtual apb_intf)::set(null, "*", "apb_intf", intf0);
    uvm_top.finish_on_completion = 1;
    $display("TOP");
    run_test("apb_test");
  end


  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1); 
  end 
  
  
endmodule: top
