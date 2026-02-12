// Explicit bins

module tb;
 
  reg  [1:0]  a; /// 00 01 10 11
 
covergroup cvr_a ;
  
    option.per_instance = 1;
    
    
  coverpoint a {
    //   bins zero = {0};  // holds the value 0
    //   bins one  = {1};	//holds the value 1
    //   bins two  = {2};  // holds the value 2
    //   bins three = {3}; // holds the value 3
    
    //  bins bin0 = {0,1};  // {[0:1]} // range operator is used anything from 0 to 3 is kept track of.
  //  bins bin1 = {[2:3]}; // {2,3}
    
    bins bina = {[0:3]}; // name of the bin is "bina" keeps track of 0-3 values.
  
  } 
    
 endgroup 
  
 
  cvr_a ci = new();
 
  
  initial begin
    
    
    for (int i = 0; i < 5; i++) begin
      a = $urandom(); 
      ci.sample();
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #500;
    $finish();
  end
 
endmodule
