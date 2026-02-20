/* stimuls sampling for 2_1 MUX */

module mux (
  input a,b,
  input sel,
  output y
 
);
  
  assign y = (sel == 1'b1) ? b : a ;
  
  
endmodule
////////////////////////////////////////////////////////////////////
/*Create a stimulus for 2:1 mux to cover following behavior of design.
1) Cover all the possible values of sel line
2) Cover all the possible values of a,b
3) Cover all the possible values of y Prefer Sample method. */

module tb;
  
  reg a;
  reg b;
  reg sel;
  wire y;
  
  mux dut(.a(a),.b(b),.sel(sel),.y(y)); // instantiation
  
  covergroup c; 
    option.per_instance = 1;
    coverpoint a;
    coverpoint b;
    coverpoint sel;
  endgroup
  
  c ci= new();
  
  initial begin
    for(int i =0; i<20; i++) begin
   	 	a = $urandom();
    	b = $urandom();
    	sel = $urandom();
    	ci.sample(); // pre built sample method
        #10;
    end
  end
  
endmodule
