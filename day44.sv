// run.do for Coverage Report 
//vsim +access+r;
//run -all;
//acdb save;
//acdb report -db fcover.acdb -txt -o cov.txt;
//exit
//
// UVM Example with ALU 
// 1- module ALU_I 
//  This module implements the RISC-V 32-bit integer(I) ALU instructions. 
// 2- dut_intf 
//  This is an interface that reflects the ALU_I module signals. 
// 3- dut_seq_item 
//  This is an uvm_sequence_item class.
//  This class is used to send signal information between the uvm classes. 
//  The sequence create a sequence_item, randomize and send it to the driver. 
// 4-dut_driver 
//  Driver gets handle to the "dut_intf" and waits for the dut_sequence the send the sequence_item.
//  it receives the sequence item and drives the interface signals, which are connected to DUT signals. 
// 5- top 
//  a- Generate the clock 
//  b- Instantiate the DUT 
//  c- Create an interface object. 
//  d- Save the interface object handle to the uvm_config_db using set() function 
//  e- call the "run_test" function with the uvm_test name. 
// 6- The dut_test is the uvm_test class for user-defined test 
//  a- Create an interface object. 
//  b- Get the handle to the interface from the uvm_config_db using the get() function 
//  c- Create an uvm_environment class object. 
//  d- Start the sequence with a specified sequencer using dut_seq.start(sequencer object). 
//  e- raise and drop the objection to tell the simulation when to stop. 
// 7- dut_sequence 
//   a- The sequence create a sequence_item, randomize and send it to the driver.
// 8- dut_monitor
//   uvm monitor is responsible for capturing signal activity from the design interface and translate it into the transaction level 
//   data objects that can be sent to the other components. 
//   a- Gets the handle to the DUT interface from the uvm_config_db 
//   b- Read the values from the interface and translate them to the transaction level data objects.    
//   c- Creates an uvm_analysis_port to broadcast the trabsaction level data object to all the subscribers that implements the uvm_analysis_imp. 
//   d- calls the "AnalysisPort.write" to send the transaction object to all the subscribers. 
// 9- dut_agent
//   a- Creates sequencer object 
//   b- Creates Driver Object 
//   c- Creates Monitor Object 
//   d- Creates Scoreboard Object 
//   e- Gets handle to the DUT interface
//   f- Connect driver seq_item_port to the sequencer seq_item_export  (drv0.seq_item_port.connect(sqr0.seq_item_export) 
//   g- Connect the Monitor AnalysisPort of the scoreboard analysis_export 
// 10- dut_scoreboard 
//   a- It extends the uvm_subscriber class so it has an analysis_export 
//   b- The analysis_export is connected to the analysis_port of the monitor in the dut_agent class 
//   c- it receives the transaction object from the monitor
//   d- Calculates the expected result in a reference design and compares the expected result with the calculated result.
//   e- Keeps track of the errors and reports the number of errors
// 11- dut_coverage 
//  a- Extends the uvm_subscriber class 
//  b- It is connected to the monitor port in the dut_env class using "agt0.mon0.AnalysisPort.connect(cov0.analysis_export); "
//  c- It performs the following coverage checks for the ALU. 
//    c.1- ALl ALU operations are performed. 
//    c.2- The Num1 takes all zero and all one operations 
//    c.3- The Num2 takes all zero and all one operations 
//  d- It samples the values in the write function. 





