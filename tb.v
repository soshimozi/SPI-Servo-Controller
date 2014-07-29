// ============================================================================
// TESTBENCH FOR CPU CORE
// ============================================================================

module tb ();

reg clk;
wire [7:0] pwm;
reg sclk;
wire miso;
reg mosi;
reg c_en;


ServoController top (
  clk, 4'b1100, pwm, sclk, miso, mosi, c_en
);

initial begin
	clk = 0;
end

always clk = #10000 ~clk;

endmodule
