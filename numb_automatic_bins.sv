/* number of automatic bins */
/* the number is default 64 bins */

module tb;
 
  reg  [7:0]  a;//256/64 = 4
  reg  [7:0]  b;
  
  
covergroup cvr_a ;
  
    option.per_instance = 1;
    
  coverpoint b; // this is gonna have 64 bins [4 values in 1 bin]
    
  coverpoint a {
   option.auto_bin_max = 256; //creating 256 bins only for cvrpnt a
  }
    
 endgroup 
  
 
  cvr_a ci = new();
 
  
  initial begin
    
    
    for (int i = 0; i < 5; i++) begin
      a = $urandom(); 
      b = $urandom();
      ci.sample();
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
