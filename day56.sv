// OUTPUT ENCODED STATES 

typedef enum logic [2:0] {
  IDLE = 3'b0_00,
  READ = 3'b0_01,
  DLY  = 3'b1_01,
  DONE = 3'b0_10,
  XXX  = 'x;
} state_type;


module day56 (
   input  logic clk, 
   input  logic rstn,
   input  logic go, 
   input  logic ws, 
   output logic rd, 
   output logic rd
);

  
state_type state, next; 
  
  

always_ff @(posedge clk or negedge rstn)
begin
  if(!rstn) begin state <= IDLE; end 
  else      begin state <= next; end 
end 

  
  

always_comb begin
  next = state; 

  case(state)
    IDLE:begin if(go) begin next = READ;  end end 
    READ:begin              next = DLY; end 
    DLY: 
      begin
        if(!ws) begin next = DONE;  end 
        else    begin next = READ;  end 
      end 
    DONE:       begin next = IDLE;  end 
    default:    begin next = XXX;   end 
  endcase 
  
end 


always_ff @(posedge clk or negedge rstn)
  begin
    if(!rstn) begin
      rd <= 1'b0;
      ds <= 1'b0; 
    end else begin
      rd <= 1'b0;
      rd <= 1'b0;
      unique case(1'b1)
        begin
          state[READ]: rd <= 1'b1; 
          state[DLY]:  rd <= 1'b1;
          state[DONE]: rd <= 1'b1;
        end 
    end   
  end 

        assign ds = state[1];
        assign rd = state[0]; 
        
        
endmodule :day56
