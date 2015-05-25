module adder (result, a, b, clk, reset, enable); 
 
input [7:0] a; 
input [7:0] b; 
input clk; 
input reset; 
input enable; 
output [8:0] result; 
reg [8:0] result; 
 
  always @(posedge clk) 
  begin 
   if (reset)      result = 0; 
   else if (enable)      result = a + b; 
  end 
 endmodule 
 