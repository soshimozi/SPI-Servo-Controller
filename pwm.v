module PWM(clock_i, pos_i, pwm_o
	);
	
parameter wavelength = 900_000;
parameter offset = 50_000;
parameter sdm = 3125; // step multiplier
parameter sdd = 16;	// step divisor

input clock_i;
input [7:0] pos_i;

reg reset;

output pwm_o;
reg pwm_o;

reg [7:0] pos_latch;
reg [31:0] counter = 0;

always @ (posedge clock_i)
begin
	if (reset) pos_latch <= pos_i;
end

always @ (posedge clock_i)
begin
	counter <= counter + 1;
	if (counter <= ((pos_latch*sdm)/sdd) + offset) pwm_o <= 1;
	else pwm_o <= 0;
	if (counter >= wavelength) 
		begin
			counter <= 0;
			reset <= 1;
		end
	else reset <= 0;
end
endmodule
