`timescale 1ns / 1ps

module NEXYS_4_LED_BLINK_PLL_CLK(
   input  logic         CLK100MHZ, 
   input  logic         RESETN, 
   output logic [15:0]  LED  
    );

parameter one_sec_100mhz = 32'd100_000_000;
//parameter one_sec_100mhz = 32'd10;

logic PLL_CLK50MHZ,PLL_CLK25MHZ, PLL_CLK10MHZ; 
logic [31:0] count_50MHZ, count_25MHZ, count_10MHZ;
logic locked;
logic LED0,LED1,LED2; 
    
    
 //==================================
 // PLL     
 //==================================      
  clk_wiz_0 PLL
   (
    // Clock out ports
    .CLK_50MHZ(PLL_CLK50MHZ),     // output CLK_100MHZ
    .CLK_25MHZ(PLL_CLK25MHZ),     // output CLK_25MHZ
    .CLK_10MHZ(PLL_CLK10MHZ),     // output CLK_10MHZ
    // Status and control signals
    .reset(~RESETN), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(CLK100MHZ)      // input clk_in1
);    
    
    




always_ff @(posedge PLL_CLK50MHZ, negedge RESETN)
begin
 
   if(!RESETN)
   begin
      count_50MHZ    <= '0;
      LED0           <= '0;
   end else begin
      count_50MHZ   <= count_50MHZ + 1;
      if(count_50MHZ == one_sec_100mhz)
      begin
         count_50MHZ   <= '0;
         LED0          <= ~LED0;
      end
   end 

end 

  
  
always_ff @(posedge PLL_CLK25MHZ, negedge RESETN)
begin
 
   if(!RESETN)
   begin
      count_25MHZ   <= '0;
      LED1          <= '0;
   end else begin
      count_25MHZ   <= count_25MHZ + 1;
      if(count_25MHZ == one_sec_100mhz)
      begin
         count_25MHZ  <= '0;
         LED1         <= ~LED1;
      end
   end 

end 
  
    
always_ff @(posedge PLL_CLK10MHZ, negedge RESETN)
begin
 
   if(!RESETN)
   begin
      count_10MHZ   <= '0;
      LED2          <= '0;
   end else begin
      count_10MHZ   <= count_10MHZ + 1;
      if(count_10MHZ == one_sec_100mhz)
      begin
         count_10MHZ  <= '0;
         LED2         <= ~LED2;
      end
   end 

end   


always_comb
begin
   LED[0] = LED0;
   LED[1] = LED1;
   LED[2] = LED2;
   LED[15:3] = '0;
end   
    
endmodule :NEXYS_4_LED_BLINK_PLL_CLK


module NEXYS_4_LED_BLINK_PLL_CLK_tb();

logic        CLK100MHZ;
logic        RESETN;
logic [15:0] LED; 


initial begin
 CLK100MHZ = 1'b0; 
 forever #10 CLK100MHZ = ~CLK100MHZ;   
end 


task RESET();
begin
   RESETN = 1'b1;
   repeat(2) @(posedge CLK100MHZ);
   RESETN = 1'b0;
   repeat(2) @(posedge CLK100MHZ);
   RESETN = 1'b1;
end 
endtask 



initial begin
   RESET();
   repeat(200) @(posedge CLK100MHZ);
   $finish;
end 

NEXYS_4_LED_BLINK_PLL_CLK uNEXYS_4_LED_BLINK_PLL_CLK( .*);

endmodule :NEXYS_4_LED_BLINK_PLL_CLK_tb  


