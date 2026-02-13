// Design -- ADDER 

module top(
  input [7:0] a,b,
  output [7:0] sum,
  output cout
 
);
  
assign {cout,sum} = a + b;
   
  
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////
// testbench for adder
/*Create four explicit bins for a,b and y and implicit bins for cout. Generate stimulus to cover all the generated bins (100 % Coverage).*/
module tb;
 
  reg [7:0] a ;
  reg [7:0] b ;
  wire [7:0] sum ;
  wire cout ;
  
  top dut(.a(a),.b(b),.sum(sum),.cout(cout));
  
  
  initial begin
    $urandom(a);
    $urandom(b);
  end
  
  covergroup c @(a or b); // sample when a or b changes
    option.per_instance = 1;
    coverpoint a{
      bins a_bin ={[0:255]};
    }
    coverpoint b{
      bins b_bin ={[0:255]};
    }
    coverpoint sum {
      bins sum  = {[0:255]};   // Bin 3: lower half of sum
     // bins sum_high = {[128:255]}; // Bin 4: upper half of sum
    }
    coverpoint cout
    {
      bins cout ={[0:1]};
    }
  endgroup
 
  c cia;
  
  initial begin
    cia = new();
    repeat(200) begin  
      a = $urandom_range(0, 255);
      b = $urandom_range(0, 255);
      #10;  
    end
    
    
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #3000;
    $finish();
  end
  
 
 
 
 
endmodule
