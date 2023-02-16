`timescale 1ns / 1ps
// REFERENCE : https://developer.arm.com/documentation/ihi0033/a/Introduction/About-the-protocol
//////////////////////////////////////////////////////////////////////////////////
// AHB3-Lite 
// Update 1 (7/14/2022)
//

// AHB-Lite Master
// SIGNAL DESCRIPTIONS 
// HCLK       : Source-->Clock Source   (BUS CLOCK) 
// HRESTn     : Source-->Reset Controller, Active Low
// HADDR[31:0]: Destination-->Slave and Decoder,   
 
// BASIC TRANSFER-
// Single Transfer
// Always HPROT == 4'b0001; --? Data, User, Non-Bufferable, Non-Cacheable Access 
//  
module day32
#(parameter [2:0] BURSTType = 3'b000)
(
//
input logic        i_CMD_Valid,        // Command Valid 
input logic        i_CMD_Write,        // 1: Write 0:Read 
input logic [31:0] i_CMD_Data,         // Data 
input logic [31:0] i_CMD_Addr,         // ADDRES 
input logic [2:0]  i_CMD_Size,         // Transfer Size  
input logic [1:0]  i_CMD_TransferMode, // Single, BurstWithWrap, BurstWithoutWrap
//
input logic         HRESETn,
input logic         HCLK,
//
input logic         HREADY,
input logic         HRESP, 
//
input logic  [31:0] HRDATA,
// 
output logic [31:0] HADDR,
output logic        HWRITE, 
output logic [2:0]  HSIZE, 
output logic [2:0]  HBURST,
output logic [3:0]  HPROT,
output logic [1:0]  HTRANS,
output logic        HMASTLOCK,
//
output logic [31:0] HWDATA
    );
    
    

localparam [1:0] S_IDLE = 2'b00,
                 S_ADDR = 2'b01,
                 S_DATA = 2'b10;   
    
logic [1:0]  State, StateNext;    
logic [31:0] HADDRNext;
logic        HWRITENext; 
logic [2:0]  HSIZENext; 
logic [2:0]  HBURSTNext;
logic [3:0]  HPROTNext;
logic [1:0]  HTRANSNext;
logic        HMASTLOCKNext;
//
logic [31:0] HWDATANext1,HWDATANext1Reg,HWDATANext;

//input logic        i_CMD_Valid,        // Command Valid 
//input logic        i_CMD_Write,        // 1: Write 0:Read 
//input logic [31:0] i_CMD_Data,         // Data 
//input logic [31:0] i_CMD_Addr,         // ADDRES 
//input logic [1:0]  i_CMD_TransferMode, // Single, BurstWithWrap, BurstWithoutWrap

    
always_comb 
begin
   StateNext     = State; 
   HADDRNext     = HADDR;
   HWRITENext    = HWRITE; 
   HSIZENext     = HSIZE; 
   HBURSTNext    = HBURST ;
   HPROTNext     = HPROT;
   HTRANSNext    = HTRANS;
   HMASTLOCKNext = HMASTLOCK;
   HWDATANext    = HWDATA;
   
   case(State)
      S_IDLE:
      begin
        if(i_CMD_Valid)
        begin
           HADDRNext  = i_CMD_Addr;
           HWRITENext = i_CMD_Write;
           HSIZENext  = i_CMD_Size;
           
           // WRITE 
           HWDATANext1 = i_CMD_Data;
        end
      
      end 
      S_ADDR:
      begin
         HWDATANext <= HWDATANext1Reg;
      
      
      
      end 
      S_DATA:
      begin
         if(HREADY == 1'b1)
         begin
                                        StateNext = S_IDLE;
         
         end 
      
      
      
      
      end 
      
      
      //BURST STATE DIAGRAM
      default:
      begin
      
      end 
      
   endcase 


end     
    


//////////////////////////////////////
// REGISTERS     
//////////////////////////////////////    
always_ff @(posedge HCLK or negedge HRESETn)
begin
 
  if(!HRESETn)
  begin
     State          <= S_IDLE;
     HBURST         <= BURSTType;
     HMASTLOCK      <= 1'b1; // Perform Always a Locked Transfer 
     HSIZE          <= 3'b000; 
     HTRANS         <= 2'b00;
  end else begin
     State          <= StateNext;
     //
     HWDATANext1Reg <= HWDATANext1;
     HWDATA         <= HWDATANext;
     // 
     HBURST         <= HBURSTNext;
     HMASTLOCK      <= HMASTLOCKNext;
     HSIZE          <= HSIZENext;
     HTRANS         <= HTRANSNext;
        
  end 
  
end    
    
endmodule :day32





module day32_tb();

parameter [2:0] BURSTType = 3'b000;
//
logic         i_CMD_Valid;        // Command Valid 
logic         i_CMD_Write;        // 1: Write 0:Read 
logic [31:0]  i_CMD_Data;         // Data 
logic [31:0]  i_CMD_Addr;         // ADDRES 
logic [2:0]   i_CMD_Size;         // Transfer Size  
logic [1:0]   i_CMD_TransferMode; // Single, BurstWithWrap, BurstWithoutWrap
//
logic         HRESETn;
logic         HCLK;
//
logic         HREADY;
logic         HRESP; 
//
logic  [31:0] HRDATA;
// 
logic [31:0]  HADDR;
logic         HWRITE; 
logic [2:0]   HSIZE; 
logic [2:0]   HBURST;
logic [3:0]   HPROT;
logic [1:0]   HTRANS;
logic         HMASTLOCK;
//
logic [31:0]  HWDATA;


//////////////////////////////
//  Clock Generation 
//////////////////////////////
initial begin
  HCLK = 1'b0;
  fork
    forever #10 HCLK = ~HCLK;
  join
end 


//////////////////////////////
//  RESET TASK 
//////////////////////////////
task RESET();
begin
   // Initialize all the Input values to the Zero 
   //
   i_CMD_Valid = 1'b0; // Command Valid 
   i_CMD_Write = 'b0;  // 1: Write 0:Read 
   i_CMD_Data  = 'b0;  // Data 
   i_CMD_Addr  = 'b0;  // ADDRES 
   i_CMD_Size  = 'b0;  // Transfer Size  
   i_CMD_TransferMode = 'b0; // Single, BurstWithWrap, BurstWithoutWrap
   //
   HREADY = 'b0;
   HRESP  = 'b0;
   //
   HRDATA = 'b0; 
   //
   HRESETn = 1'b1;
   @(posedge HCLK);
   HRESETn = 1'b0;
   repeat(2)@(posedge HCLK);
   HRESETn = 1'b1;
end 
endtask 

/////////////////////////////////
//  Task to have a SingleWrite 
/////////////////////////////////
task SimpleWrite
(
input logic [31:0] i_Data,
input logic [31:0] i_Addr, 
input logic [2:0]  i_Size
);
begin
   @(posedge HCLK);
   HREADY             = 1'b1;
   //
   i_CMD_Valid        = 1'b1;  // Command Valid 
   i_CMD_Write        = 1'b1; // 1: Write 0:Read 
   i_CMD_Data         = i_Data;     // Data 
   i_CMD_Addr         = i_Addr;         // ADDRES 
   i_CMD_Size         = i_Size;         // Transfer Size  
   i_CMD_TransferMode = 'b0; // Single, BurstWithWrap, BurstWithoutWrap
end 
endtask 

initial begin
RESET();
repeat(5) @(posedge HCLK);
SimpleWrite( .i_Data (32'h5), .i_Addr (32'h10), .i_Size (3'd2) );


repeat(30) @(posedge HCLK);
$finish;
end 





/////////////////////////////////
//   DUT INSTANTIATION 
/////////////////////////////////
day32
#(.BURSTType (BURSTType))
uday32
(.*);


endmodule :day32_tb 


