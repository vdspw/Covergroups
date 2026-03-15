// 8 :1 MUX 

module mux
  (
input a,b,c,d,e,f,g,h,
    input [2:0] sel,
output reg y
  );
 
  
  always@(*)
    begin
      case(sel)
       0: y = a;
       1: y = b;
       2: y = c;
       3: y = d;
       4: y = e;
       5: y = f;
       6: y = g;
       7: y = h;
       default : y = 0;
      endcase
    end
  
  
  
endmodule

/////////////////////////////////////////////////////////////////////////////////
/* coverage analysis testbench for 8:1 MUX */

/* initial problem faced -- in cross coverage not all grps gave 100% cvrg , after increasing the number of samples it was possible */

module tb;
  
reg a,b,c,d,e,f,g,h;  // inputs of the DUT 
  reg [2:0] sel;      // select line
wire y;               // y is the output
  
  mux dut (a,b,c,d,e,f,g,h,sel,y);  // instantiations 
 
 
  
  // covergroup
  covergroup cvr_mux;
    
    option.per_instance = 1; // for a detailed report
    
    coverpoint a
    {
      bins a_lo = {0};   // explict bins for 0 and 1 -- done for all 8 inputs
      bins a_hi = {1};
    }
    
    
    coverpoint b    {
      bins b_lo = {0};
      bins b_hi = {1};
    }
    
    coverpoint c    {
      bins c_lo = {0};
      bins c_hi = {1};
    }
    
    coverpoint d    {
      bins d_lo = {0};
      bins d_hi = {1};
    }
    
    
    coverpoint e    {
      bins e_lo = {0};
      bins e_hi = {1};
    }
    
    coverpoint f    {
      bins f_lo = {0};
      bins f_hi = {1};
    }
    
    coverpoint g    {
      bins g_lo = {0};
      bins g_hi = {1};
    }
    
    
    coverpoint h    {
      bins h_lo = {0};
      bins h_hi = {1};
    }
    
    coverpoint sel;   // automatic bin creation by the simulator
    
    coverpoint y;    // automatic bin creation by the simulator
    
    // for a - consider 0 and ignore all other values of sel 
    cross_a_sel:cross sel,a {
      
      ignore_bins sel_other = binsof(sel)intersect{[1:7]};
    }
    
    // for b - consider 1 and ignore all other values of sel
    cross_b_sel:cross sel,b {
      
      ignore_bins sel_other = binsof(sel)intersect{0,[2:7]};
    }
    
    // for c - consider 2 and ignore all other values of sel
    cross_c_sel:cross sel,c {
      
      ignore_bins sel_other = binsof(sel)intersect{[0:1],[3:7]};
    }
    
    // for d - consider 3 and ignore all other values of sel
    cross_d_sel:cross sel,d {
      
      ignore_bins sel_other = binsof(sel)intersect{[0:2],[4:7]};
    }
    
    // for e - consider 4 and ignore all other values of sel
    cross_e_sel:cross sel,e {
      ignore_bins sel_other = binsof(sel)intersect{[0:3],[5:7]};
    }
    
    // for f - consider 5 and ignore all other values of sel 
    cross_f_sel:cross sel,f {
      
      ignore_bins sel_other = binsof(sel)intersect{[0:4],[6:7]};
    }
    
    // for g - consider 6 and ignore all other values of sel
    cross_g_sel:cross sel,g {
      
      ignore_bins sel_other = binsof(sel)intersect{[0:5],7};
    }
    
    // for h - consider 7 and ignore all other values of sel
    cross_h_sel:cross sel,h {
      
      ignore_bins sel_other = binsof(sel)intersect{[0:6]};
    }
    
       
  endgroup
  
  cvr_mux ci = new();  // creating the instance of the covergroup
  
  initial begin
    for (int i = 0; i < 100; i ++) begin
    sel = $urandom();
    {a,b,c,d,e,f,g,h} = $urandom();
      ci.sample();  // manual sample function calling 
    #10;
  end 
end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1200;
    $finish;
    
  end
  
  
  
endmodule
