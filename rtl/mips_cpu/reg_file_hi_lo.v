//`timescale 1ns/100ps

module reg_file_hi_lo(
    input logic clk,
    input logic reset,
    input logic clk_enable,

    input logic[31:0] LO_input,
    input logic[31:0] HI_input,
    input logic LO_write_enable,
    input logic HI_write_enable,

    output logic[31:0] LO_output,
    output logic[31:0] HI_output
);

	logic [31:0] LO_reg;
	logic [31:0] HI_reg;

	initial begin 
		LO_reg = 0;
		HI_reg = 0;
	end

	always @(posedge clk) begin
		if (clk_enable == 1) begin
			if(reset == 1) begin
				LO_reg <= 0;
				HI_reg <= 0;
			end
			else if (LO_write_enable == 1) begin
				LO_reg <= LO_input;
			end
			else if (HI_write_enable == 1) begin
				HI_reg <= HI_input;
			end
		end
	end

	always_comb begin
		LO_output = LO_reg;
		HI_output = HI_reg;
	end

endmodule

