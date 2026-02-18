/* A 4 bit counter to demonstrate the use cases of wilcard bins (bins filtering) */

module counter_4(
input clk, en,
  output [3:0] dout 
);
  
  reg [3:0] temp = 0;
 
  always@(posedge clk)
    begin
      if(!en)
         temp <= 0;
      else
        temp <= temp + 1;
    end
  
assign dout = temp;  
  
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/* the bins are classified as per the ranges they are supposed to hold */
/* Ranges -> 0-3 ; 4-7 ;8-15. [ 3bins] .*/
module tb;
  
reg clk = 0, en = 0;
wire [3:0] dout;
  
counter_4 dut (clk,en, dout);
  
  always #5 clk = ~clk;
  
  initial begin
    en = 1;
    #200;
    en = 0;
    #200;
    en = 1;
  end
  
  covergroup c @(posedge clk);
    option.per_instance = 1;
    
// using the concatenation operator in the sensitivity list of the covergrp , where the MSB represents the "en" and remianinbits represent the "dout".
    coverpoint {en,dout} {
      
      bins count_off = {5'b00000};
      wildcard bins count_on_low = {5'b100??};// 0-3 --0-3
      wildcard bins count_on_mid = {5'b101??}; // 4-7 100 -111
      wildcard bins count_on_high = {5'b11???}; // 8-15 -- 1000 - 1111
 
    }
    
    
    
  endgroup
  
  c ci = new();
  
   
  
 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  #700;
  $finish();
  end
  
  
  
  
  
endmodule
