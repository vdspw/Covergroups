module top(
  input [1:0] a,b,c,
  output reg [3:0] y
 
);
 
 /*
 User Logic here
 Do not add anything
 
 
 */
  
endmodule
//////////////////////////////////////////////
/* 
Generate stimulus to get 100% coverage for the following Scenarios 
1) Cover all the possible combinations of a,b,c 
2) Cover cross between a and even values of b
3) Cover cross between a and odd values of c 
4) Cover cross between even values of b and odd values of c
*/

module tb;
  
  reg [1:0] a, b, c;
  wire [3:0] y;
  
  int i = 0;
  
  top dut (.a(a), .b(b), .c(c), .y(y));
  
  covergroup cr;
    
    option.per_instance = 1;
    
    CP_A: coverpoint a
    {
      bins a_00 = {2'b00};
      bins a_01 = {2'b01};
      bins a_10 = {2'b10};
      bins a_11 = {2'b11};
    }
    
    CP_B: coverpoint b
    {
      bins b_00 = {2'b00};   // even (0)
      bins b_01 = {2'b01};   // odd  (1)
      bins b_10 = {2'b10};   // even (2)
      bins b_11 = {2'b11};   // odd  (3)
    }
    
    CP_C: coverpoint c
    {
      bins c_00 = {2'b00};   // even (0)
      bins c_01 = {2'b01};   // odd  (1)
      bins c_10 = {2'b10};   // even (2)
      bins c_11 = {2'b11};   // odd  (3)
    }
    
    // Scenario 1: All combinations of a, b, c (4x4x4 = 64 bins)
    CR_ALL_A_B_C: cross CP_A, CP_B, CP_C;
    
    // Scenario 2: Cross between a and even values of b
    // Even b = 00(0), 10(2) → ignore odd b = 01(1), 11(3)
    // Effective bins = 4 x 2 = 8 bins
    CR_A_X_EVEN_B: cross CP_A, CP_B
    {
      ignore_bins unused_odd_b = binsof(CP_B) intersect {1,3};  // ignore b=01,11 (odd)
    }
    
    // Scenario 3: Cross between a and odd values of c
    // Odd c = 01(1), 11(3) → ignore even c = 00(0), 10(2)
    // Effective bins = 4 x 2 = 8 bins
    CR_A_X_ODD_C: cross CP_A, CP_C
    {
      ignore_bins unused_even_c = binsof(CP_C) intersect {0,2};  // ignore c=00,10 (even)
    }
    
    // Scenario 4: Cross between even b and odd c
    // Even b = 00(0), 10(2) → ignore odd b = 01(1), 11(3)
    // Odd  c = 01(1), 11(3) → ignore even c = 00(0), 10(2)
    // Effective bins = 2 x 2 = 4 bins
    CR_EVEN_B_X_ODD_C: cross CP_B, CP_C
    {
      ignore_bins unused_odd_b2  = binsof(CP_B) intersect {1,3};  // ignore b=01,11 (odd)
      ignore_bins unused_even_c2 = binsof(CP_C) intersect {0,2};  // ignore c=00,10 (even)
    }
    
  endgroup
  
  cr ci;
  
  initial begin
    ci = new();
    
    // -------------------------------------------
    // Directed: Scenario 2 - all a x even b (00,10)
    // -------------------------------------------
    for (int j = 0; j <= 3; j++) begin
      a = j; b = 2'b00; c = $urandom();
      ci.sample(); $display("a:%b b:%b c:%b", a, b, c); #10;
      a = j; b = 2'b10; c = $urandom();
      ci.sample(); $display("a:%b b:%b c:%b", a, b, c); #10;
    end
    
    // -------------------------------------------
    // Directed: Scenario 3 - all a x odd c (01,11)
    // -------------------------------------------
    for (int j = 0; j <= 3; j++) begin
      a = j; c = 2'b01; b = $urandom();
      ci.sample(); $display("a:%b b:%b c:%b", a, b, c); #10;
      a = j; c = 2'b11; b = $urandom();
      ci.sample(); $display("a:%b b:%b c:%b", a, b, c); #10;
    end
    
    // -------------------------------------------
    // Directed: Scenario 4 - even b x odd c (4 combos)
    // -------------------------------------------
    b = 2'b00; c = 2'b01; a = $urandom(); ci.sample(); $display("a:%b b:%b c:%b", a, b, c); #10;
    b = 2'b00; c = 2'b11; a = $urandom(); ci.sample(); $display("a:%b b:%b c:%b", a, b, c); #10;
    b = 2'b10; c = 2'b01; a = $urandom(); ci.sample(); $display("a:%b b:%b c:%b", a, b, c); #10;
    b = 2'b10; c = 2'b11; a = $urandom(); ci.sample(); $display("a:%b b:%b c:%b", a, b, c); #10;
    
    // -------------------------------------------
    // Random: fill all 64 bins for Scenario 1
    // -------------------------------------------
    for (i = 0; i < 1000; i++) begin
      a = $urandom();
      b = $urandom();
      c = $urandom();
      ci.sample();
      $display("a:%b b:%b c:%b", a, b, c);
      #10;
    end
    
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #15000;          /
    $finish();
  end
  
endmodule
