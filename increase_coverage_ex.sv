/*We recieved coverage of 75% while working with Buffer. Modify testbench code to get 100% Coverage. Design and Testbench code is as follow:

*/

//////////////////////Design Code

module top
  (
    input  [1:0]  a,
    output [1:0]  b  
  );
  
assign b = a;
  
  
endmodule
//////////////Testbench Code



module tb;
 
  reg  [1:0]  a;
  wire [1:0]  b;
  integer i = 0;
  
  top dut (.a(a), .b(b));
  
  
  covergroup cvr_a ; ///// manual sample method
    option.per_instance = 1;
    
    coverpoint a; //// automaitc bins  
    
    coverpoint b;
  
  endgroup 
  
 
  cvr_a ci = new();
 
  
  initial begin
    
    
    for (i = 0; i <50; i++) begin
      a = $urandom();  
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


