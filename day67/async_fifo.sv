`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Dual-Clock Asyncronous FIFO based on the Clifford E. Cummings Paper:
// "http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf"



//===========================
// ASYNCHRONOUS FIFO 
//===========================
module async_fifo
#(parameter ADDRSIZE = 3, 
  parameter DATASIZE = 8)
(
   input  logic w_clk,w_rstn,w_en,
   input  logic r_clk,r_rstn,r_en,
   input  logic [(DATASIZE-1):0] w_data,
   output logic [(DATASIZE-1):0] r_data,           
   output logic full, 
   output logic empty 
    );
    

localparam DEPTH = 1<<ADDRSIZE;    
    
logic  [(DATASIZE-1):0] FIFO_MEM [(DEPTH-1):0];   
logic  [(ADDRSIZE-1):0] w_addr;
logic  [(ADDRSIZE-1):0] r_addr;
logic  [ADDRSIZE:0] r_bin,r_bin_next;
logic  [ADDRSIZE:0] w_bin,w_bin_next;
logic  [ADDRSIZE:0] w_graycode,w_graycode_next;
logic  [ADDRSIZE:0] r_graycode,r_graycode_next;
logic  [ADDRSIZE:0] w_graycode_reg1,w_graycode_reg2;
logic  [ADDRSIZE:0] r_graycode_reg1,r_graycode_reg2;
logic full_next;
logic empty_next;

    
//===========================
//READ/WRITE  FIFO MEMORY 
//===========================
always_ff @(posedge w_clk)
begin
   if(w_en && !full) begin FIFO_MEM[w_addr] <= w_data; end     
end 
 
assign r_data = FIFO_MEM[r_addr];



//===========================
// WRITE ADDRESS/POINTER GENERATION 
//===========================
assign w_bin_next = w_bin + (w_en & ~full);
assign w_graycode_next = (w_bin_next>>1) ^ w_bin_next; 
assign w_addr = w_bin[(ADDRSIZE-1):0];  


always_ff @(posedge w_clk or negedge w_rstn)
begin
   if(!w_rstn)
   begin
      w_bin      <= '0;
      w_graycode <= '0;
   end else begin
      w_bin      <= w_bin_next;
      w_graycode <= w_graycode_next;
   end 
end 



//===========================
// READ ADDRESS/POINTER GENERATION 
//===========================
assign r_bin_next = r_bin + (r_en & ~empty);    
assign r_graycode_next = (r_bin_next>>1) ^ r_bin_next;   
assign r_addr = r_bin[(ADDRSIZE-1):0];   
  
  
always_ff @(posedge r_clk or negedge r_rstn)
begin
   if(!r_rstn)
   begin
      r_bin      <= '0;
      r_graycode <= '0;
   end else begin
      r_bin      <= r_bin_next;
      r_graycode <= r_graycode_next;
   end 
end   
  


//===========================
// READ POINTER SYNCHRONIZER IN WRITE-CLOCK DOMAIN
//===========================
always_ff @(posedge w_clk or negedge w_rstn)
begin
   if(!w_rstn)
   begin
      {r_graycode_reg2,r_graycode_reg1} <= '0;
   end else begin
      {r_graycode_reg2,r_graycode_reg1} <= {r_graycode_reg1,r_graycode};
   end 
end 

//===========================
// WRITE POINTER SYNCHRONIZER IN WRITE-CLOCK DOMAIN
//===========================
always_ff @(posedge r_clk or negedge r_rstn)
begin
   if(!r_rstn)
   begin
      {w_graycode_reg2,w_graycode_reg1} <= '0;
   end else begin
      {w_graycode_reg2,w_graycode_reg1} <= {w_graycode_reg1,w_graycode};
   end 
end 

  
//===========================
// FULL/EMPTY CLOCK GENERATION 
//===========================  
assign full_next  = (w_graycode_next=={~r_graycode_reg2[ADDRSIZE:ADDRSIZE-1], r_graycode_reg2[ADDRSIZE-2:0]});
assign empty_next = (r_graycode_next== w_graycode_reg2);
  
//===========================
// FULL REGISTER IN WRITE-CLOCK DOMAIN
//===========================
always_ff @(posedge w_clk or negedge w_rstn)
begin 
   if(!w_rstn)
   begin
      full <= '0;
   end else begin
      full <= full_next;
   end 
end 

//===========================
// EMPTY REGISTER IN READ-CLOCK DOMAIN
//=========================== 
always_ff @(posedge r_clk or negedge r_rstn)
begin 
   if(!r_rstn)
   begin
      empty <= '0;
   end else begin
      empty <= empty_next;
   end 
end   

    
endmodule :async_fifo


//===========================
// ASYNCHRONOUS-FIFO TEST BENCH 
//===========================
module async_fifo_tb();


//===========================
// TEST BENCH LOCAL SIGNALS 
//===========================
parameter ADDRSIZE = 3; 
parameter DATASIZE = 8;

logic w_clk,w_rstn,w_en;
logic r_clk,r_rstn,r_en;
logic [(DATASIZE-1):0] w_data;
logic [(DATASIZE-1):0] r_data;           
logic full; 
logic empty; 

logic [DATASIZE-1:0] test_data_q[$];
logic [DATASIZE-1:0] test_data;
int error_cnt;



//===========================
// CLOCK GENERATION 
//===========================
initial begin
   w_clk = 1'b0;
   r_clk = 1'b0;
   fork
      forever #10 w_clk = ~w_clk;
      forever #15 r_clk = ~r_clk;
   join
end 



 

//===========================
// WRITE CLOCK-DOMAIN STIMULUS 
//===========================
initial begin 
   w_en   = '0;
   w_rstn = '0;
   repeat(4) @(posedge w_clk);
   w_rstn = 1'b1;
   repeat(4) @(posedge w_clk);
   for(int round=0;round<2;round++)
   begin
      for (int i=0; i<32; i++) begin
        @(posedge w_clk iff !full);
        w_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (w_en) begin
          w_data = $urandom;
          test_data_q.push_front(w_data);
        end
      end 
    end
   $finish;
end 



//==========================================
// READ CLOCK-DOMAIN STIMULUS and ERROR CHECK
//==========================================
initial begin
   error_cnt = '0;
   r_en   = '0;
   r_rstn = '0;
   repeat(4) @(posedge r_clk);
   r_rstn = 1'b1;
   for(int round=0;round<2;round++)
   begin
     for (int i=0; i<32; i++) begin
        @(posedge r_clk iff !empty)
        r_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (r_en) begin
          test_data = test_data_q.pop_back();
          // Check the FIFO output against the model FIFO output. 
          $display("Checking rdata: expected wdata = %h, rdata = %h", test_data, r_data);
          assert(r_data === test_data) 
          else 
          begin 
             $error("Checking failed: expected wdata = %h, rdata = %h", test_data, r_data);
             error_cnt++;
          end 
        end
     end
   end 
   
   // CHECK THE TOTAL NUMBER OF ERRORS 
   if(error_cnt == '0)
   begin
      $display("NO ERROR! - END OF TEST!");
   end else
   begin
      $display("YOU HAVE ERRORS! - %d Errors",error_cnt);
   end 
   
   
   $finish;
end 



//===========================
// DUT INSTANTIATION 
//===========================
async_fifo
#(.ADDRSIZE (ADDRSIZE), .DATASIZE (DATASIZE))
uasync_fifo
(.*);

endmodule :async_fifo_tb


