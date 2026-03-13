/* consective repeatition transistion */

/* there are methods which will help us to have expected number of Bins ,
in this scenario we have a condition where we expect the state to be high for 4 clk ticks , we are expecting to create 4 bins exactly */

/* the hit should be 100 % when we have 4 1's in a row --- EXPECTED BEHAVIOUR */
/* Solution -> in the explicit bin declared in the covergroup mention the transtion from 0 to 4 1's ,
so that it considers them as seperate threads */

module tb();
 
reg clk = 0;
  
  reg data[] = {1,1,1,1};   // can also be written as {1,1,1,1,0} to sperate threads
  reg state = 0;
   integer i = 0;
 
 
 
always #5 clk = ~clk;
 
 
  
  initial begin
    for(i = 0; i< 4; i++) begin
      @(posedge clk);
      state = data[i];
    end
  end
 
 
 
 
 
 
  covergroup c @(posedge clk);
    option.per_instance = 1;
    coverpoint state {
      bins trans_0_1 = (0 => 1[*4]); // transtion from 0 to 4 1's 
    }
    
    
  endgroup
 
  c ci;
  
 
  
  initial begin
    ci = new();
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #100;
    $finish();
  end
  
endmodule