`include "uvm_macros.svh"


`define FUNCT3_ADDI   3'b000
`define FUNCT3_SLTI   3'b010
`define FUNCT3_SLTIU  3'b011
`define FUNCT3_XORI   3'b100
`define FUNCT3_ORI    3'b110
`define FUNCT3_ANDI   3'b111
`define FUNCT3_SLLI   3'b001
`define FUNCT3_SRLI   3'b101
`define FUNCT3_SRAI   3'b101
`define FUNCT3_ADD    3'b000
`define FUNCT3_SUB    3'b000
`define FUNCT3_SLL    3'b001
`define FUNCT3_SLT    3'b010
`define FUNCT3_SLTU   3'b011
`define FUNCT3_XOR    3'b100
`define FUNCT3_SRL    3'b101
`define FUNCT3_SRA    3'b101
`define FUNCT3_OR     3'b110
`define FUNCT3_AND    3'b111




                            // ALU OPERATION SELECT SIGNALS 
                            //   FUNC7[5],    FUNC3    ,OPCODE[5]
  typedef enum logic [4:0] {ADDI   ={1'b0,`FUNCT3_ADDI ,1'b0},
                            SLTI   ={1'b0,`FUNCT3_SLTI ,1'b0},
                            SLTIU  ={1'b0,`FUNCT3_SLTIU,1'b0},
                            XORI   ={1'b0,`FUNCT3_XORI ,1'b0},
                            ORI    ={1'b0,`FUNCT3_ORI  ,1'b0},
                            ANDI   ={1'b0,`FUNCT3_ANDI ,1'b0},
                            SLLI   ={1'b0,`FUNCT3_SLLI ,1'b0},
                            SRLI   ={1'b0,`FUNCT3_SRLI ,1'b0},
                            SRAI   ={1'b1,`FUNCT3_SRAI ,1'b0},
                            ADD    ={1'b0,`FUNCT3_ADD  ,1'b1},
                            SUB    ={1'b1,`FUNCT3_SUB  ,1'b1},
                            SLL    ={1'b0,`FUNCT3_SLL  ,1'b1},
                            SLT    ={1'b0,`FUNCT3_SLT  ,1'b1},
                            SLTU   ={1'b0,`FUNCT3_SLTU ,1'b1},
                            XORop  ={1'b0,`FUNCT3_XOR  ,1'b1},
                            SRL    ={1'b0,`FUNCT3_SRL  ,1'b1},
                            SRA    ={1'b1,`FUNCT3_SRA  ,1'b1},
                            ORop   ={1'b0,`FUNCT3_OR   ,1'b1},
                            ANDop  ={1'b0,`FUNCT3_AND  ,1'b1}
                            } OpSelType; 





/////////////////////////////////
// INTERFACE 
/////////////////////////////////
interface dut_intf (input logic clk);
    logic [31:0] Num1;
    logic [31:0] Num2; 
    OpSelType    OpSel; 
    logic [31:0] Result;
  
  
endinterface :dut_intf



///////////////////////////////
// DUT 
///////////////////////////////
module ALU_I
  (
    input  logic [31:0] Num1,
    input  logic [31:0] Num2, 
    input  logic [4:0]  OpSel, 
    output logic [31:0] Result
  );
  
  logic [31:0] add_result;
  logic        add_or_sub;
  logic [31:0] add_op2;
  logic        sltu_result;
  
  // ADD, ADDI, SUB Operations 
  assign add_or_sub = OpSel[4] & OpSel[0]; // 1:SUB 0:ADD
  assign add_op2    = ( ({32{add_or_sub}}^Num2)+add_or_sub);
  assign add_result = Num1 + add_op2;  
  
  // SLT 
  assign sltu_result = Num1 < Num2; 
 
 always_comb
  begin
    case(OpSel[3:1])
     `FUNCT3_ADD : Result = add_result; 
     `FUNCT3_SRL : Result = OpSel[4] ? (Num1 >> Num2[4:0]) : (Num1 >>> Num2[4:0]);
     `FUNCT3_OR  : Result = Num1 | Num2;
     `FUNCT3_AND : Result = Num1 & Num2;           
     `FUNCT3_XOR : Result = Num1 ^ Num2;
     `FUNCT3_SLT : Result = (Num1[31] ^ Num2[31]) ? Num1[31] : sltu_result;
     `FUNCT3_SLTU: Result = sltu_result;
     `FUNCT3_SLL : Result = Num1 << Num2[4:0];
    endcase 
  end 
 

endmodule :ALU_I





//////////////////////////////////////
// DUT UVM PACKAGE 
//////////////////////////////////////

package dutuvm;

  import uvm_pkg::*;


