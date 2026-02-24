/* bins filetering in cross coverage */
/* Scenario -> the (din) and (dout) are going to be divided into LOW, MID and HIGH range */
/* din -> must be covered only during the WRITE operation */
/* dout -> must be covered only during the READ operation */

module tb;
 
  reg wr; // write operation 
  reg [1:0] addr; // address 00 01 10 11
  reg [3:0] din , dout; // din enabled for write , dout enabled for read
  
  integer i = 0; // to run the loop for generation os stimulus
 
 
 covergroup c ;
   
    option.per_instance = 1; // for detailed report
   
    coverpoint wr {
      bins wr_low = {0}; //explicit bins for read
      bins wr_high = {1}; // explicit bins for write
    }
   
   coverpoint  addr {
    
     bins addr_v[] = {0,1,2,3}; // explicit bins for addrs
   
   }
   
  
   ///////////////////////////////
    /* for write operation */ /* coverpoint specifically for DIN -- write operation */
   coverpoint din { //wr = 1
    
      bins low = {[0:3]};
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
   /* for read operation */ /* coverpoint specifically for DOUT -- read operation */
   coverpoint dout { /// wr = 0
    
      bins low = {[0:3]};
      bins mid = {[4:11]};
      bins hig = {[12:15]};
    }
  
   ////////////////write operation // ignoring bins of read operation 
   cross wr,addr, din
   {
    ignore_bins wr_low_unused = binsof (wr) intersect {0};
   }
   
   //////////////read operation // ignoring bins of write operation 
   cross wr,addr, dout
   {
     ignore_bins wr_high_unused = binsof (wr) intersect {1}; 
   }
 
    
  endgroup
  
  ///////////////////ignore bins to remove from coverage calc
  //////////// bins to include coverage in computation
  
 
  c ci; // instance of the covergroup 
 
  initial begin
    ci = new(); // memory allocation of the instance
    
    
    
    for (i = 0; i <100; i++) begin // 100 samples of all the parameters inside 
      addr = $urandom();
      wr = $urandom();
      din = $urandom();
      dout = $urandom();
      ci.sample(); // manual calling of the pre-built sample method
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
