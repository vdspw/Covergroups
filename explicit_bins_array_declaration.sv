// Explicit bins
// this can be also written as bina[] = {0,1,2,3}; this creates just 4 elemets as per the size of the varaible.
// the size can also be specified -> bins bina[64] = {[0:127]};
module tb;
 
  reg  [6:0]  a; // value ranges fro 0 -127
 
covergroup cvr_a ;
  
    option.per_instance = 1;
    
    
  coverpoint a {
    //   bins zero = {0};  // holds the value 0
    //   bins one  = {1};	//holds the value 1
    //   bins two  = {2};  // holds the value 2
    //   bins three = {3}; // holds the value 3
    
    //  bins bin0 = {0,1};  // {[0:1]} // range operator is used anything from 0 to 3 is kept track of.
  //  bins bin1 = {[2:3]}; // {2,3}
    
   // bins bina = {[0:3]}; // name of the bin is "bina" keeps track of 0-3 values.
    bins bina[64] = {[0:127]}; // array of size 64, each elemet of array handles 2 values .
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