////////////////////////////////
// SEQUENCE ITEM 
////////////////////////////////
class dut_seq_item extends uvm_sequence_item;
  
  `uvm_object_utils(dut_seq_item)
  
  
  function new(string name="");
     super.new(name);
   endfunction
  
  rand logic [31:0] Num1;  
  rand logic [31:0] Num2; 
       logic [31:0] Result;
  rand OpSelType OpSel;
    
  
  
   function string convert2string();
     $display("%0h %s %0h = %0h ",Num1,OpcodeToString(OpSel),Num2,Result);
   endfunction
  
  function string OpcodeToString(OpSelType OpSel);
    
    case(OpSel)
      ADDI:    return $psprintf("ADDI");
      SLTI:    return $psprintf("SLTI");
      SLTIU:   return $psprintf("SLTIU");
      XORI:    return $psprintf("XORI");
      ORI:     return $psprintf("ORI");
      ANDI:    return $psprintf("ANDI");
      SLLI:    return $psprintf("SLLI");
      SRLI:    return $psprintf("SRLI");
      SRAI:    return $psprintf("SRAI");
      ADD:     return $psprintf("ADD");
      SUB:     return $psprintf("SUB");
      SLL:     return $psprintf("SLL");
      SLT:     return $psprintf("SLT");
      SLTU:    return $psprintf("SLTU");
      XORop:   return $psprintf("XOR");
      SRL:     return $psprintf("SRL");
      SRA:     return $psprintf("SRA");
      ORop:    return $psprintf("OR");
      ANDop:   return $psprintf("AND");    
      default: return $psprintf("UNKNOWN OP");
    endcase 
    
    
  endfunction :OpcodeToString
   
endclass :dut_seq_item 



////////////////////////////////
// COVERAGE CLASS 
////////////////////////////////
class dut_coverage extends uvm_subscriber #(dut_seq_item);
 `uvm_component_utils(dut_coverage)


  logic [31:0] Num1;
  logic [31:0] Num2;
  OpSelType    Op;

  
  covergroup OperationCoverage;
    
    coverpoint Op {
      bins all_opp [] = {SLTI,SLTIU,XORI,ORI,ANDI ,SLLI ,SRLI ,SRAI,ADD,SUB,SLL,SLT,SLTU,XORop,SRL,SRA,ORop,ANDop};
    }
  endgroup 
  
  
    covergroup NumsCoverage;
      
      coverpoint Num1 {
        bins zeros = {32'h0};
        bins ones  = {32'hFFFFFFFF};
      }
      
      coverpoint Num2 {
        bins zeros = {32'h0};
        bins ones  = {32'hFFFFFFFF};
      }
      
    endgroup

 
  
  
   function new (string name, uvm_component parent);
      super.new(name, parent);
      OperationCoverage = new();
      NumsCoverage = new();
   endfunction : new

  
  
  
  function void write (dut_seq_item t);
         $display("Sampling...");
         Num1 = t.Num1;
         Num2 = t.Num2;
         Op   = t.OpSel;
         OperationCoverage.sample();
         NumsCoverage.sample();
  endfunction

endclass :dut_coverage

////////////////////////////////
// DUT SCOREBOARD 
////////////////////////////////
class dut_scoreboard extends uvm_subscriber #(dut_seq_item);
  
  `uvm_component_utils(dut_scoreboard)
  
   int ERROR_COUNT = 0;
  
  
  function new (string name = "dut_scoreboard", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  

  function void write (dut_seq_item t); 
    if(t.Result != PredictResult(t) ) begin  ERROR_COUNT++; $display("ERROR: RESULT MISMATCH. Expected: %0h Calculated: %0h",PredictResult(t),t.Result); end 
    else begin  $display("SCOREBOARD Check. Correct Result. Expected: %0h == Calculated: %0h",PredictResult(t),t.Result);  end 
    
  endfunction
  
  
  
  
  
  function logic [31:0] PredictResult(dut_seq_item t);   
    
    case(t.OpSel)
      ADDI:     begin  PredictResult = (t.Num1 + t.Num2);                                                end      
      SLTI:     begin  PredictResult = ($signed(t.Num1) < $signed(t.Num2) ) ?  {31'b0,1'b1}  : 32'h0  ;  end     
      SLTIU:    begin  PredictResult = (t.Num1 < t.Num2) ?  {31'b0,1'b1}  : 32'h0  ;                     end 
      XORI:     begin  PredictResult = (t.Num1 ^ t.Num2);                                                end     
      ORI:      begin  PredictResult = (t.Num1 | t.Num2);                                                end        
      ANDI:     begin  PredictResult = (t.Num1 & t.Num2);                                                end        
      SLLI:     begin  PredictResult = (t.Num1 << t.Num2[4:0]);                                          end        
      SRLI:     begin  PredictResult = (t.Num1 >> t.Num2[4:0]);                                          end        
      SRAI:     begin  PredictResult = (t.Num1 >>> t.Num2[4:0]);                                         end       
      ADD:      begin  PredictResult = (t.Num1 + t.Num2);                                                end   
      SUB:      begin  PredictResult = (t.Num1 - t.Num2);                                                end   
      SLL:      begin  PredictResult = (t.Num1 << t.Num2[4:0]);                                          end           
      SLT:      begin  PredictResult = ($signed(t.Num1) < $signed(t.Num2) ) ?  {31'b0,1'b1}  : 32'h0  ;  end                           SLTU:     begin  PredictResult = (t.Num1 < t.Num2) ?  {31'b0,1'b1}  : 32'h0  ;                     end    
      XORop:    begin  PredictResult = (t.Num1 ^ t.Num2);                                                end      
      SRL:      begin  PredictResult = (t.Num1 >> t.Num2[4:0]);                                          end     
      SRA:      begin  PredictResult = (t.Num1 >>> t.Num2[4:0]);                                         end    
      ORop:     begin  PredictResult = (t.Num1 | t.Num2);                                                end      
      ANDop:    begin  PredictResult = (t.Num1 & t.Num2);                                                end     
      default:  begin  PredictResult = 32'b0;                                                            end     
    endcase 
    
    
  endfunction :PredictResult
  
  
  
  virtual function void report_phase(uvm_phase phase);
   super.report_phase(phase);
   $display("THE ERROR COUNT= %d  ",ERROR_COUNT); 
   
  endfunction : report_phase 
  
  
  
endclass :dut_scoreboard  



////////////////////////////////
// DUT MONITOR 
////////////////////////////////
class dut_monitor extends uvm_monitor;

  virtual dut_intf intf0;

  uvm_analysis_port#(dut_seq_item) AnalysisPort;

  `uvm_component_utils(dut_monitor)

   function new(string name, uvm_component parent = null);
     super.new(name, parent);
   endfunction: new
   
   ////////////
   // BUILD PHASE
   ///////////
   virtual function void build_phase(uvm_phase phase);
     //
     if (!uvm_config_db#(virtual dut_intf)::get(null, "*", "dut_intf", intf0)) begin
       `uvm_fatal("dut_driver", "Failed to get the handle to the interface")
     end
     //
     AnalysisPort = new("monitor_analysis_port", this);
   endfunction

  
   ////////////
   // MONITOR RUN PHASE 
   ///////////
   virtual task run_phase(uvm_phase phase);
     super.run_phase(phase);
     
     forever begin
       dut_seq_item AluTrObject = dut_seq_item::type_id::create("AluTrObject",this); 
       
       @(posedge intf0.clk);
       AluTrObject.Num1   = intf0.Num1;
       AluTrObject.Num2   = intf0.Num2;
       AluTrObject.OpSel  = intf0.OpSel;
       AluTrObject.Result = intf0.Result;
       $write("MONITOR: ");
       AluTrObject.convert2string();
       
       AnalysisPort.write(AluTrObject);
     end 
     
     
     
   endtask: run_phase

endclass: dut_monitor



/////////////////////////////////
// DUTDRIVER  
/////////////////////////////////
class dut_driver extends uvm_driver#(dut_seq_item);
  
  `uvm_component_utils(dut_driver)
   
   virtual dut_intf  intf0;
   int transaction_count = 0;

   function new(string name,uvm_component parent = null);
      super.new(name,parent);
      $display("....DRIVER");
   endfunction

  
   ////////
   // DRIVER BUILD PHASE 
   ////////
   function void build_phase(uvm_phase phase);
     //  Get handle to the DUT INTERFACE. 
     if (!uvm_config_db#(virtual dut_intf)::get(null, "*", "dut_intf", intf0)) begin
       `uvm_fatal("dut_driver", "Failed to get the handle to the interface")
     end
     //
   endfunction


  
   ////////
   // DRIVER RUN PHASE 
   ////////  
   virtual task run_phase(uvm_phase phase);
     super.run_phase(phase);
     
    forever begin
        dut_seq_item dut_item;
      
      seq_item_port.get_next_item(dut_item); // Get the sequence item 
        $display("DRIVE THE TRANSACTION %d",transaction_count);
        /////////////////////////////////////////////////////////// 
        // DRIVE THE INTERFACE SIGNALS HERE 
        /////////////////////////////////////////////////////////// 
        @(posedge intf0.clk);
        intf0.Num1   =dut_item.Num1;
        intf0.Num2   =dut_item.Num2; 
        intf0.OpSel  =dut_item.OpSel; 
        
        /////////////////////////////////////////////////////////// 
        ///////////////////////////////////////////////////////////      
        seq_item_port.item_done();
      
        transaction_count++;
     end
     
   endtask: run_phase

  
    
  
endclass :dut_driver



/////////////////////////////////
// DUTAGENT   
/////////////////////////////////
class dut_agent extends uvm_agent;
  
   uvm_sequencer #(dut_seq_item)    sqr0;
   dut_driver                       drv0;
   dut_monitor                      mon0;
   dut_scoreboard                   scrbrd0; 
  
  
  
   virtual dut_intf  intf0;

  
  `uvm_component_utils_begin(dut_agent)
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
     
      sqr0     = uvm_sequencer #(dut_seq_item)::type_id::create("sqr0", this);
      drv0     = dut_driver::type_id::create("drv0", this);
      mon0     = dut_monitor::type_id::create("mon0", this);
      scrbrd0  = dut_scoreboard::type_id::create("scrbrd0",this);
     
     
     
      
     if (!uvm_config_db#(virtual dut_intf)::get(null, "*", "dut_intf", intf0)) begin
       `uvm_fatal("dut_agent", "Failed to get the handle to the interface")
      end
     
   endfunction: build_phase

  
  
   //////////
   // AGENT CONNECT PHASE 
   //////////  
   virtual function void connect_phase(uvm_phase phase);
     drv0.seq_item_port.connect(sqr0.seq_item_export);
     uvm_report_info("dut_agent:", "connect_phase, Driver is Connected to the sequencer");
     mon0.AnalysisPort.connect(scrbrd0.analysis_export);
    
   endfunction
  
  
endclass: dut_agent



/////////////////////////////////
// DUT BASE SEQUENCE 
/////////////////////////////////
class dut_seq_base extends uvm_sequence#(dut_seq_item);
  
  `uvm_object_utils(dut_seq_base)
  
  
  function new(string name="");
    super.new(name);
    $display("...SEQ");
  endfunction
  
  
  task body();
    dut_seq_item dut_item;  
        
    
       ////////////////////////////
       // SET THE EDGE CASES FOR THE COVERAGE 
       /////////////////////////// 
       dut_item = dut_seq_item::type_id::create(.name("dut_item"),.contxt(get_full_name()));
       start_item(dut_item);
       assert (dut_item.randomize());
       dut_item.Num1 = 32'h0;
       dut_item.Num2 = 32'h0;
       finish_item(dut_item);
       //
       dut_item = dut_seq_item::type_id::create(.name("dut_item"),.contxt(get_full_name()));
       start_item(dut_item);
       assert (dut_item.randomize());
       dut_item.Num1 = 32'hFFFFFFFF;
       dut_item.Num2 = 32'hFFFFFFFF;
       finish_item(dut_item);    
       //
       dut_item = dut_seq_item::type_id::create(.name("dut_item"),.contxt(get_full_name()));
       start_item(dut_item);
       assert (dut_item.randomize());
       dut_item.Num1 = 32'h0;
       dut_item.Num2 = 32'hFFFFFFFF;
       finish_item(dut_item);       
       //
       dut_item = dut_seq_item::type_id::create(.name("dut_item"),.contxt(get_full_name()));
       start_item(dut_item);
       assert (dut_item.randomize());
       dut_item.Num1 = 32'hFFFFFFFF;
       dut_item.Num2 = 32'h0;
       finish_item(dut_item);  
       //
       dut_item = dut_seq_item::type_id::create(.name("dut_item"),.contxt(get_full_name()));
       start_item(dut_item);
       assert (dut_item.randomize());
       dut_item.Num1 = 32'hFFFFFFFF;
       dut_item.Num2 = 32'h0;
       dut_item.OpSel = SUB;
       finish_item(dut_item);      
    
    repeat(100) begin
       dut_item = dut_seq_item::type_id::create(.name("dut_item"),.contxt(get_full_name()));
       start_item(dut_item);
       assert (dut_item.randomize());
       finish_item(dut_item);
     end
    
  endtask
  

endclass :dut_seq_base




/////////////////////////////////
// DUT ENV 
/////////////////////////////////
class dut_env  extends uvm_env;
 
   `uvm_component_utils(dut_env);

   dut_agent         agt0;
   dut_coverage      cov0;
  
   virtual dut_intf  intf0;

   function new(string name, uvm_component parent = null);
      super.new(name, parent);
      $display("...ENV");
   endfunction

  
   function void build_phase(uvm_phase phase);
     agt0 = dut_agent::type_id::create("agt0", this);
     cov0 = dut_coverage::type_id::create("cov0", this);
     
     if (!uvm_config_db#(virtual dut_intf)::get(null, "*", "dut_intf", intf0)) begin
       `uvm_fatal("dut_env", "Failed to get the handle to the interface")
     end
     
   endfunction: build_phase
  
  
   //////////
   // ENV CONNECT PHASE 
   //////////  
   virtual function void connect_phase(uvm_phase phase);
     agt0.mon0.AnalysisPort.connect(cov0.analysis_export);  
   endfunction 
     
  
endclass : dut_env  


/////////////////////////////////
// TEST
/////////////////////////////////
class dut_test extends uvm_test;
  
  `uvm_component_utils(dut_test)
  
  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
  dut_env  env0;
  virtual  dut_intf intf0;
  
  
  
  
  
  //////////
  // BUILD_PHASE 
  //////////
  function void build_phase(uvm_phase phase);
    $display(".BUILD_PHASE");
    
    env0 = dut_env::type_id::create("env0", this);
    
    
    // Get the handle to the interface 
    if (!uvm_config_db#(virtual dut_intf)::get(null, "*", "dut_intf", intf0)) begin
      `uvm_fatal("dut_test:build_phase", "Failed to get the handle to the interface")
    end 

  endfunction
  
  //////////
  // RUN_PHASE 
  //////////  
  task run_phase (uvm_phase phase);
    dut_seq_base dut_seq;
    dut_seq =    dut_seq_base::type_id::create("dut_seq");
    //
    phase.raise_objection( this, "Starting DUT BASE SEQUENCE" );
    $display("%t Starting sequence dut_seq run_phase",$time);
    dut_seq.start(env0.agt0.sqr0);
    #100ns;
    phase.drop_objection( this , "Finished DUT BASE SEQUENCE" );
  endtask 
  
  
  
endclass :dut_test  



endpackage 






//////////////////////////////////////////
// Top
//////////////////////////////////////////
module top;

  import uvm_pkg::*;
  import dutuvm::*;
  
  
  logic clk;
  
  // Clock Generation 
  initial begin
   clk = 1'b0;
   forever #10 clk = ~clk;
  end 
  
  // Interface 
  dut_intf intf0 (.clk(clk));
 
  
  ////////
  // DUT INSTANTIATION
  ////////
  ALU_I uALU_I(
    .Num1   (intf0.Num1),
    .Num2   (intf0.Num2),
    .OpSel  (intf0.OpSel),
    .Result (intf0.Result)
  );
  

  
  initial begin
    uvm_config_db #(virtual dut_intf)::set(null, "*", "dut_intf", intf0);
    uvm_top.finish_on_completion = 1;
    $display("TOP");
    run_test("dut_test");
  end


  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1); 
  end 
  
  
endmodule: top
