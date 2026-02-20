/* User defined Sample methods -- for covergroups */
/* writng the sample method in the property and using an assertion */

module tb;
   
  reg rd = 0,wr = 0; // read and write pointers -- initialized to 0
  reg clk = 0;       // clk initialized to zero
  reg [4:0] addr;  
  reg [7:0] din;
  reg [7:0] dout;
  
  always #5 clk = ~clk;

  // the argumanet passed to the covergroup is 5 bit addr
  covergroup c with function sample (reg [4:0] addrin);
    option.per_instance = 1;
    coverpoint addrin{
      bins lower = {[0:7]};  // values 0 -7 out of 31
      bins mid = {[15:20]};  // vaules 15 -20 out of 31
      bins high = {[27:31]}; // values 27 - 31 out of 31
    }
    
  endgroup
 
  c ci;  // instance of the covergroup
 
  initial begin
    ci = new(); // allotment of the memory using new-function
    
    @(posedge clk);
    addr = 3;  // addr 3 for lower range testing 
    wr = 1;    // write op is being performed
    rd = 0;    // rd is off
    din = 12;  // the data written 
    @(posedge clk); // next clk tick
    wr = 0;    // write id off
    rd = 1;    // read operation is being performed
    addr = 3;  // the same addr where data was written in the prev clk tick
    dout = 12; // the same data which was written in the prev clk tick -12
    @(posedge clk);
    addr = 17;  // similar write operation 
    wr = 1;
    rd = 0;
    din = 21;
    @(posedge clk);
    wr = 0;	   // similar read operation 
    rd = 1;
    addr = 17;
    dout = 21;
    @(posedge clk);
    addr = 28;  // write operation 
    wr = 1;
    rd = 0;
    din = 67;
    @(posedge clk);
    wr = 0;   // read operation 
    rd = 1;
    addr = 28;
    dout = 67;
    
    
  end
  
  
  
  // property where the sample method is defined 
 property p1;
   bit [4:0] addrs; // local variable to store the addr
   bit [7:0] dvar;  // local variable to store the data in and out
   // on every positive edge of the clk , whenver (wr) is high on the same clk edge (wr) is high , store the addr in addrs , store din in local varaible in dvar , now sample (addrs) , calling the sample function (addrs)  

   // then within 1- 50 cycles , (rd) should be high and (addrs) should match and output data must match the stored data.
   @(posedge clk) ( wr |-> (wr, addrs = addr, dvar = din, ci.sample(addrs)) ##[1:50] rd[*1:50] ##0 (addrs == addr) ##0 (dout == dvar) );
  endproperty
  
  A1: assert property ( p1) $info("Suc at %0t",$time);
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0); 
    #500;
    $finish();
  end
  
 
 
 
 
endmodule
