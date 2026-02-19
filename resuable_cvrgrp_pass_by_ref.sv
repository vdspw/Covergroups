/* Reusable covergroups -- pass by reference */

module tb;
 
  reg [3:0] a, b;
  
  integer i = 0;
  // while pass by ref , the keyword "ref" is used.
  // for the pass by value , "input" must be used.
  covergroup c (ref reg [3:0] varn,input string var_id);
    option.per_instance = 1;
    option.name = var_id;
    coverpoint varn; // takes both the varialbes "a" and "b".
    
  endgroup 
  
  
 // "c" is the cvrgrp ; "cia" is instance ; there are parameters to be passed in the parantesis.
// "a" and "b" are passed by ref , the name is passed as value.
  c cia = new(a, "Variable a");
  c cib = new(b, "Variable b");
 
  initial begin 
    
    for (i = 0; i <50; i++) begin
      a = $urandom();
      b = $urandom();
      cia.sample();
      cib.sample();
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
