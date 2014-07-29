module ServoController(clk_i, PWM, sclk, miso, mosi, c_en);

input clk_i;

output wire [7:0] PWM;
input sclk, mosi, c_en;
output wire miso;

parameter s_shift = 1'b0;		
parameter s_latch = 1'b1;	

parameter SERVO_COUNT = 8;

wire pwm_0, pwm_1, pwm_2, pwm_3, pwm_4, pwm_5, pwm_6, pwm_7;

wire shift_in;
wire [7:0] shift_data;

wire [7:0] regaddress;
wire [7:0] regdata;

wire pwmpos[SERVO_COUNT - 1:0];

wire write_en0, write_en1, write_en2, write_en3, write_en4, write_en5, write_en6, write_en7;

reg current_state = 1'b0;
reg next_state = 1'b0;

wire en[SERVO_COUNT-1:0];
wire controlen[SERVO_COUNT-1:0];

assign PWM = {pwmpos[7], pwmpos[6], pwmpos[5], pwmpos[4], pwmpos[3], pwmpos[2], pwmpos[1], pwmpos[0]};

assign en[0] = (current_state == s_latch && regaddress == 8'h0);
assign en[1] = (current_state == s_latch && regaddress == 8'h1);
assign en[2] = (current_state == s_latch && regaddress == 8'h2);
assign en[3] = (current_state == s_latch && regaddress == 8'h3);
assign en[4] = (current_state == s_latch && regaddress == 8'h4);
assign en[5] = (current_state == s_latch && regaddress == 8'h5);
assign en[6] = (current_state == s_latch && regaddress == 8'h6);
assign en[7] = (current_state == s_latch && regaddress == 8'h7);

assign controlen[0] = (current_state == s_latch && regaddress == 8'h8);
assign controlen[1] = (current_state == s_latch && regaddress == 8'h9);
assign controlen[2] = (current_state == s_latch && regaddress == 8'hA);
assign controlen[3] = (current_state == s_latch && regaddress == 8'hB);
assign controlen[4] = (current_state == s_latch && regaddress == 8'hC);
assign controlen[5] = (current_state == s_latch && regaddress == 8'hD);
assign controlen[6] = (current_state == s_latch && regaddress == 8'hE);
assign controlen[7] = (current_state == s_latch && regaddress == 8'hF);

wire [7:0] sdata[SERVO_COUNT-1:0];
wire [7:0] cdata[SERVO_COUNT-1:0];

always @(posedge clk_i)
begin
	if(shift_in) next_state <= next_state + 1'b1;
	current_state <= next_state;
end

genvar i;
generate
for(i=0; i<SERVO_COUNT; i=i+1) begin:data
	register #(8) register(
		.clk(clk_i),
		.in(regdata),
		.out(sdata[i]),
		.rst(1'b0),
		.wen(en[i])
		);	
end
endgenerate

genvar c;
generate
for(c=0; c<SERVO_COUNT; c=c+1) begin:control
	register #(8) register(
		.clk(clk_i),
		.in(regdata),
		.out(cdata[c]),
		.rst(1'b0),
		.wen(controlen[c])
		);	
end
endgenerate

generate
for(i=0; i<SERVO_COUNT; i=i+1) begin:pwmgen
	PWM #(1_000_000, 40_000, 4375, 16) PWMModule(
		.clock_i (clk_i),
		.pos_i (sdata[i]),
		.pwm_o (pwmpos[i])
	);
end
endgenerate

shift_8x16_taps address_datareg(
	.clk (clk_i),
	.shift(shift_in),
	.shift_data(shift_data),
	.tap0(regdata),
	.tap1(regaddress)
	);
	
SPI_slave spi(
	.clk (clk_i), 
	.SCK (sclk), 
	.MOSI (mosi), 
	.MISO (miso), 
	.SSEL (c_en), 
	.byte_received (shift_in), 
	.data (shift_data)
	);

//PWM #(250_000, 0, 12500, 1) PWM0(
//	.clock_i (clk_i),
//	.pos_i (sdata[0]),
//	.pwm_o (pwmpos[0])
//	);
//	
//
//PWM #(250_000, 0, 12500, 1) PWM1(
//	.clock_i (clk_i),
//	.pos_i (sdata[1]),
//	.pwm_o (pwmpos[1])
//	);
//
//PWM #(250_000, 0, 12500, 1) PWM2 (
//	.clock_i (clk_i),
//	.pos_i (sdata[2]),
//	.pwm_o (pwmpos[2])
//	);
//
//PWM #(250_000, 0, 12500, 1) PWM3(
//	.clock_i (clk_i),
//	.pos_i (sdata[3]),
//	.pwm_o (pwmpos[3])
//	);
//
//PWM #(250_000, 0, 12500, 1) PWM4(
//	.clock_i (clk_i),
//	.pos_i (sdata[4]),
//	.pwm_o (pwmpos[4])
//	);
//
//PWM #(250_000, 0, 12500, 1) PWM5(
//	.clock_i (clk_i),
//	.pos_i (sdata[5]),
//	.pwm_o (pwmpos[5])
//	);
//
//	
//PWM #(250_000, 0, 12500, 1) PWM6(
//	.clock_i (clk_i),
//	.pos_i (sdata[6]),
//	.pwm_o (pwmpos[6])
//	);
//
//PWM #(250_000, 0, 12500, 1) PWM7(
//	.clock_i (clk_i),
//	.pos_i (sdata[7]),
//	.pwm_o (pwmpos[7])
//	);

endmodule
