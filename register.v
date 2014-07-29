module register (out, in, wen, rst, clk);
  parameter n = 1;

  output [n-1:0] out;
  input [n-1:0] in;
  input wen;
  input rst;
  input clk;

  reg [n-1:0] out;

  always @(posedge clk) 
    begin 
      if (rst) 
        out = 0; 
      else if (wen) 
        out = in; 
    end 
endmodule
