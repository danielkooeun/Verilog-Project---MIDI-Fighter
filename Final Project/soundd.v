module soundd (CLOCK_50, reset, play, sound, done);
	input CLOCK_50;
	input reset;
	input play;
	output [4:0] sound;
	output reg done;

	reg [11:0] counter;
	reg [11:0] address;
	reg start;

	localparam	final = 12'b100000000000;

	// Counter for extracting audio data
	always @(posedge CLOCK_50) begin
		if (play)
			start <= 1;
	
		if (reset) begin
			counter <= 0;
			address <= 0;
			done <= 0;
			start <= 0;
		end

		else if (done & start) begin
			counter <= 0;
			address <= 0;
			done <= 0;
			start <= 0;
		end

		else if (counter == 12'b100000100100 & start) begin
			counter <= 0;

			if (address != final)
				address <= address + 1;

			else
				done <= 1;

		end

		else if (start)
			counter <= counter + 1;

	end

	d d_inst (
	.address ( address ),
	.clock ( CLOCK_50 ),
	.q ( sound )	// Add 20 - 23 0s at the end
	);

endmodule
