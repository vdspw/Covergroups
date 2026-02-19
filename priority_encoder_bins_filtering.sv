/* priority encoder for bins filetering */

module p_enc (
  input [4:0] pin, ////datain
  output reg [1:0] eout  ///encoded value
);
  
always_comb
  begin
    casez(pin)
      4'b0001: eout = 00;
      4'b001?: eout = 01;
      4'b01??: eout = 10;
      4'b1???: eout = 11;
      default: eout = 00;
    endcase
  end
  
  endmodule
///////////////////////////////////////////////////////////////////////////////////////
/*Create a stimulus for 100 % coverage of signal eout (output of the Priority Encoder) for all the possible combinations of the pin (Input to the Priority Encoder). Prefer Wildcard bins. */

module tb;
  
  reg[4:0] pin; // input DATA
  wire [1:0] eout; // output -encoded value
  
  integer i = 0; // for the loop -- generatation of values
  
  p_enc dut(.pin(pin),.eout(eout)); //instantiation
  
  covergroup c;
    option.per_instance = 1; //for detailed report
    
    coverpoint pin{
      bins zero ={4'b0001}; // the o/p is 0
      wildcard bins one = {4'b001?}; // the o/p is 1
      wildcard bins two = {4'b01??}; // the o/p is 2
      wildcard bins three = {4'b1???}; // the o/p is 3
    } // for all possible inputs
    
    coverpoint eout; // for the output
    
  endgroup
  
  
  c ci;//instance of the covergroup
  
  initial begin
    ci = new();
    for(i = 0; i<15; i++) begin 
      pin = $urandom();
      ci.sample();
      #10;  
    end
    
  end
  
  
  initial begin
  #3000;
  $finish();
  end
endmodule
