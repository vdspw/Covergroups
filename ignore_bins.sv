/* Ignore bins - example when the Ignore bins are used it doesnt throw an error like the illegal bins ,the rest of the functionality remains the same as illegal bins */

module tb;
  
  reg [2:0] opcode; // value ranges from 0 to 7 
  reg [2:0] a,b;
  reg [3:0] res;
  integer i = 0;
 
  always_comb
    begin
      case (opcode)  // but has only values from 0 to 5 , we got to ignore 6 ,7.
    0: res = a + b;
    1: res = a - b;
    2: res = a;
    3: res = b;
    4: res = a & b;
    5: res = a | b;
    default : res = 0;
  endcase
    end
  
  covergroup c;
    option.per_instance  = 1;
    
    coverpoint opcode {
    
      bins valid_opcode[] = {[0:5]};
      ignore_bins invalid_opcode[] = {6,7}; //illegal bins 6 and 7.
    
    }
    
    
    
  endgroup
  
 
  c ci;
 
  initial begin
     ci = new();
    
    
    
    for (i = 0; i <40; i++) begin
      a = $urandom();
      b = $urandom();
      opcode = $urandom();
      ci.sample();
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #400;
    $finish();
  end
  
 
 
 
 
endmodule
