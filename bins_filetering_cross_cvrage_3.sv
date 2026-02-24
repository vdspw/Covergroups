/* bins filtering in cross coverage */
/* multiple ignore bins in the covergroup */

module tb;
 
  reg [2:0] din; // rangs from 000 (0) - 111 (7) 
  reg wr;        // write signal 
  int i = 0;     // to run the loop for stimulus generation
  
   covergroup c ;
   
    option.per_instance = 1; // detailed report 
   
     coverpoint wr
     {
       bins wr_l = {0}; //explcit bins for write = 0
       bins wr_h = {1}; //explicit bins for write = 1
     }
     
     coverpoint din;  // din coverpoint 
     
   //  cross wr, din;
     
     cross wr,din
     {
     
       ignore_bins unused_din = binsof(din) intersect {[5:7]}; // anything din in 5 to 7 range is kept out of coverage
       ignore_bins unused_wr  = binsof(wr) intersect {0}; // anything when (wr) =0 is kept out of coverage
     }
     
  
  endgroup
  
  ///////////////////ignore bins to remove from coverage calc
  //////////// bins to include coverage in computation
  
 
  c ci;
 
  initial begin
    ci = new();
    
    
    
    for (i = 0; i <10; i++) begin
      din = $urandom();
      wr = $urandom();
      ci.sample();
      $display("wr : %d din : %0d", wr,din);
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #1000;
    $finish();
  end
  
 
 
 
 
endmodule
