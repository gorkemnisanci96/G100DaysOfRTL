`timescale 1ns / 1ps
//////////////////////////////////////
// AHB3-Lite Slave---Memory 


module day33
#(parameter MEMSIZE = 128)
(
//
input logic        HSEL,
// Global Signals 
input logic        HCLK, 
input logic        HRESTn,
//
input logic [31:0] HWDATA,
//
input logic [31:0] HADDR,
input logic        HWRITE, 
input logic [2:0]  HSIZE,     
input logic [2:0]  HBURST,
input logic [3:0]  HPROT, 
input logic [1:0]  HTRANS,
input logic        HMASTLOCK,
input logic        HREADY,
// To the MUX (Transfer Response)
output logic [31:0] HRDATA,
output logic        HREADYOUT, 
output logic        HRESP
// 
    );
    
// SIGNAL DESCRIPTIONS      
logic [31:0] MEM [(MEMSIZE-1):0];    
    
    
    
    
  
   
endmodule
