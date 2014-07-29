module shift_8x64_taps(clk, shift, shift_data, tap0, tap1, tap2, tap3, tap4, tap5, tap6, tap7);

input clk, shift;
input [7:0] shift_data;

output [7:0] tap0, tap1, tap2, tap3, tap4, tap5, tap6, tap7;


reg [7:0] sr [63:0];

integer n;

always@(posedge clk)
begin
	if(shift == 1'b1)
	begin
		for(n = 63; n>0; n = n-1)
		begin
			sr[n] <= sr[n-1];
		end
		
		sr[0] <= shift_data;
	end
end

assign tap0 = sr[0];
assign tap1 = sr[1];
assign tap2 = sr[2];
assign tap3 = sr[3];
assign tap4 = sr[4];
assign tap5 = sr[5];
assign tap6 = sr[6];
assign tap7 = sr[7];

endmodule
