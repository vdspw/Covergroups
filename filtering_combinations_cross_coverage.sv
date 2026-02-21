/* filtering combinations in cross coverage */
/* for the memory scenario ,in the cross_coverage , we are segregating the cross coverage into 2 covergroups , first one being the write operation and second one being the read peration */

module tb;
 
  reg wr; // signal for write operation 
  reg [1:0] addr; // the address ranges from 00 01 10 11
  reg [3:0] din , dout; // data input LOW MID HIGH
  
  integer i = 0; // to run the loop , to generate inputs
 
 
 
  /////////////////////////////
  
  covergroup c_wr_1 ; // covergroup where the write operation is tracked , the write data which ranges from LOW to HIGH and the range in all memory locations.
    
     option.per_instance = 1; // for detailed report
    
    coverpoint wr {
      bins wr_high = {1}; //explicit bin for (wr) 
    }
   
   coverpoint  addr {
    
     bins addr_v[] = {0,1,2,3}; // bin for addr locations
   
   }
    
  coverpoint din {  
    bins low = {[0:3]}; //since we r writing its (din) , includes all 3 ranges
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
    
    cross wr, addr, din; // cross between write , addr and din.
    
  endgroup
  
  ///////////////////////////////
    covergroup c_wr_0; // covergroup for read operation to extract all ranges of data written in all memory locations
    
     option.per_instance = 1; // for detailed report
    
    coverpoint wr {
      bins wr_low = {0}; // explicit bin for read i.e wr=0
    }
   
   coverpoint  addr {
    
     bins addr_v[] = {0,1,2,3}; // bins for addrs
   
   }
    
  coverpoint dout {  
    bins low = {[0:3]}; // the data is being read from the memory so tracking the output
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
    
      cross wr, addr, dout; // cross between o/p, addr and read(wr=0)
    
  endgroup
  
  ///////////////////////////////////
  
 
  c_wr_1 c1; // instance for write cvrgrp
  c_wr_0 c2; // instance for read cvrgrp
  
 
  initial begin
    c1 = new();
    c2 = new();
    
    
    for (i = 0; i <100; i++) begin
      addr = $urandom();
      wr = $urandom();
      din = $urandom();
      dout = $urandom();
      c1.sample(); // calling the pre-built sample method
      c2.sample(); // calling the pre-built sample method
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
