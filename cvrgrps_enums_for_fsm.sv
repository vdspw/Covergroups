// enum for FSM's - covergroups

module tb;
 
  typedef enum bit [1:0] {s0 = 2'b00,s1 = 2'b01,s2 = 2'b10,s3 = 2'b11} fsmstate;
  fsmstate var1; // var1 contains all the states mentioned above.
  
  
  
 covergroup c;
   option.per_instance = 1; // enabled for detailed report.
   coverpoint var1;			// creating a cvrpnt for 
 endgroup
  
  
  initial begin
    c cia = new();
    $cast(var1,2'b00); //this casts the value 2'b00 into s0 and makes the compiler understand, we are trying to create a coverpoint for S) specifically.
    // var1 = s0; /* alernate way for above line */
    cia.sample();
  end
  
 
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #200;
    $finish();
  end
  
 
 
 
 
endmodule
