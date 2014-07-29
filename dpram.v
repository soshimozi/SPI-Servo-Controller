module dpram (
	data_a, data_b, addr_a, addr_b, we_a, we_b, clk,
	q_a, q_b);
	
	parameter addr_width = 8;
	parameter data_width = 16;

	input [data_width-1:0] data_a, data_b;
	input [addr_width-1:0] addr_a, addr_b;
	input we_a, we_b, clk;
	
	output reg [data_width-1:0] q_a, q_b;
	
	// delcare RAM variable
	reg [data_width-1:0] ram[(2^data_width) - 1:0];
	
	// port A
	always @ (posedge clk)
	begin
		if (we_a)
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else
		begin
			q_a <= ram[addr_a];
		end
	end
	
	// Port B
	always @ (posedge clk)
	begin
		if (we_b)
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else
		begin
			q_b <= ram[addr_b];
		end
	end
	
endmodule
	