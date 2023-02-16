`timescale 1ns / 1ps
// APB BUS PROTOCOL MASTER MODULE 
// The APB Protocol has two independent Buses (One for Read and one for Write)
// The Buses can be up to 32-bit Wide. 
// Because the buses do not have their own individual handshake signals, it is not possible for data
// transfet to occur on both buses at the same time. 
//
// SIGNALS
//1-PSTRB :Write strobes. This signal indicates which byte lanes to update during a write
// transfer. There is one write strobe for each eight bits of the write data bus. 
// This Signal is Initialized to all 1s when there is a write transfer and 0s when there is a READ.
//2- i_PSLVERR: This signal indicates a transfer failure. APB peripherals are not required to
//support the PSLVERR pin. Where a peripheral does not include this pin then the
//appropriate input to the APB bridge is tied LOW. 
//3-o_PPROT: Protection type. This signal indicates the normal, privileged, or secure
//protection level of the transaction and whether the transaction is a data access
//or an instruction access.[IT IS INITIALIZED TO ZERO]


module day17
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
     o_PSEL    <= o_PSEL_Next;
     o_PADDR   <= o_PADDR_Next;
     o_PENABLE <= o_PENABLE_Next;
     o_PWRITE  <= o_PWRITE_Next; 
     o_PWDATA  <= o_PWDATA_Next;
     o_PSTRB   <= o_PSTRB_Next;      
   end 
end 



    
    
    
    
endmodule :day17



///////////////////////////////////
//         TEST BENCH 
//////////////////////////////////

module day17_tb();

// CONSTANT PARAMETERS 
parameter PADDRWIDTH  = 32;
parameter DATAWIDTH   = 32; 
parameter SLAVENUMBER = 2;



//TOP MODULE - APB_MASTER INTERFACE 
logic [1:0]                   i_CMD;       // CMD=00 --> NO TRANSFER --CMD=01 --> WRITE TRANSFER--CMD=10 --> READ TRANSFER 
logic [(PADDRWIDTH-1):0]      i_CMDADDR;
logic [(DATAWIDTH-1):0]       i_CMDDATA;
logic [$clog2(SLAVENUMBER):0] i_CMDSLAVENUM; // CHECK IF WE NEED IT.  
// APB INTERFACE 
logic                      PCLK;
logic                      PRESETn;
//
logic                      o_PPROT; 
//
logic [(SLAVENUMBER-1):0]  o_PSEL;
//
logic [(PADDRWIDTH-1):0]   o_PADDR;
//
logic                     o_PENABLE;
logic                     o_PWRITE;
logic [(DATAWIDTH-1):0]   o_PWDATA; 
logic [(DATAWIDTH/8-1):0] o_PSTRB;
//
logic                     i_PREADY; 
logic [(DATAWIDTH-1):0]   i_PRDATA;
//
logic                     i_PSLVERR; 
   
///////////////////////////////
// CLOCK GENERATION 
//////////////////////////////
initial begin
PCLK = 1'b0;
fork
   forever #10 PCLK = ~PCLK;
join
end 
///////////////////////////////
// RESET TASK  
//////////////////////////////
task RESET();
begin
   i_PSLVERR     = 1'b0;
   i_CMD         = 2'b0;
   i_CMDADDR     = 0;
   i_CMDDATA     = 0;
   i_CMDSLAVENUM = 0;
   i_PREADY      = 1'b0;
   i_PRDATA      = 0;
   //
   PRESETn = 1'b1;
   @(posedge PCLK);
   PRESETn = 1'b0;
   repeat(2)@(posedge PCLK);
   PRESETn = 1'b1;
   repeat(5)@(posedge PCLK);
end 
endtask

///////////////////////////////
// WRITE DATA with No Wait State  
//////////////////////////////
// This WRITE Task Simulate the Top module that sends the COMMAND and also the slave that Sends the 
// READY SIGNAL. 
task WRITE_NoWait
(
   input logic [(PADDRWIDTH-1):0]      Addr,
   input logic [(DATAWIDTH-1):0]       Data,
   input logic [$clog2(SLAVENUMBER):0] SlaveNum
); 
begin
    i_PREADY = 1'b0;
    @(posedge PCLK);
       i_CMD         = 2'b01;
       i_CMDADDR     = Addr;   
       i_CMDDATA     = Data; 
       i_CMDSLAVENUM = SlaveNum;
    @(posedge PCLK);
       i_CMD         = 2'b00;
    repeat(1)@(posedge PCLK);  
       i_PREADY = 1'b1;
    @(posedge PCLK);
       i_PREADY = 1'b0;
end 
endtask 


///////////////////////////////
// WRITE DATA with WAIT STATE
//////////////////////////////
// This WRITE Task Simulate the Top module that sends the COMMAND and also the slave that sends the 
// READY SIGNAL. 
// The Slave can use the READY Signal to make the MASTER wait
task WRITE_Wait
(
   input logic [(PADDRWIDTH-1):0]      Addr,
   input logic [(DATAWIDTH-1):0]       Data,
   input logic [$clog2(SLAVENUMBER):0] SlaveNum
); 
begin
    i_PREADY = 1'b0;
    @(posedge PCLK);
       i_CMD         = 2'b01;
       i_CMDADDR     = Addr;   
       i_CMDDATA     = Data; 
       i_CMDSLAVENUM = SlaveNum;
    @(posedge PCLK);
       i_CMD         = 2'b00;
    repeat(3)@(posedge PCLK);  
       i_PREADY = 1'b1;
    @(posedge PCLK);
       i_PREADY = 1'b0;
end 
endtask 

///////////////////////////////
// READ DATA with No WAIT STATE 
//////////////////////////////
task READ_NoWait
(
   input logic [(PADDRWIDTH-1):0]      Addr,
   input logic [$clog2(SLAVENUMBER):0] SlaveNum
); 
begin
    i_PREADY = 1'b0;
    @(posedge PCLK);
       i_CMD         = 2'b10;
       i_CMDADDR     = Addr;   
       i_CMDSLAVENUM = SlaveNum;
    @(posedge PCLK);
       i_CMD         = 2'b00;
    repeat(1)@(posedge PCLK);
       i_PRDATA = 32'hdead_cafe;  
       i_PREADY = 1'b1;
    @(posedge PCLK);
       i_PREADY = 1'b0;
end 
endtask 

///////////////////////////////
// READ DATA with WAIT STATE 
//////////////////////////////
task READ_Wait
(
   input logic [(PADDRWIDTH-1):0]      Addr,
   input logic [$clog2(SLAVENUMBER):0] SlaveNum
); 
begin
    i_PREADY = 1'b0;
    @(posedge PCLK);
       i_CMD         = 2'b10;
       i_CMDADDR     = Addr;   
       i_CMDSLAVENUM = SlaveNum;
    @(posedge PCLK);
       i_CMD         = 2'b00;
    repeat(5)@(posedge PCLK);
       i_PRDATA = 32'hFEEA_0123;  
       i_PREADY = 1'b1;
    @(posedge PCLK);
       i_PREADY = 1'b0;
end 
endtask 





initial begin
RESET();
WRITE_NoWait(.Addr (5),.Data (32'hDEAD_CAFE),.SlaveNum (0));
RESET();
WRITE_Wait(.Addr (10),.Data (32'hABCD_1234),.SlaveNum (1));
RESET();
READ_NoWait(.Addr (15),.SlaveNum (1));
RESET();
READ_Wait(.Addr (15),.SlaveNum (0));

repeat(20) @(posedge PCLK);
$finish;
end 





//////////////////////////////////
// DUT INSTANTIATION 
/////////////////////////////////
day17
#(.PADDRWIDTH  (PADDRWIDTH),
  .DATAWIDTH   (DATAWIDTH), 
  .SLAVENUMBER (SLAVENUMBER) )
uday17
(.*);




endmodule :day17_tb
