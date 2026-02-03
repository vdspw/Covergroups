//  Design of a 2 bit buffer 

module top ( input [1:0] a, output [1:0] b);
  
  assign b = a;
  
endmodule

///////////////////////////////////////////////////////////////////////////////
// testbench 

module tb;
  
  reg[1:0] a;
  reg[1:0] b;
  
  integer i = 0;
  
  top dut(.a(a), .b(b));
  
  covergroup cvr_a; //no event associated -sample function is called later.
    coverpoint a; //automatic bins (no event)
    coverpoint b;
  endgroup
  
  //creation of the object
  cvr_a ci = new(); // instance creation
  
  initial begin
    for (i = 0; i <10; i++) begin
      a = $urandom();  
      ci.sample(); // manually calling the sample function 
      
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
