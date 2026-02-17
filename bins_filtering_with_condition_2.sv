/* Bins _WITH part 2*/

module tb;
 
  reg [2:0] a;
  reg [5:0] btemp; //btemp is a register to handle 6 bit data.
  integer i = 0;
  int b; //1:100 divisible by 5
 
 
  covergroup c;
    option.per_instance = 1;
    
    coverpoint b {
      bins zero = {0};
      bins bdiv5[] = {[1:100]} with (item % 5 == 0) ;  // range is specified .  
    }
   /* this has 1 to 100 range , contains all the numbers divisible by 5 */ 
 
  endgroup
  
  
  
 
  c ci;
 
  initial begin
     ci = new();
    
    
    
    for (i = 0; i <20; i++) begin
      btemp = $urandom(); //randomize --used for addressing the range or size
      /* if int is used it will generate 2^32 values */
      b = btemp; //assign this value on to "b".
      $display("Value of b : %0d",b);
      ci.sample();
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #200;
    $finish();
  end
  
 
 
 
 
endmodule
