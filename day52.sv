// 2 always Block Coding Style - Recomended - Combinatorial Outputs. 
// http://www.sunburst-design.com/papers/CummingsSNUG2019SV_FSM1.pdf
// Good Coding Practice List for FSM.
//1- Use '0 / '1 / 'x to make all-zero , all-one and all-x assignments. 
//2- Use typedef enum types for state and state_next. Place the type definition in a package to ease the modification. 
//3- Add XX state to the enum to help debug the design and help optimize the synthesized result. 
//4- Declare	the	state	register	using	just	3	lines	of	code	and	place	it	at	the	top	of	the	design	
//   after	the	enumerated	type	declaration. No need to yse begin-end 
//      always_ff @(posedge clk, negedge rst_n)
//         if (!rst_n) state <= IDLE;
//         else        state <= next; 
//5- Use	the	pre‐default	next='x or next=state	assignment	at	the	top	of	the	always_comb	procedure.	
//6- Place the	next	assignments	in	a	neat	column	in	the	FSM	RTL	code.
//7- 






typedef enum logic [1:0] {
                         IDLE = 2'b00,
                         READ = 2'b01,
                         DLY  = 2'b11, 
                         DONE = 2'b10,
                         XXX  = 'x } state_type; 





module day52 (
   input logic clk, 
   input logic rstn,
   input logic go, 
   input logic ws, 
   output logic rd, 
   output logic rd
);
  
  state_type state,next; 
  
  always_ff @(posedge clk, negedge rstn)
      if(!rstn)state <= IDLE;  
      else     state <= next;
  
  
  always_comb
     begin
        next = XXX;
        rd   = '0;
        rs   = '0;
       case(state)
         IDLE:
           begin
             if(go) begin next = READ;  end 
             else   begin next = IDLE;  end 
           end 
         READ:
           begin
             rd = '1;
                          next = DLY;
           end 
         DLY:
           begin
             rd = '1;
             if(!ws) begin next = DONE;  end 
             else    begin next = READ;  end               
           end 
         DONE:
           begin
             ds = '1;
                           next = IDLE;
           end 
         
         default:
           begin
             ds = 'x;
             rd = 'x;
                           next = XXX;
           end 
       endcase 
       
       
     end 
  
  
  

  
endmodule :day52  


