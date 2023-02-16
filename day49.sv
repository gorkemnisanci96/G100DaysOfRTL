// System Verilog Constraints Weighted Distribution   




class randomclass;
  rand bit [31:0] addr1;
  rand bit [31:0] addr2;
  
  // choose one of the specified values 
  constraint addr1_range { addr1 dist {1 :=10,512 :=50}; }
  
  // Mix the specified values and range of values 
  constraint addr2_range { addr2 dist {1:=5,2:=1,3:=2,[128:256]:=14}; }

endclass
 
module day49;
  initial begin
    randomclass class1;
    class1 = new();
    $display("------------------------------------");
    repeat(10) begin
      class1.randomize();
      $display("\t addr1 = %0d",class1.addr1);
      $display("\t addr2 = %0d",class1.addr2);
      $display("------------------------------------");
    end
  end
endmodule :day49
