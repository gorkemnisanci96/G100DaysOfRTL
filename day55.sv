// ONE-HOT-3 Always Block State Machine 

enum {
  IDLE = 0,
  READ = 1,
  DLY  = 2, 
  DONE = 3
} state_index; 
logic [3:0] state, next; 


always_ff @(posedge clk or negedge rstn)
  begin
    if(!rstn) begin
       state         <= '0;
       state[IDLE]   <= 1'b1; 
    end else begin
       state         <= next; 
    end 
  end 


always_comb begin
  next = '0; 
  unique case (1'b1)
    state[IDLE]: 
        begin
          if(go) begin next[READ] = 1'b1; end 
          else   begin next[IDLE] = 1'b1; end 
        end 
    state[READ]: begin next[DLY]  = 1'b1;   end 
    state[DLY]: 
      begin
        if(!ws)  begin next[DONE] = 1'b1; end
        else     begin next[READ] = 1'b1; end 
      end 
    state[DONE]: begin next[IDLE] = 1'b1;  end 
    
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
          next[READ]: rd <= 1'b1; 
          next[DLY]:  rd <= 1'b1;
          next[DONE]: rd <= 1'b1;
        end 
    end   
  end 
