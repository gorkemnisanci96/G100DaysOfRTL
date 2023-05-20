`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// BLINK LED  
//////////////////////////////////////////////////////////////////////////////////


module LED_BLINK( input  logic        CLK100MHZ, 
                  input  logic        RESETN,
                  output logic [15:0] LED );

parameter one_sec_100mhz = 32'd100_000_000;
//parameter one_sec_100mhz = 32'd10;


logic [31:0] count;

always_ff @(posedge CLK100MHZ, negedge RESETN)
begin

   if(!RESETN)
   begin
      count   <= '0;
      LED     <= '0;
   end else begin
     count <= count + 1;
     if(count == one_sec_100mhz)
     begin
        count  <= '0;
        LED[0] <= ~LED[0];
     end
   end 

end 





endmodule :LED_BLINK  






module LED_BLINK_tb();

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

LED_BLINK uLED_BLINK( .*);

endmodule :LED_BLINK_tb  
