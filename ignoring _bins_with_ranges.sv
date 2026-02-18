/* Ignoring Bins - range */
/* "a" has width of 6 bits so 2^6=64 values (ranges from 0-63) .
we are going to ignore the values in ranges : 3-7;32-36;47-50;61-64 */
/* the coverage is going to be calculated for the rest of the values */

module tb;
   
  reg [5:0] a;  ///// 0 -- 64  3-7     32-36    47-50   61-64
  integer i = 0;
 
  
 covergroup c;
   option.per_instance = 1;
   
   coverpoint a {
     
     ignore_bins unused_range1[] = {[3:7]}; /*ignored range 1*/
     
     ignore_bins unused_range2[] = {[32:36]}; /* ignored range 2*/
     
     ignore_bins unused_range3[] = {[47:50]}; /* ignored range 3*/
     
     ignore_bins unused_range4[] = {[61:64]}; /* ignored range 4*/
   
   
   }
   
   
   
 endgroup 
  
  
  
  
 
  
 
  c ci;
 
  initial begin
     ci = new();
    
    
    
    for (i = 0; i <40; i++) begin
      a = $urandom();
      ci.sample();
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #400;
    $finish();
  end
  
 
 
 
 
endmodule
