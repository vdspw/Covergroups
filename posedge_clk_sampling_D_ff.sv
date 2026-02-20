/* D-ff --covergroups using posedge clk sampling */

module dff (
input clk,rst,din,
output reg dout  
);
  
  always_ff@(posedge clk)
    begin
      if(rst)
        dout <= 0;
      else
        dout <= din; 
    end
  
  endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////
/*Create a stimulus for D-Flipflop to cover following behavior of design.
1) Cover all the possible values of rst
2) Cover all the possible values of din
3) Cover all the possible values of dout Prefer Posedge of Clock as event
*/

module tb;
  
  reg clk = 0;// initialized to 0
  reg rst,din; //both are 1 bit signals with similar behaviour
  
  wire dout; // for the output
  
  reg dout_sample;
  
  always #5 clk = ~clk; // keeping the clk active and running

  always @(posedge clk) dout_sample <= dout; // sampling dout to a reg

  covergroup c (ref reg rst_r, ref reg din_r,ref reg dout_sample_r)@(posedge clk);
    option.per_instance = 1;
    
    coverpoint rst_r;
    coverpoint din_r;
    coverpoint dout_sample_r; // using the reg for coverage
    
  endgroup
  
  c ci = new(rst,din,dout_sample);
  
  //generating inputs for the DUT.
  initial begin
    // Apply reset first to initialize the flop
    rst = 1;
    din = 0;
    @(posedge clk); // align to clock edge
    
    // Randomize inputs for 20 cycles, sampling happens on posedge automatically
    for (int i = 0; i < 20; i++) begin
      @(posedge clk);         // drive inputs after posedge
      #1;                      // small delay to avoid race condition
      rst = $urandom();
      din = $urandom();
    end
    
    // Wait a few extra cycles to capture final dout transitions
    repeat(3) @(posedge clk);
    $finish;
  end
endmodule
