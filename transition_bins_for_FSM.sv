/* FSM design -> for demonstration of transition bins */
/* state transition :
din = 0 ; S0 -> S0 , S1 -> S1
din = 1 ; S0 -> S1 , S1 -> S0 
*/
module fsm(input clk,din,rst,
             output reg dout
            );
 
  reg  state = 0,next_state = 0;
  parameter s0 = 0, s1 = 1;
  
  
  always@(posedge clk)
    begin
      if(rst)
        state <= s0;
      else
        state <= next_state;     
    end
  
always@(state,din)
begin
  case(state)
   s0: begin 
      dout = 1'b0;
     if(din == 1'b1)
       next_state = s1;
     else
       next_state = s0;
  end
    
  s1: begin  
    if(din == 1'b1)begin
       next_state = s0;
       dout = 1'b1;
    end
     else begin
       next_state = s1;
       dout = 1'b0;
     end
  end
default: begin 
  next_state = s0;
  dout       = 1'b0;
end
endcase
end  
 
    
endmodule
/////////////////////////////////////////////////////////////////////////////////////

/* Testbench */
module tb();
 
reg clk = 0, din = 0, rst = 0; // the inputs to the FSM
wire dout; // output
 
  fsm dut (clk,din,rst,dout); // instantiation
 
always #5 clk = ~clk; // clk generation 
 
 
 // impulse generation 
 
initial begin
  repeat(4) @(posedge clk) {rst,din} = 2'b10; // rst - 1 ,din -0
  repeat(4) @(posedge clk) {rst,din} = 2'b01; // rst - 0 ,din -1
  repeat(4) @(posedge clk) {rst,din} = 2'b10; // rst - 1 ,din -0
  repeat(1) @(posedge clk) {rst,din} = 2'b01; // rst - 0 ,din -1
  repeat(4) @(posedge clk) {rst,din} = 2'b00; // rst - 0 ,din -0
end
  
  
  
  // covergroup 1 -- tracks the scenarios with din is HIGH [ din -1].
 
  covergroup c1 @(posedge clk);
    
  option.per_instance = 1;
    
    // coverpoint RESET , with explicit bins to track RST -0 and RST -1.
    coverpoint rst {
      bins rst_l = {0};
      bins rst_h = {1};
    }
    // coverpoint Din , explicit bin din-high to keep track of  din -1 
    coverpoint din {
      bins din_h = {1};
    }
    
    // coverpoint Dout , explicit dout bins to track the output of the FSM
     coverpoint dout {
      bins dout_l = {0};
      bins dout_h = {1};
    }
 	
    // tracking the FSM operation only when din is 1 
    coverpoint dut.state iff (din == 1'b1) {
      
      bins trans_s0_S1 = (dut.s0 => dut.s1); // when din -1 , S0 to S1  
      bins trans_s1_S0 = (dut.s1 => dut.s0); // when din  -1, S1 to S0
      illegal_bins same_state = (dut.s0 => dut.s0, dut.s1 => dut.s1);
   	// the bins where din =0 are illegal in this cover group 
	// they represent the transitions S0 -> S0 and S1 -> S1.
    
    
    }
    
    // need to ignore the RESET high option 
    cross rst,din,dut.state
    {
      ignore_bins rst_high = binsof(rst) intersect{1}; // considering onlt RST -0 scenarios.  
    }
    
  endgroup
 
  
  // covergroup 2 -> tracks the scenarios with din is 0.
  covergroup c2 @(posedge clk);
      option.per_instance = 1;
    
    // coverpoint for DIN tracks only din -0
       coverpoint din {
      bins din_l = {0};
    }
    
    // when din -0 
    coverpoint dut.state iff (din == 1'b0) {
         
      bins trans_s0_S0 = (dut.s0 => dut.s0);  // covers s0 to s0     
      bins trans_s1_S1 = (dut.s1 => dut.s1);  // covers s1 to s1 
      illegal_bins diff_state = (dut.s0 => dut.s1, dut.s1 => dut.s0);
     
    }
    
    cross rst,din,dut.state {
      ignore_bins rst_high = binsof(rst) intersect{1};  // ignore the reset high scenario 
    }
    
  endgroup
 
 
  c1 ci; // instance of cvrgrp 1
  c2 ci2; // instance of cvrgrp 2
 
  
  
  
  
  initial begin
    ci = new();
    ci2 = new();
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #500;
    $finish();
  end
  
 
 
 
 
endmodule
