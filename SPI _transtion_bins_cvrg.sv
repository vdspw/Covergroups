/* SPI for transtion coverage */
/* state transtions :

(if start -0 ) back to IDLE
IDLE -> (start-1) -> INIT -> (Setup Dac  8'b 0000 0001) -> DATA GEN -> (din)-> SEND -> CONT ( if start - 0 go to IDLE else go to DATA GEN) . */

module dac(input clk,
input [11:0] din,
input start,
output reg mosi, cs
);
  
typedef enum {idle = 0, init = 1, send = 3, data_gen = 2, cont= 4} state_type;
state_type state;
 
reg [31:0] setup = 32'h08000001;
reg [31:0] dac_data = 32'h00000000;
integer count = 0;
 
always@(posedge clk)
begin
case(state)
  
idle: 
begin
cs <= 1'b1;
mosi <= 1'b0;
 
if(start)
state <= init;
else
state <= idle;
end
 
init:
begin
if(count < 32) begin
count <= count + 1;
mosi <= setup[31 - count];
cs <= 1'b0;
state <= init;
end
else begin
cs <= 1'b1;
count <= 0;
state <= data_gen;
end
 
end
 
data_gen: begin
dac_data <= {12'h030,din,8'h00};
state <= send;
end
 
send: begin
if(count < 32) begin
count <= count + 1;
mosi <= dac_data[31 - count];
cs <= 1'b0;
state <= send;
end
else begin
cs <= 1'b1;
count <= 0;
state <= cont;
end
end
 
cont: begin
if(start)
state <= data_gen;
else
state <= idle;
end
 
endcase
end
endmodule
//////////////////////////////////////////////////////////////////////////////////
/* SPI testbench for coverage */

/* scenarios for coverage :
1. come out of IDLE for once atleast . IDLE -> INIT
2. send complete data in INIT & SEND ( init [*33] ,send [*32] )
3. use Data send atleast once :
	init -> data gen -> send -> cont
4. start is de-asserted atleast once which should take the FSM to IDLE . */

module tb();
 
reg clk = 0, start = 0;
  reg [11:0] din;
  wire mosi;
  wire cs;
  integer i = 0;
  
 
 
dac dut (clk,din,start,mosi, cs);
 
always #5 clk = ~clk;
 
initial begin
  #20;
  start = 1;
  #1000;
  start = 0;
end
  
  initial begin
    for(i = 0; i< 200; i++) begin
      @(posedge clk);
      din = $urandom();
    end
  end
 
 
 
 
 
 
  covergroup c @(posedge clk);  // sampled on every positive edge of the clk 
    option.per_instance = 1;   // 
    coverpoint dut.state {
      
      bins out_of_idle = (dut.idle => dut.init); // transtion from IDLE to init
      
      bins setup_data_send = (dut.idle => dut.init[*33] => dut.data_gen);
      // from IDLE to INIT (stay for 33 clks 32 for data and 1 clk for ack ) after this it should transition to data gen state 
      
      bins user_data_send = (dut.data_gen => dut.send[*33] => dut.cont);
      // data gen to send data in 33 clks (32 for data 1 ack) and stay in cont 
      bins stay_send_33 = (dut.send[*33]);
      // if u have cont stay in send -- 33 clks data must be present
      bins stay_init_33 = (dut.init[*33]);
      // in  init 33 clks data must be present
      bins start_deassert = (dut.send => dut.cont => dut.idle);
      // if send becomes 0 the DUT should go to IDLE 
      
      
    }
    
    
  endgroup
 
  c ci; // instance of the covergroup
  
 
  
  initial begin
    ci = new();
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #2000;
    $finish();
  end
  
 
 
 
 
endmodule
