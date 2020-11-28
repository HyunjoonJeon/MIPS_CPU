module ALU(
	input logic[31:0] A,
	input logic[32:0] B,
	input logic[3:0] alu_control,
	input logic[3:0] branch_cond,
	output logic[31:0] alu_result,
	output logic Z,
	// output logic V,
	output logic C
	output logic branch_cond_true;
	);

	typedef enum logic[3:0] {
		CONTROL_ADD = 4'b0000,
		CONTROL_SUB = 4'b0001,
		CONTROL_AND = 4'b0010,
		CONTROL_OR = 4'b0011,
		CONTROL_XOR = 4'b0100,
		CONTROL_SLT = 4'b0101,
		CONTROL_SLTU = 4'b0110,
		CONTROL_SLL = 4'b0111,
		CONTROL_SRL = 4'b1000,
		CONTROL_SRA = 4'b1001,
		CONTROL_MULT = 4'b1010,
		CONTROL_MULTU = 4'b1011,
		CONTROL_DIV = 4'b1100,
		CONTROL_DIVU = 4'b1101,
		CONTROL_BRANCH = 4'b1110
	} control_t;

	logic[31:0] adder_B; // converted into negative if subtraction
	logic[31:0] bitwise_and;
	logic[31:0] bitwise_or;
	logic[31:0] bitwise_xor;
	logic[32:0] adder_result; // 1 extra bit to store the carry out
	logic[31:0] less_than_unsigned;
	logic[31:0] less_than_signed;
	logic[31:0] shift_left_logical;
	logic[31:0] shift_right_logical;
	logic[31:0] shift_right_arithmetic;

	assign bitwise_and = A & B;
	assign bitwise_or = A | B;
	assign bitwise_xor = A ^ B;
	assign less_than_unsigned = (A < B) ? 32'd1 : 32'd0;
	assign less_than_signed = $signed(A) < $signed(B) ? 32'd1 : 32'd0;
	assign adder_B = (alu_control == CONTROL_SUB) ? ~B+1 : B;
	assign adder_result = A + adder_B;
	assign shift_left_logical = A << B;
	assign shift_right_logical = A >> B;
	assign shift_right_arithmetic = A >>> B;

	always_comb begin
		case (alu_control)
			CONTROL_ADD: begin
				alu_result = adder_result[31:0];
			end
			CONTROL_SUB: begin
				alu_result = adder_result[31:0];
			end
			CONTROL_AND: begin
				alu_result = bitwise_and;
			end
			CONTROL_OR: begin
				alu_result = bitwise_or;
			end
			CONTROL_XOR: begin
				alu_result = bitwise_xor;
			end
			CONTROL_SLT: begin
				alu_result = less_than_signed;
			end
			CONTROL_SLTU: begin
				alu_result = less_than_unsigned;
			end
			CONTROL_SLL: begin
				alu_result = shift_left_logical;
			end
			CONTROL_SRL: begin
				alu_result = shift_right_logical;
			end
			CONTROL_SRA: begin
				alu_result = shift_right_arithmetic;
			end
			CONTROL_BRANCH: begin
				// no need to update the alu result
			end
		endcase

		case (branch_cond)
			3'b001: begin
				branch_cond_true = A == B ? 1'b1 : 1'b0;
			end
			3'b010: begin
				branch_cond_true = A != B ? 1'b1 : 1'b0;
			end
			3'b011: begin
				branch_cond_true = $signed(A) < 0 ? 1'b1: 1'b0;
			end
			3'b100: begin
				branch_cond_true = $signed(A) > 0 ? 1'b1: 1'b0;
			end
			3'b101: begin
				branch_cond_true = $signed(A) <= 0 ? 1'b1: 1'b0;
			end
			3'b110: begin
				branch_cond_true = $signed(A) >= 0 ? 1'b1: 1'b0;
			end
			default:
				branch_cond_true = 1'b0;
			end
		endcase

	end
	

	assign Z = (alu_result == 0) ? 1 : 0;
	/* assign V = (alu_control == CONTROL_ADD || alu_control == CONTROL_SUB) ? ((A[31] && adder_B[31] && !alu_result[31]) || (!A[31] && !adder_B[31] && alu_result[31])) : 0; */
	// The overflow flag V commented out as it is not required for this project
	assign C = (alu_control == CONTROL_ADD || alu_control == CONTROL_SUB) ? adder_result[32] : 0;

endmodule