// testbench 
// exploring the covergroup option and type option.

module tb;
 
  reg  [1:0]  a;
  reg [1:0]  b;
  integer i = 0;
  
  
  covergroup cvr_a ; ///// manual sample method
    option.per_instance = 1; // applies for the entire grp
    
    option.goal = 62;      // applied for the entire grp
    type_option.goal = 62; // applied for the entire grp
    
    coverpoint a{
    option.goal = 50;		// applied for the coverpoint a
    }
    
    coverpoint b{
    option.goal = 75;      // applied for the coverpoint b
    }
 
  
  endgroup 
  
 
  cvr_a ci = new();       
 
  
  initial begin
    
    
    for (i = 0; i < 5; i++) begin
      a = $urandom();  
      b = $urandom();
      ci.sample(); // calling manual sample method
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #500;
    $finish();
  end
 
endmodule
