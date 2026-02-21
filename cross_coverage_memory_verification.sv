/* Verification of a memory with 4 memory location 00 01 10 11 , for cross coverage with (wr) signal and address, where the (din) is split into 3 sections namely 0-3(low), 4-11(mid), 12-15(high) */

module tb;
 
  reg wr; // when 1 write op else read op
  reg [1:0] addr; // ranges 00 01 10 11
  reg [3:0] din , dout; // 0-3 4-11 12-15
  
  integer i = 0; // to run the loop generating impulses
 
 
 covergroup c ;
   
    option.per_instance = 1; // for detailed report
   
   coverpoint wr { //coverpoint for (wr) signal with explicit bins for 0 and 1
      bins wr_low = {0};
      bins wr_high = {1};
    }
   
   coverpoint  addr { // coverpoint for addr
    
     bins addr_v[] = {0,1,2,3};  // array (automatic) 
   
   }
   
   cross wr, addr; // cross coverage between write signal & address
   ///////////////////////////////
    
   coverpoint din { // the din which is split in to 3 grps
    
     bins low = {[0:3]}; //LOW range
     bins mid = {[4:11]}; //MID range
     bins hig = {[12:15]}; // High range
    }
   
    coverpoint dout {
    // similar to din --whatever goes in comes out of the memory
      bins low = {[0:3]};
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
    
   cross wr,addr, din; //cross between wr, addr and input data
   
   cross wr,addr, dout; // cross covrg for wr, addr and outptu data
 
    
  endgroup
  
  
  
 
  c ci; // instance of the covergroup
 
  initial begin
    ci = new(); // memory allocation for the instance
    
    
    //generation of the impulses
    for (i = 0; i <100; i++) begin
      addr = $urandom();
      wr = $urandom();
      din = $urandom();
      dout = $urandom();
      ci.sample(); // calling the pre-built sample method
      #10;
    end
    
    
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #1000;
    $finish();
  end
  
 
 
 
 
endmodule
