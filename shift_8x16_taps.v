module shift_8x16_taps(clk, shift, shift_data, tap0, tap1);

input clk, shift;
input [7:0] shift_data;

output [7:0] tap0, tap1;


reg [7:0] sr [15:0];

integer n;

always@(posedge clk)
begin
	if(shift == 1'b1)
	begin
		for(n = 15; n>0; n = n-1)
		begin
			sr[n] <= sr[n-1];
		end
		
		sr[0] <= shift_data;
	end
end

assign tap0 = sr[0];
assign tap1 = sr[1];

endmodule
 