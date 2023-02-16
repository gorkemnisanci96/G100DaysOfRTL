// System Verilog Constraints "inside" keyword    



class randomclass;
  rand bit [31:0] addr1;
  rand bit [31:0] addr2;
  rand bit [31:0] addr3;
  rand bit [31:0] addr4;
  
  // Set a range of values 
  constraint addr1_range { addr1 inside {[0:312]}; }
  
  // choose one of the specified values 
  constraint addr2_range { addr2 inside {1,512,1024,2048,13}; }
  
  // Mix the specified values and range of values 
  constraint addr3_range { addr3 inside {1,2,3,[128:256]}; }
  
  // Inverted Inside 
  constraint addr4_range { !(addr4 inside {[32'h00000100:32'hFFFFFFFF] }); }
  
endclass
 
module day48;
  initial begin
    randomclass class1;
    class1 = new();
    $display("------------------------------------");
    repeat(10) begin
      class1.randomize();
      $display("\t addr1 = %0d",class1.addr1);
      $display("\t addr2 = %0d",class1.addr2);
      $display("\t addr3 = %0d",class1.addr3);
      $display("\t addr4 = %0h",class1.addr4);
      $display("------------------------------------");
    end
  end
endmodule :day48
