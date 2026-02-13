// Design of an FSM S0 and S1
/* transtions : SO-> rst -> S0 ; S0-> 1 -> S1 ; S1 -> 0 -> S1;
S1 -> 1 -> S0 (complete) */

module fsm 
  (
    input clk,
    input reset,
    input din,
    output reg dout
  );
  
  reg state, nstate;
  
  parameter s0 = 0, s1 =1;
  
  always@(posedge clk or posedge reset)
    if(reset)
      state <= s0;
  else
    state <= nstate;
  
  always@(state or din)
    begin
      case(state)
        s0:begin
          if(din)
            begin
              dout = 0;
              nstate = s1;
            end else begin
              nstate  = s0;
              dout = 1'b0;
            end
        end
        
        s1:begin
          if(din)begin
            nstate = s0;
            dout = 1'b1;
          end else
            begin
              dout = 1'b0;
              nstate = s1;
            end
          
        end
        
        default:begin
          nstate = s0;
          dout = 1'b0;
        end
        
      endcase
      
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Testbench with covergroups

module tb;
 
  reg clk = 0;
  reg reset = 0;
  reg din = 0;
  wire dout ;
  
  fsm dut (clk,reset,din,dout);
  
  always #5 clk = ~clk;
  
  initial begin 
    reset  =1;
    #30;
    reset = 0;
    #40;
    din = 1;
  end
  
 covergroup c;
   option.per_instance = 1; // for detailed reports
   coverpoint dut.state;         // creation of coverpoint 
 endgroup
  
  c cia; // instance creation 
  
  initial begin
    c cia = new();          // giving memory space
    forever begin
      @(posedge clk);
      cia.sample();			// manual sample function call
    end
    
  end
  
  
       
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #200;
    $finish();
  end
  
endmodule


