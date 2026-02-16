// Bins filtering -- WITH .

module tb;
 
  reg [3:0] a; /// 0 -15 
  integer i = 0;
 
 
  covergroup c;
    option.per_instance = 1;
    
    coverpoint a {
      bins zero = {0};
      //bins odd_a  = {1,3,5,7,9,11,13,15}; // manual way of including odd and even no.s in the bins.
      //bins even_a = {2,4,6,8,10,12,14};
     
      /* example with "WITH" condition */
      
      bins odd_a = a with ((item > 0) && (item % 2 == 1));
      bins even_a = a with ((item > 0) && (item % 2 == 0));
      
      bins mul_3 = a with ((item >0) && (item % 3 == 0));
      
    }
    
    
  endgroup
  
  
  
 
  c ci;
 
  initial begin
     ci = new();
    
    
    
    for (i = 0; i <20; i++) begin
      a = $urandom();
      $display("Value of a : %0d",a);
      ci.sample();
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #200;
    $finish();
  end
endmodule
