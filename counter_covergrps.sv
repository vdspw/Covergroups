/* 8 bit counter with up and sown counting ability , contains load , load in bus to load a random value */

module counter_8 (
input clk, rst, up, load,
input [7:0] loadin,
output reg [7:0] y
);
 
always@(posedge clk)
begin
if(rst == 1'b1)
y <= 8'b00000000;
  
else if (load == 1'b1)
y <= loadin;
  
else begin
if(up == 1'b1)
 y <= y + 1;
 else
 y <= y - 1;
 end
end
  
endmodule


/* interface */

interface counter_8_intf();
logic clk,rst, up, load;
logic [7:0] loadin;
logic [7:0] y;
endinterface

////////////////////////////////////////////////////////////////////////////////////
/* TESTBENCH */

class transaction;    // sequence item in UVM 
  
  rand bit [7:0] loadin; // random value can be loaded on loadin bus
bit load;			     // load option to enable loading
bit rst;				 // reset -- brings y to 0
bit up;  				 // to enable up counting 
  bit [7:0] y;			 // outputs 
  
endclass
 
 
////////////////////////
class generator;   // sequencer 
  
  
transaction t;    // instance of the transaction 
mailbox mbx;      // mailbox intance mbx
event done;       // event done to stop or trigger activites in the TB
integer i;         // to run the loop for impulses
 
  
  function new(mailbox mbx);  // constructor 
this.mbx = mbx;
endfunction
 
  
  task run(); 
    t = new();  // alloting memory for transaction 
    for(i =0; i< 200; i++) begin
      t.randomize; // randmoize the transaction 
      mbx.put(t); // put the transaction on the mailbox
      $display("[GEN]: Data send to driver");
      @(done);  // trigger the event done
      end    
endtask
  
  
endclass
 
 
///////////////////////////////
class driver;
mailbox mbx; // instance of the mailbox
transaction t; // instance of the transaction 
event done;   // event
 
virtual counter_8_intf vif;   // virtual interface for DUT interface
 
  function new(mailbox mbx);  // contructor
this.mbx = mbx;
endfunction
 
 
task run();
t= new();
forever begin
  mbx.get(t); // get the transaction from the mailbox 
vif.loadin <= t.loadin; // load into the virutal interface ther by the DUT
$display("[DRV] : Trigger Interface");
@(posedge vif.clk);
  ->done; 
end
endtask
 
 
endclass
 
////////////////////////////////////////////
 
class monitor;   // contains covergrps 
virtual counter_8_intf vif;  // instance of virstual interface
mailbox mbx;   // instance of the mailbox 
transaction t; // instance of the transaction 
  
 ///////////adding coverage
  
  ///ld  rst  loaddin dout
  
  covergroup c ;
    option.per_instance = 1;  // for detailed report
    
    // transaction loadin bus div into ranges with explicit bins
      coverpoint t.loadin {
      bins lower = {[0:84]};
      bins mid = {[85:169]};
      bins high = {[170:255]};
    }
    
    
    
 	// coverpoint for reset with explicit bins for 0 and 1
    coverpoint t.rst {
      bins rst_low = {0};
      bins rst_high = {1};
    }
    
    // coverpoint for load with explicit bins for 0 and 1 
    coverpoint t.load {
      bins ld_low = {0};
      bins ld_high = {1};
    }
    
 
    // coverpoint for output with y (o/p) divided into ranges 
      coverpoint t.y {
      bins lower = {[0:84]};
      bins mid = {[85:169]};
      bins high = {[170:255]};
    }
    
    // load signal and loadin bus -- igonre cases when load is 0
    cross_ld_loadin : cross t.load, t.loadin 
    {
      ignore_bins unused_ld = binsof(t.load) intersect {0}; 
    }
    
    // rst and up ignore when rst is 1
     cross_rst_up : cross t.rst, t.up
    {
      ignore_bins unused_rst = binsof(t.rst) intersect {1};
    }
 
    // rst and output y ignore the rst 1
    cross_rst_y : cross t.rst, t.y
    {
      ignore_bins unused_rst = binsof(t.rst) intersect {1};
    }
 
  endgroup
  
   
  
  
 
function new(mailbox mbx);
this.mbx = mbx;
c = new();  
endfunction
  
  
 
task run();
t = new();
forever begin
t.loadin = vif.loadin; // create a new transaction item in the monitor 
t.y = vif.y;
t.rst = vif.rst;
t.up = vif.up;
t.load = vif.load;
  
  c.sample(); // calling the sample function 
  
mbx.put(t);
$display("[MON] : Data send to Scoreboard");
@(posedge vif.clk);
end
endtask
endclass  
 
///////////////////////////////////////////////////
 
class scoreboard;
mailbox mbx;
transaction t;
bit [7:0] temp; 
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task run();
t = new();
forever begin
  mbx.get(t);  // get the transactions 
end
endtask
endclass  
 
 
/////////////////////////////////////////////////
class environment;
generator gen;  // instances of gen , drv and sco, mon
driver drv;
monitor mon;
scoreboard sco;
 
virtual counter_8_intf vif; // virtual interface
 
mailbox gdmbx; // gen to drv mbx
mailbox msmbx; // mon to sb mbx
 
event gddone; 
 
  function new(mailbox gdmbx, mailbox msmbx); //constructor
this.gdmbx = gdmbx;
this.msmbx = msmbx;
 
gen = new(gdmbx);
drv = new(gdmbx);
 
mon = new(msmbx);
sco = new(msmbx);
endfunction
 
task run();
gen.done = gddone;
drv.done = gddone;
 
drv.vif = vif;
mon.vif = vif;
 
fork 
  gen.run(); //run phases of all components
drv.run();
mon.run();
sco.run();
join_any
 
endtask
 
endclass
 
/////////////////////////////////////
 
/* TESTBENCH */

class transaction;    // sequence item in UVM 
  
  rand bit [7:0] loadin; // random value can be loaded on loadin bus
bit load;			     // load option to enable loading
bit rst;				 // reset -- brings y to 0
bit up;  				 // to enable up counting 
  bit [7:0] y;			 // outputs 
  
endclass
 
 
////////////////////////

class generator;   // sequencer 
  
  
transaction t;    // instance of the transaction 
mailbox mbx;      // mailbox intance mbx
event done;       // event done to stop or trigger activites in the TB
integer i;         // to run the loop for impulses
 
  
  function new(mailbox mbx);  // constructor 
this.mbx = mbx;
endfunction
 
  
  task run(); 
    t = new();  // alloting memory for transaction 
    for(i =0; i< 200; i++) begin
      t.randomize; // randmoize the transaction 
      mbx.put(t); // put the transaction on the mailbox
      $display("[GEN]: Data send to driver");
      @(done);  // trigger the event done
      end    
endtask
  
  
endclass
 
 
///////////////////////////////
class driver;
mailbox mbx; // instance of the mailbox
transaction t; // instance of the transaction 
event done;   // event
 
virtual counter_8_intf vif;   // virtual interface for DUT interface
 
  function new(mailbox mbx);  // contructor
this.mbx = mbx;
endfunction
 
 
task run();
t= new();
forever begin
  mbx.get(t); // get the transaction from the mailbox 
vif.loadin <= t.loadin; // load into the virutal interface ther by the DUT
$display("[DRV] : Trigger Interface");
@(posedge vif.clk);
  ->done; 
end
endtask
 
 
endclass
 
////////////////////////////////////////////
class monitor;   // contains covergrps 
virtual counter_8_intf vif;  // instance of virstual interface
mailbox mbx;   // instance of the mailbox 
transaction t; // instance of the transaction 
  
 ///////////adding coverage
  
  ///ld  rst  loaddin dout
  
  covergroup c ;
    option.per_instance = 1;  // for detailed report
    
    // transaction loadin bus div into ranges with explicit bins
      coverpoint t.loadin {
      bins lower = {[0:84]};
      bins mid = {[85:169]};
      bins high = {[170:255]};
    }
    
    
    
 	// coverpoint for reset with explicit bins for 0 and 1
    coverpoint t.rst {
      bins rst_low = {0};
      bins rst_high = {1};
    }
    
    // coverpoint for load with explicit bins for 0 and 1 
    coverpoint t.load {
      bins ld_low = {0};
      bins ld_high = {1};
    }
    
 
    // coverpoint for output with y (o/p) divided into ranges 
      coverpoint t.y {
      bins lower = {[0:84]};
      bins mid = {[85:169]};
      bins high = {[170:255]};
    }
    
    // load signal and loadin bus -- igonre cases when load is 0
    cross_ld_loadin : cross t.load, t.loadin 
    {
      ignore_bins unused_ld = binsof(t.load) intersect {0}; 
    }
    
    // rst and up ignore when rst is 1
     cross_rst_up : cross t.rst, t.up
    {
      ignore_bins unused_rst = binsof(t.rst) intersect {1};
    }
 
    // rst and output y ignore the rst 1
    cross_rst_y : cross t.rst, t.y
    {
      ignore_bins unused_rst = binsof(t.rst) intersect {1};
    }
 
  endgroup
  
   
  
  
 
function new(mailbox mbx);
this.mbx = mbx;
c = new();  
endfunction
  
  
 
task run();
t = new();
forever begin
t.loadin = vif.loadin; // create a new transaction item in the monitor 
t.y = vif.y;
t.rst = vif.rst;
t.up = vif.up;
t.load = vif.load;
  
  c.sample(); // calling the sample function 
  
mbx.put(t);
$display("[MON] : Data send to Scoreboard");
@(posedge vif.clk);
end
endtask
endclass  
 
///////////////////////////////////////////////////
class scoreboard;
mailbox mbx;
transaction t;
bit [7:0] temp; 
 
function new(mailbox mbx);
this.mbx = mbx;
endfunction
 
task run();
t = new();
forever begin
  mbx.get(t);  // get the transactions 
end
endtask
endclass  
 
 
/////////////////////////////////////////////////
class environment;
generator gen;  // instances of gen , drv and sco, mon
driver drv;
monitor mon;
scoreboard sco;
 
virtual counter_8_intf vif; // virtual interface
 
mailbox gdmbx; // gen to drv mbx
mailbox msmbx; // mon to sb mbx
 
event gddone; 
 
  function new(mailbox gdmbx, mailbox msmbx); //constructor
this.gdmbx = gdmbx;
this.msmbx = msmbx;
 
gen = new(gdmbx);
drv = new(gdmbx);
 
mon = new(msmbx);
sco = new(msmbx);
endfunction
 
task run();
gen.done = gddone;
drv.done = gddone;
 
drv.vif = vif;
mon.vif = vif;
 
fork 
  gen.run(); //run phases of all components
drv.run();
mon.run();
sco.run();
join_any
 
endtask
 
endclass
 
/////////////////////////////////////
module tb();
 
environment env;
 
mailbox gdmbx;
mailbox msmbx;
 
counter_8_intf vif();
 
counter_8 dut ( vif.clk, vif.rst, vif.up, vif.load,  vif.loadin, vif.y );
 
always #5 vif.clk = ~vif.clk;
  
initial begin
 vif.clk = 0;
 vif.rst = 1;
 #50; 
 vif.rst = 0;  
end
 
initial begin
#60;
  repeat(20) begin
 vif.load = 1;
 #10;
  vif.load = 0;
 #100;
  end
end
  
 initial begin
#60;
  repeat(20) begin
  vif.up = 1;
 #70;
  vif.up = 0;
 #70;
  end
end 
 
initial begin
gdmbx = new();
msmbx = new();
env = new(gdmbx, msmbx);
env.vif = vif;
env.run();
#2000;
$finish;
end
  
initial begin
  $dumpfile("dump.vcd"); 
  $dumpvars;  
end
endmodule
