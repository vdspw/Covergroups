/* resuable cvrgrps -> pass by ref and value */

module tb;
 
  reg [3:0] a;
  reg [1:0] b;
  integer i = 0;
 /* 
  covergroup check_var (ref logic [3:0] var_name);
    option.per_instance = 1;
    coverpoint var_name;
  endgroup  
*/
 
  /*  THIS GIVES AN ERROR AS WE ARE PASSING THE VALUE BUT THE DIRECTION IS NOT SPECIFIED.
  
  covergroup check_var (int var_value);
    option.per_instance = 1;
    coverpoint a {
      bins f[] = {[0:var_value]};
    }
    
  endgroup
*/
  
  // VARIABLE NAMES "A" AND "B" ARE PASSED BY REF , THE VALUES ARE PASSED BY VALUE
  covergroup check_var (ref logic [3:0] var_name, input int var_value);
    option.per_instance = 1;
    
    coverpoint var_name {
    
      bins f[] = {[0:var_value]};
    
    }
    
    
    
    
  endgroup
  
  
  
  
  
  initial begin
    check_var cia = new(a,5);
    for(i = 0; i < 10; i++) begin
      a = $urandom();
      cia.sample();
      #10;
    end
    
  end
  
  
  
 
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #100;
    $finish();
  end
  
 
 
 
 
endmodule
