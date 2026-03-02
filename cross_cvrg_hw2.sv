module top (
  input [2:0] a, b,
  input rst,
  input feed,
  output [2:0] y,
  output done
);
  
/*
 
User Logic here
Do not add anything
..............
............
...........
.........
.......
 
*/
  
  endmodule

/////////////////////////////////////////////////////////////////
/* Generate stimulus to get 100% coverage for the following Scenarios
1) Cover all the possible combinations of a,b 
2) Cover rst. 
3) Cover cross between rst (low) and a.
4) Cover cross between rst (low) and b. 
5) Cover cross between a (00,11) and b(00,11) when rst is low. */

module tb;
  
  reg [2:0] a,b; // inputs ranges 000(0) - 111(7)
  reg rst;
  reg feed;
  
  wire [2:0] y;
  wire done;
  
  int i=0; // to run the loop
  
  top dut(.a(a),.b(b),.rst(rst),.feed(feed),.y(y),.done(done)); // instantiation
  
  covergroup cr;
    option.per_instance = 1; // for detailed report
    
    // covers rst -requirement 2
    coverpoint rst
    {
      bins rst_low = {0}; //explicit bin for reset =0
      bins rst_high = {1}; // explicti bin for reset =1
    }
    
    coverpoint a;
    coverpoint b;
    
    //covering all possible combintation 
    cross a,b;
    
    // cross between rst =0 and a.
    cross rst,a
    {
      ignore_bins rst_low = binsof(rst) intersect {1};
    }
    
    //cross of a- 00,11 and b-00,11 when rst -0
    cross rst,a,b
    {
      ignore_bins unused_rst = binsof(rst) intersect{1};
      ignore_bins unused_a    = binsof(a)   intersect {[1:2],[4:7]};
      ignore_bins unused_b    = binsof(b)   intersect {[1:2],[4:7]};
    }
    
    
  endgroup
  
  cr ci; // instance creation of the covergroup
  
  initial begin
    ci = new();
    
    rst = 1; a = 3'b000; b = 3'b000; feed = 0;
    ci.sample(); #10;
    
    rst = 0; a = 3'b000; b = 3'b000; feed = 0;
    ci.sample(); #10;
    
    rst = 0;
    a = 3'b000; b = 3'b000; ci.sample(); #10;
    a = 3'b000; b = 3'b011; ci.sample(); #10;
    a = 3'b011; b = 3'b000; ci.sample(); #10;
    a = 3'b011; b = 3'b011; ci.sample(); #10;
    
    rst = 0;
    for (int j = 0; j <= 7; j++) begin
      a = j; b = $urandom(); feed = $urandom();
      ci.sample(); #10;
    end
    
    rst = 0;
    for (int j = 0; j <= 7; j++) begin
      b = j; a = $urandom(); feed = $urandom();
      ci.sample(); #10;
    end
    
    for (i = 0; i <1000; i++) begin
      a = $urandom();
      b = $urandom();
      rst = $urandom();
      feed = $urandom();
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
