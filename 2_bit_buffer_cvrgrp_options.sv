//  Design of a 2 bit buffer 

module top ( input [1:0] a, output [1:0] b);
  
  assign b = a;
  
endmodule
///////////////////////////////////////////////////////////////////////////////

// testbench 
// exploring the covergroup options 

module tb;
  
  reg [1:0] a; //00 01 10 11
  wire [1:0] b;
  integer i = 0;
  
  top dut(.a(a),.b(b)); // instantiation 
  
  covergroup cvr_a; // manual sample method as no event is explictly mentioned
    
    //options of  covergroups
    option.per_instance = 1; // enabling this option to view contribution of each instance.
    option.name = "COVER_A_B"; // naming the covergrp
    option.goal = 70; // setting the goal for coverage
    option.at_least = 4; // value must be covered at least 4 times
    option.auto_bin_max = 2; //specifying the number of bins for implicit bin creation
    
    coverpoint a; // automatic bins
    coverpoint b;
    
  endgroup
  
  cvr_a ci = new();
  
  initial begin
    for(i=0;i<10;i++)begin
      a = $urandom();
      ci.sample(); //manual calling of sample function 
      
      #10;
      
  end
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #500;
    $finish();
  end
  
endmodule
