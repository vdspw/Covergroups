// State machine -- RTL ( System verilog)

module state_mach(
  input rst,clk,
  input din,
  output logic dout);
  
  typedef enum {s0,s1} state_type;
  state_type state = s0; // initialized to s0
  state_type next_state = s0; // initialized to s0
  
  /// reset logic // //seq logic//
  always_ff@(posedge clk) begin
    if(rst == 1'b1)
      state <= s0;
    else
      state <= next_state;
  end
  
  //next state decoder logic // comb logic//
  always_comb begin
    case(state)
      s0: begin
        if(din == 1'b1)
          next_state = s1;
        else
          next_state = s0;
      end
      
      s1:begin
        if(din == 1'b1)
        next_state = s0;
        else
        next_state = s1;
      end
      
      default:next_state = s0;
    endcase
  end
  
  ///output logic //
  always_comb
    begin
      case(state)
        s0:dout = 1'b0;
        s1:dout = 1'b1;
        default :dout = 1'b0;
      endcase
    end
  
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// testbench for state machine
module tb;
 
  reg clk = 0;
  reg rst = 0;
  reg din = 0;
  wire dout ;
  
  state_mach dut(rst,clk,din,dout);
  
  always #5 clk = ~clk;
  
  initial begin
    rst = 1;
    #30;
    rst = 0;
    #40;
    din = 1;
  end
  
  covergroup c;
    option.per_instance = 1;
    coverpoint dut.state; // accesing the state variable present in the dut.
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
    #300;
    $finish();
  end
  
 
 
 
 
endmodule
  
  
  
