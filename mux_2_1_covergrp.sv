// 2:1 Mux Design 
module mux2_1
  (
    input in1, in2, sel,
    output out);
 
 
assign out = sel ? in2 : in1;
 
endmodule
//////////////////////////////////////////////////////
// Generation of coverage report for a 2:1 mux 
// this uses a run.do (Tcl) script and the system verilog testbnech which covergroups.

// testbench

module tb;
  
  reg in1, in2, sel;
  wire out;
  
  mux2_1 dut (in1, in2, sel, out);
  
  covergroup cvr_mux;
    
    option.per_instance = 1;
    
    coverpoint in1;
    
    coverpoint in2; 
    
    coverpoint sel;
    
    coverpoint out;
    
  endgroup
  
  cvr_mux ci = new();
  
  initial begin 
    for(int i = 0; i < 10; i++)
      begin
        in1 = $urandom();
        in2 = $urandom();
        sel = $urandom();
        ci.sample(); 
        #10;
      end
    
  end
  
  
endmodule
///////////////////////////////////////////////////////////////////////

