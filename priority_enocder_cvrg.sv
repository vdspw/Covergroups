/* 8 bit priority encoder */

module penc(
  input [7:0]y,
  output reg [2:0] a
);
  
  always@(y)
  begin
    casez(y)
 
  8'b00000001:a = 3'b000;
  8'b0000001?:a = 3'b001;
  8'b000001??:a = 3'b010;
  8'b00001???:a = 3'b011;
  8'b0001????:a = 3'b100;
  8'b001?????:a = 3'b101;
  8'b01??????:a = 3'b110;
  8'b1???????:a = 3'b111;
 
  default:a = 3'bzzz;
  endcase
 end
  
endmodule

////////////////////////////////////////////////////////////////////////////////////////
/* coverage analysis for 8 bit priority encoder */
/* since it has priorty inloved dont care symbols are going to be used (?) so we need to make use of WILDCARD BINS */

module tb;
  
  reg [7:0] y;  // input 8 bit 
  wire [2:0] a; // output 
  integer i = 0;  // to run the loop
  
 // covergroup 
  covergroup c;
    option.per_instance = 1;  // for detailed report
    coverpoint y {
      bins zero = { 8'b00000001}; // explicit bins in y --for zero
      wildcard bins one =   {8'b0000001?}; // explicit wildcard bins for cvrg-
      wildcard bins two =   {8'b000001??}; //-since we have dont care [?]
      wildcard bins three = {8'b00001???};
      wildcard bins four =  {8'b0001????};
      wildcard bins five =  {8'b001?????};
      wildcard bins six =   {8'b01??????};
      wildcard bins seven = {8'b1???????};
    
    }
    
    coverpoint a; // imlplict bins -- created by the simulator
    
    
  endgroup
  
  c ci; // insttance of the covergrp
  
  penc dut (y,a);  //instantiation 
  
  initial begin
    ci = new();
    for(i = 0; i<300; i++) begin 
      y = $urandom();
      ci.sample(); // manual calling of the function
      #10;  
    end
    
  end
  
  
  initial begin
  #3000;
  $finish();
  end

  
endmodule
