// Sampling Methods -> using an inbuilt sample() method

module tb;
   
  reg [1:0] a = 0;
  reg en = 0;
  reg clk = 0;
  integer i = 0;
  
  always #5 clk = ~clk;
  
  always #10 en = ~en;
  
 
  covergroup c ;
    option.per_instance = 1;
    
    coverpoint a;
    
  endgroup
  
 
 
 
  c ci;
 
  initial begin
     ci = new();
    
    
    
    for (i = 0; i <40; i++) begin
      @(posedge clk);
      a = $urandom(); // after generating the values we must sample 
      ci.sample(); // method is called here !!!
    end
    
    
  end
 
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #400;
    $finish();
  end

endmodule
