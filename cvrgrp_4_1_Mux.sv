// Design of a 4:1 MUX

module top (
   input a,b,c,d,
  input [1:0] sel,
  output reg y);
  
  always@(*) begin
    case(sel)
      2'b00 : y =a;
      2'b01 : y =b;
      2'b10 : y =c;
      2'b11 : y =d;
      default : y = 1'b0;
    endcase
  end
endmodule
//////////////////////////////////////////////////////////////////////
// Testbench with covergroups

module tb;
  
  reg a,b,c,d;
  reg[1:0] sel;
  wire y;
  
  top dut (a,b,c,d,sel,y);
  
  covergroup cvr_mux;
    
    option.per_instance = 1; //for detailed report.
    
    coverpoint a 
    { 
      bins a_values[] = {0,1}; //array to hold the values.
    }
    
    coverpoint b 
    { 
      bins b_values[] = {0,1}; //array to hold the values.
    }
    
    coverpoint c 
    { 
      bins c_values[] = {0,1}; //array to hold the values.
    }
    
    coverpoint d 
    { 
      bins d_values[] = {0,1}; //array to hold the values.
    }
    
    coverpoint sel 
    { 
      bins sel_values[] = {0,1,2,3}; //array to hold the values.
    }
    coverpoint y 
    { 
      bins y_values[] = {0,1}; //array to hold the values.
    }
  endgroup
  
  cvr_mux ci = new();
  
  initial begin
    
    
    for (int i = 0; i < 20; i++) begin
      a = $urandom(); 
      b = $urandom();
      c = $urandom(); 
      d = $urandom();
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
