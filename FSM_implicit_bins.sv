// Design -- FSM


module fsm(
 input rst, din,clk,
  output reg dout
);
  parameter s0 = 0;
  parameter s1 = 1;
  parameter s2 = 2;
  
  reg [1:0] state = s0, next_state = s0;
  
  //////////////rst state decoding
  always@(posedge clk)
    begin
      if(rst) 
        state <= s0;
      else
        state <= next_state;
    end
  
 //////////// next state decoder and output logic decoder
  
  always@(state,din)
    begin
    case(state)
     s0: begin
       dout = 0;
       if(din)
         next_state = s1;
       else
         next_state = s0;
     end
      
     s1: begin
       dout = 0;
       if(din)
         next_state = s2;
       else
         next_state = s1;
     end
      
      s2: begin
        if(din) begin
         next_state = s0;
         dout = 1;
        end
       else begin
         next_state = s0;
         dout = 0;
       end
     end
      
 default: begin
   next_state = s0;
   dout = 0;  
 end
 endcase 
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// testbench for FSM.
/*Create implicit bins for din, rst, state variable, and dout. Generate stimulus to cover all the generated bins (100 % Coverage).*/

module tb;
 
  reg rst ;
  reg din ;
  reg clk = 0;
  wire dout ;
  
  fsm dut(.rst(rst),.clk(clk),.din(din),.dout(dout));
  
  always #5 clk = ~clk;
  
  initial begin
    rst = 1;
    #30;
    rst = 0;
    #40;
    din = 1;
    #10;
    din = 0;
    #10;
    din = 1;
    #10;
    din = 1;
    #40;
    din = 1;
  end
  
  covergroup c ;
    option.per_instance = 1; // for detailed reprt.
    
    coverpoint dut.din ;
    
    coverpoint dut.rst ;
    
    coverpoint dut.state ;
    
    coverpoint dut.dout;
    
  endgroup
 
  c cia;
  
  initial begin
    cia = new();
    forever begin
      @(posedge clk);
      cia.sample();
    end
    
    
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #5000;
    $finish();
  end
  
 
 
 
 
endmodule
