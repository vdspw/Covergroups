/* User defined Sample methods -- for covergroups */

module tb;
   
  reg rd,wr,en;
  
  reg [1:0] din;
  integer i = 0;
  
  // these are the operation states 
  typedef enum {write, read, NOP,error} opstate;
  opstate o1,o2;
  
  // detection of the state the arguments the read signal value , enable and write -- since we have to identify the configurations and operating states. 
  
  function opstate detect_state (input rd, wr, en);
    if(en == 0)
       return NOP;
    else if (en == 1 && wr == 1 && rd == 0)
       return write;
    else if (en == 1 && rd == 1 && wr == 0)
        return read;
    else 
       return error;  
  endfunction
  
  //decoding the state 
 
  function bit [1:0] decode_state (input opstate oin);
    if(oin == NOP )
      return 2'b00;
    else if (oin == write)
      return 2'b01;
    else if (oin == read)
      return 2'b10;
    else if (oin == error)
       return 2'b11; 
  endfunction
 
  //check the states and sampling function call

  function check_cover (input rd , wr,en);
    o1 = detect_state(rd,wr,en);
    din = decode_state (o1);
    ci.sample(o1); // o1 is being passed to the sample
  endfunction
  
  
  
  covergroup c with function sample (input opstate cin);
    option.per_instance = 1;
    coverpoint cin;
    
  endgroup
 
  c ci;
 
  initial begin
     ci = new();
    
    
    
    for (i = 0; i <40; i++) begin
      wr = $urandom();
      rd = $urandom();
      en = $urandom();
      check_cover(rd,wr,en); // function to check is called after generating samples
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #400;
    $finish();
  end
  
 
 
 
 
endmodule
