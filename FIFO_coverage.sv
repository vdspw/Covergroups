/* FIFO design for covergroups */

module FIFO(input clk, rst, wr, rd, 
            input [7:0] din,output reg [7:0] dout,
            output  empty, full);
  
  reg [3:0] wptr = 0,rptr = 0;
  reg [4:0] cnt = 0;
  reg [7:0] mem [15:0];
  
  always@(posedge clk)
    begin
      if(rst== 1'b1)
         begin
           wptr <= 0;
           rptr <= 0;
           cnt  <= 0;
         end
      else if(wr && !full)
          begin
            mem[wptr] <= din;
            wptr      <= wptr + 1;
            cnt       <= cnt + 1;
            end
      else if (rd && !empty)
         begin
          dout <= mem[rptr];
          rptr <= rptr + 1;
          cnt  <= cnt  - 1;
          end
        end 
 
  
  
  
  assign empty = (cnt == 0)    ? 1'b1 : 1'b0;
  assign full  = (cnt == 16)   ? 1'b1 : 1'b0;
  
endmodule

////////////////////////////////////////////////////////////////////////////////////
/* FIFO coverage */

module tb;
  reg clk = 0; // inputs with reg
  reg wr = 0;
  reg rd = 0;
  reg rst = 0;
  reg [7:0] din = 0;
  wire [7:0] dout;  // outputs with wire
  wire empty, full;
  
  FIFO dut (clk,rst,wr,rd,din,dout,empty,full); // instantiation 
  
  always #5 clk = ~clk; // clk generation 
  
 
  integer i = 0; // to run the for loop 
  
  task write(); // task to write 
    for(i = 0; i < 20; i++) begin  
    wr = 1'b1;
    rd = 1'b0;
    din = $urandom();
      @(posedge clk);  // for safe simulation 
    $display("wr: %0d, addr : %0d, din : %0d full:%0d", wr, i, din, full);
      wr = 0;            // making wr to go to 0 at the end 
    @(posedge clk);
    
   end  
  endtask
  
  task read();  // task to read 
    for(i = 0; i < 20; i++) begin   
    wr = 1'b0;
    rd = 1'b1;
    din = 0;
    @(posedge clk);
    rd = 1'b0;
    @(posedge clk);
    $display("rd: %0d, addr : %0d, dout : %0d empty : %0d", rd, i, dout,empty);
   end  
  endtask
  
  
  
  
initial begin
rst = 1;
wr = 0;
rd = 0;
repeat(5) @(posedge clk);
rst = 0;
write();
read();
end
  
  /////////////////////////////////////
  covergroup c @(posedge clk);
   
  option.per_instance = 1;
    
   coverpoint empty {
     bins empty_l = {0};  // explicit bins for 0 and 1
     bins empty_h = {1};
   }
   
      coverpoint full {
        bins full_l = {0}; // explicit bins for 0 and 1
     bins full_h = {1};
   }
  
     coverpoint rst {
       bins rst_l = {0}; // explicit bins for 0 and 1 
     bins rst_h = {1};
   }
  
      coverpoint wr {
        bins wr_l = {0}; //explicit bins for 0 and 1 
     bins wr_h = {1};
   }
  
  
     coverpoint rd {
     bins rd_l = {0};//explicit bins for 0 and 1 
     bins rd_h = {1};
   }
  
    coverpoint din  // making ranges of Din and dout
   {
     bins lower = {[0:84]};
     bins mid = {[85:169]};
     bins high = {[170:255]};
   }
   
     coverpoint dout
   {
     bins lower = {[0:84]};
     bins mid = {[85:169]};
     bins high = {[170:255]};
   }
  
    // wr and rst ignonig the cases where wr = 0 and rst - 1
    cross_rst_wr: cross rst, wr
    {
     ignore_bins unused_rst = binsof(rst) intersect {1};
      ignore_bins unused_wr = binsof(wr) intersect {0};
    }
    
    // rd and rst ignoring the cases where rd = 0 and rst  =1
    cross_rst_rd: cross rst, rd
    {
     ignore_bins unused_rst = binsof(rst) intersect {1};
      ignore_bins unused_rd = binsof(rd) intersect {0};
    }
    
    
  cross_Wr_din: cross rst,wr,din // cross cvrg rst ,wr,din
   {
     ignore_bins unused_rst = binsof(rst) intersect {1}; // ignoring rst 1
     ignore_bins unused_wr = binsof(wr) intersect {0};  // ignoring wr - 0
   }
  
   cross_rd_dout: cross rst,rd,dout // cross cvrg rst ,rd,dout
   {
     ignore_bins unused_rst = binsof(rst) intersect {1}; // ignoring rst 1
     ignore_bins unused_rd = binsof(rd) intersect {0}; // ignoring rd -0
   }
    
   cross_wr_full: cross rst,wr,full  // cross rst,er and full
   {
     ignore_bins unused_rst = binsof(rst) intersect {1}; // ignoring rst -1 
     ignore_bins unused_wr   = binsof(wr) intersect {0}; // ignoring wr - 0
     ignore_bins unused_full = binsof(full) intersect {0}; // ignoring full 0
   }
          
   cross_rd_empty: cross rst,rd,empty  // cross rst , rd ,empty
   {
     ignore_bins unused_rst = binsof(rst) intersect {1}; // ignore rst -1
     ignore_bins unused_rd    = binsof(rd) intersect {0}; // ignore rd -0
     ignore_bins unused_empty = binsof(empty) intersect {0}; // ignore empty 0
   }
      
    
  
 endgroup
  
  c ci = new();
  
  
  
  /////////////////////////////
  
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1200;
    $finish();
end
endmodule
