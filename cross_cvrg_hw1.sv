module top(
  input [1:0] a,b,c,
  output reg [3:0] y
 
);
 
 /*
 User Logic here
 Do not add anything
 ...................
 ..................
 ..................
 ...............
 */
  
endmodule


/* Generate stimulus to get 100% coverage for the following Scenarios 
1) Cover all the possible combinations of a,b and c 
2) Cover cross of a( 00, 01 ) with all the values of b. 
3) Cover cross of b(11) with all the possible values of c.
4) Cover cross of a (10), b(10), and c(10) 						*/

module tb;
  
  reg [1:0] a,b,c; // the inputs
  wire [3:0] y; // the output
  
  int i = 0;     // to run the loop for stimulus generation
  
  top dut (.a(a), .b(b) , .c(c), .y(y) ); // instantiation 
  
  covergroup cr;
    option.per_instance = 1; // detailed report 
    
    coverpoint a; 
    coverpoint b;
    coverpoint c;
    
    cross a,b,c; // All possible combinations of a,b,c.
    
    cross a,b
    {
      ignore_bins unused_a = binsof(a) intersect{[2:3]}; // ignoring a -10 ,11 & considering all value of b.
    }
    
    cross b,c
    {
      ignore_bins unused_b = binsof(b) intersect{[0:2]};// ignoring b-00,01,10 & considering 11 
    }
    
    cross a,b,c
    {
       ignore_bins unused_a2 = binsof(a) intersect {[0:1],[3:3]};  // remove a = 00,01,11
      ignore_bins unused_b2 = binsof(b) intersect {[0:1],[3:3]};  // remove b = 00,01,11
      ignore_bins unused_c2 = binsof(c) intersect {[0:1],[3:3]};  // remove c = 00,01,11
    }
    
    
  endgroup
  
  cr ci; // instance creation of the covergroup
  
  initial begin
    ci = new();
    
    for (i = 0; i <1000; i++) begin
      a = $urandom();
      b = $urandom();
      c = $urandom();
      ci.sample();
     
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
