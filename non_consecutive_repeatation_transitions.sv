/* non- consective repeatition transistion */

/* there are methods which will help us to have expected number of Bins ,
*/

/*we need to have a bin for 5 ones during the simulation --- EXPECTED BEHAVIOUR */
/* Solution -> in the explicit bin declared in the covergroup mention the transtion from 0 to 4 1's ,
so that it considers them as seperate threads */

/* whenever repeatation occurs a new thread is created - logic is similar to overallping state machines */

module tb();
 
reg clk = 0;
  
  reg data[] = {0,0,0,1,1,0,0,1,0,1,0,1,1,1,0};
  reg state = 0;
   integer i = 0;
 
 
 
always #5 clk = ~clk;
 
 
  
  initial begin
    for(i = 0; i< 15; i++) begin
      @(posedge clk);
      state = data[i];
    end
  end
 
 
 
 
 
 
  covergroup c @(posedge clk);
    option.per_instance = 1;
    coverpoint state {
      bins trans_0_1 = (0 => 1[->5]); // transtion from 0 to 4 1's 
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
