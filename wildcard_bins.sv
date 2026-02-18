/* priority enocoder to demonstrate the wilcard bins usage */

module penc(
  input [3:0]y,
  output reg [1:0] a
);
  
  always@(*)
  begin
   
  casez(y)
  4'b0001:a = 2'b00;
  4'b001?:a = 2'b01; // 0010 0011
  4'b01??:a = 2'b10; // 0100 0101 0110 0111
  4'b1???:a = 2'b11; // 1000 1001 1010 1011
 
  default:a = 2'bzz;
  endcase
 end
  
endmodule
/////////////////////////////////////////////////////////////////////////////////////////
/* Wilcard bins - best used in priority encoder */
/* these bins take in the values where the same input (multiple values) give the same output */
module tb;
  
  reg [3:0] y;
  wire [1:0] a;
  integer i = 0;
  
  penc dut (y,a);
  
  covergroup c;
    option.per_instance = 1;
    
    coverpoint y {
      bins zero = { 4'b0001};
      wildcard bins one =   {4'b001?}; //the values 0010 0011 fall in this bin
      wildcard bins two =   {4'b01??}; // the vlaues 0100 0101 0110 0111
      wildcard bins three = {4'b1???}; // the values 1000 1001 1010 1011 
    }
    
    coverpoint a; // this is for the output "a"
    
    
  endgroup
  
  c ci;
  
   
  
  initial begin
    ci = new();
    for(i = 0; i<15; i++) begin 
      y = $urandom();
      $display("value of y : %04b",y);
      ci.sample();
      #10;  
    end
    
  end
  
  
  initial begin
  #3000;
  $finish();
  end
  

  
endmodule
