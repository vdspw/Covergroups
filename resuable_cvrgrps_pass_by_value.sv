/* Reusable covergroups -- pass by value */

module tb;
 
  reg [3:0] a, b; // low - 0 to 3, mid - 4 to 10, high - 11 to 15
  
  integer i = 0;
  // while pass by ref , the keyword "ref" is used.
  // for the pass by value , "input" must be used.
  covergroup c (ref reg [3:0] varn,input string var_id,input int low,input int mid,input int high);
    option.per_instance = 1;
    option.name = var_id;
    coverpoint varn{
      bins lower_value = {[0:low]};
      bins mid_value = {[low+1 : mid]};
      bins high_value = {[mid +1 : high]};
    }// takes both the varialbes "a" and "b".
    
  endgroup 
  
  
 // "c" is the cvrgrp ; "cia" is instance ; there are parameters to be passed in the parantesis.
// "a" and "b" are passed by ref , the name is passed as value.
  // 3 10 15 are the values passed .
  c cia = new(a, "Variable a",3,10,15);
  c cib = new(b, "Variable b",3,10,15);
 
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
