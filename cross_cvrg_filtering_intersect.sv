/* filtering combinations in cross coverage */
/* for the memory scenario ,in the cross_coverage , we are segregating the cross coverage into 2 covergroups , first one being the write operation and second one being the read peration */

/* we are getting overlaps while using the above appraoch , so a filtering method using intersect is going to help to segregate (wr=0) operations. */
/* the overlap was with the address */

module tb;
 
  reg wr; // when HIGH its (wr) when LOW its (rd)
  reg [1:0] addr; // ranges 00 01 10 11
 
  
  integer i = 0; // to run the loop
 
 
 covergroup c ;
   
    option.per_instance = 1; // detailed report
   
    coverpoint wr {
      bins wr_low = {0};  //explicit bin for rd
      bins wr_high = {1}; // explicit bin for wr
    }
   
   coverpoint  addr {
    
     bins addr_v[] = {0,1,2,3}; 
   
   }
   
  
   //cross wr, addr; // cross between wr and addr , where we want the cases with wr=0 (read) to fall in wr_low_unused bin and filter that in our coverage report.
   cross wr,addr
   {
     
    ignore_bins wr_low_unused = binsof (wr) intersect {0};
     
   }
 
    
  endgroup
  
  ///////////////////ignore bins to remove from coverage calc
  //////////// bins to include coverage in computation
  
 
  c ci;
 
  initial begin
    ci = new();
    
    
    
    for (i = 0; i <100; i++) begin
      addr = $urandom();
      wr = $urandom();
      ci.sample();
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
