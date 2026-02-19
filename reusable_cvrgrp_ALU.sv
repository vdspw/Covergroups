/* ALU example for re-usable covergroups */
/* Overview: The ALU perfroms 2 kinds of operations -> Arithmetic & Logical.
The inputs are 4 bit wide -> they have the same behaviour (covrgrp can be re-used).
*/

module alu
  (
    input [3:0] a,b,
    input [2:0] op,
    output reg [4:0] y
  
  );  
  
  always @(*)
    begin
      case(op)
        ///////////////arithmetic oper
        3'b000: y = a + b;
        3'b001: y = a - b;
        3'b010: y = a + 1;
        3'b011: y = b + 1;
        /////////////// logical oper
        3'b100: y = a & b;
        3'b101: y = a | b;
        3'b110: y = a ^ b;
        3'b111: y = ~a;
        
        default : y = 5'b00000;
      endcase
      
    end
endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////
/* testbench with resuable cvrgrps to verify the coverage */
/* the varaibles A and B are tracked by one type of covergrp -1 , similary the opcodes are tracked by covergrp -2 */

module tb;
 
  reg [3:0] a,b;
  reg [2:0] op;
  wire [4:0] y;
  
 
  integer i = 0; // to run the loop
  
  ////////////// covergrop for verifying ranges of input and output
  //-------------------------varn -placeholder for a or b 
  //------------------------string var_id (passed by value).
  //-------------------------ranges --passed by values --user fed.
  covergroup c_var (ref reg [3:0] varn,input string var_id, input int low, input int mid, input int high);
    option.per_instance = 1;
    option.name = var_id;
    
    coverpoint varn
    {
      bins lower_value = {[0:low]};
      bins mid_value =   {[low+1 : mid]};
      bins high_value =  {[mid+1 : high]};
    
    
    }
    
  endgroup 
  
  /////////////////covergroup for verifying all the possible values from different categories
  
    
  covergroup c_op (ref reg [2:0] varn,input string var_id, input int low, input int high);
    option.per_instance = 1;
    option.name = var_id;
    
   coverpoint varn
    {
      bins op_type[] = {[low:high]};
    }
    
  endgroup 
  
  //////////////////////////////////////////
  // covergrp NAME || INSTANCE || new(allotment in mem) || parameters to be passed.
  c_var cia = new(a, "Input data bus a", 3, 10, 15); //for variable "a"
  c_var cib = new(b, "Input data bus b", 3, 10, 15); //for variable "b"
  c_op  ciar = new(op, "Arithmetic Oper", 0,3); // for arithmetic opr [range from 0 - 3]
  c_op  cilo = new(op, "Logical Oper", 4,7);//for logical ops [range 4 - 7]
  
  initial begin 
    
    for (i = 0; i <50; i++) begin
      a = $urandom();
      b = $urandom();
      op = $urandom();
      cia.sample(); // calaing the sample method to every instance.
      cib.sample();
      ciar.sample();
      cilo.sample();
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
