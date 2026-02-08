// testbench 
// exploring the covergroup options -- WEIGHTS

module tb;
  
  reg [1:0] a; //00 01 10 11
  reg [1:0] b;
  integer i = 0;
  
    
  covergroup c; // manual sample method as no event is explictly mentioned
    
    //options of  covergroups
    option.per_instance = 1; // enabling this option to view contribution of each instance.
    
    coverpoint a // automatic bins
    {
      option.weight = 5;
    }
    coverpoint b
    {
      option.weight = 3;
    }
    
  endgroup
  
   initial begin
     c ci = new();
    for(i=0;i<5;i++)begin
      a = $urandom();
      b = $urandom();
      ci.sample(); //manual calling of sample function 
      
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
