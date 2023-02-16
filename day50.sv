// UVM_SEQUENCE_ITEM METHODS 



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


// 
class ALU_seq_item extends uvm_sequence_item;
    
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

  
  
  rand logic [7:0] Num1;  
  rand logic [7:0] Num2; 
       logic [7:0] Result;
  rand OpSelType OpSel;
  
  //Utility and Field Macros
  `uvm_object_utils_begin(ALU_seq_item)
    `uvm_field_int(Num1,UVM_ALL_ON)
    `uvm_field_int(Num2,UVM_ALL_ON)
    `uvm_field_int(Result,UVM_ALL_ON)
    `uvm_field_int(OpSel,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //////////
  //  Constructor Function 
  //////////
  function new(string name = "ALU_seq_item");
    super.new(name);
  endfunction
  

endclass

//-------------------------------------------------------------------------
//Simple TestBench to access sequence item
//-------------------------------------------------------------------------
module day50;
  
  //Create Class Instances 
  ALU_seq_item ALU_seq_item_0;
  ALU_seq_item ALU_seq_item_1;
  ALU_seq_item ALU_seq_item_2;
  bit pack_data[];
  
  initial begin
    //Class The Create Method 
    ALU_seq_item_0 = ALU_seq_item::type_id::create("ALU_seq_item_0"); 
    ALU_seq_item_1 = ALU_seq_item::type_id::create("ALU_seq_item_1");
    
    
    // randomize() Method 
    // Assigns random valus to the signals defines as rand or randc
    ALU_seq_item_0.randomize(); // --> Randomize the rand variables of the ALU_seq_item_0
    //print() Method. Prints the Values assigned to the all the signals defined in the sequence item  
    ALU_seq_item_0.print();     // --> Call the print Method to print the variables of the ALU_seq_item_0
    
    //copy() method
    //Copies the signal values from one sequence item to the other one. 
    ALU_seq_item_1.copy(ALU_seq_item_0); // --> Copy  ALU_seq_item_0 to the ALU_seq_item_1
    ALU_seq_item_1.print();          
    
    ALU_seq_item_0.randomize(); // Randomize the ALU_seq_item_0 again but dont copy it into the ALU_seq_item_1
    ALU_seq_item_1.print();     // print ALU_seq_item_1
    
    // compare() method. 
    if(ALU_seq_item_0.compare(ALU_seq_item_1))
    begin
      `uvm_info("","ALU_seq_item_0 is equal to ALU_seq_item_1", UVM_LOW)
    end else begin
      `uvm_info("","ALU_seq_item_0 is not equal to ALU_seq_item_1", UVM_LOW)      
    end 
    
    
    // clone() Method 
    // The method creates and returns the exact copy of the object 
    // Creates an object and copy the object into the created one 
    $display("Printing ALU_seq_item_0");
    $cast(ALU_seq_item_2,ALU_seq_item_0.clone()); 
    ALU_seq_item_0.print();
    $display("Printing ALU_seq_item_2");
    ALU_seq_item_2.print(); 
    // When we print the ALU_seq_item_2, the name appers as a
    //ALU_seq_item_0
    
    
    // pack() & unpack() methods  
    ALU_seq_item_0.pack(pack_data);
    foreach(pack_data[i])
      $display("pack_data[%0d]: %b",i,pack_data[i]);
    $display("Print After the pack()");
    ALU_seq_item_0.print(); 
    
    $display("---UNPACK---");
    ALU_seq_item_1.unpack(pack_data);
    foreach(pack_data[i])
      $display("pack_data[%0d]: %b",i,pack_data[i]);
    $display("Print ALU_seq_item_0 After the unpack()");
    ALU_seq_item_0.print();     
    $display("Print ALU_seq_item_1 After the unpack()");
    ALU_seq_item_1.print();  
    
    
    
    
  end  
endmodule :day50
