//default bins -> to explicitly track the values which are not covered by other bins .

module tb;
  reg [3:0] a;  /// 0 -15
 
  
 
  integer i = 0;
  
  
  initial begin
    #100;
    $finish();    
  end
  
 covergroup c;
   
   option.per_instance = 1;
   coverpoint a {
     bins a_values[] = {[0:9]}; 
     bins a_unused = default;   // default bin--tracks everything other than 0 to 9 values.
   }
   
   
   
 endgroup
 
    
    
  
  
  
  
  
  initial begin
    c ci = new();
    for(i = 0; i < 30; i++) begin 
      a = $urandom();
      ci.sample();
    end 
  end
 
endmodule
