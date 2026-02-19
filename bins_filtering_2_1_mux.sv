//2:1 MUX for covergroups hw1

module mux_2 (
  input [1:0] a,b,
  input sel,
  output reg [1:0] y 
);
  
always_comb
  begin
    if(sel) 
      y = a;
    else
      y = b;
  end
  
  endmodule
/////////////////////////////////////////////////////////////////////////////
/*Create a stimulus for 100 % coverage of signal y. Create two explicit bins, one working with all 
the possible values of a (00,01,10,11) when sel is high and the other working with all the possible values of b when sel is low. Do not Use Cross Coverage, Prefer Wildcard bins. */

module tb;
  
  reg [1:0] a,b; // inputs 
  reg sel;		// inputs
  wire [1:0] y; 
  
  mux_2 dut (.a(a),.b(b),.sel(sel),.y(y)); //instantiation
  
  covergroup c;
    option.per_instance = 1; // for detailed report.
    
    coverpoint {sel,a}
    {
      wildcard bins sel_high_a_0 = {3'b 100}; // sel 1 a 00
      wildcard bins sel_high_a_1 = {3'b 101}; // sel 1 a 01
      wildcard bins sel_high_a_2 = {3'b 110}; // sel 1 a 10
      wildcard bins sel_high_a_3 = {3'b 111}; // sel 1 a 11
    }
    
    coverpoint {sel,b}
    {
      wildcard bins sel_low_b_0 = {3'b 100}; // sel 0 b 00
      wildcard bins sel_low_b_1 = {3'b 101}; // sel 0 b 01
      wildcard bins sel_low_b_2 = {3'b 110}; // sel 0 b 10
      wildcard bins sel_low_b_3 = {3'b 111}; // sel 0 b 11
    }
    coverpoint y;
  endgroup
  
  c ci = new();
  
  initial begin

  for (int i = 0; i < 20; i++) begin
      a = $urandom(); 
      b = $urandom();
      
      sel = $urandom();
      ci.sample();
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
