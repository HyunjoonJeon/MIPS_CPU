//`timescale 1ns/100ps

module ALU(
	input logic[31:0] A,
	input logic[31:0] B,
	input logic[4:0] alu_control,
	input logic[2:0] branch_cond,
	input logic[31:0] LO_input,
	input logic[31:0] HI_input,
	input logic[4:0] sa,
	output logic[31:0] alu_result,
	// output logic Z,
	// output logic V,
	// output logic C,
	output logic branch_cond_true,
	output logic[31:0] LO_output,
	output logic[31:0] HI_output,
	output logic[1:0] byte_offset
	);

	typedef enum logic[4:0] {
		CONTROL_ADD = 5'b00000,
		CONTROL_SUB = 5'b00001,
		CONTROL_AND = 5'b00010,
		CONTROL_ANDI = 5'b00011,
		CONTROL_OR = 5'b00100,
		CONTROL_ORI = 5'b00101,
		CONTROL_XOR = 5'b00110,
		CONTROL_XORI = 5'b00111,
		CONTROL_SLT = 5'b01000,
		CONTROL_SLTU = 5'b01001,
		CONTROL_SLL = 5'b01010,
		CONTROL_SLLV = 5'b01011,
		CONTROL_SRL = 5'b01100,
		CONTROL_SRLV = 5'b01101,
		CONTROL_SRA = 5'b01110,
		CONTROL_SRAV = 5'b01111,
		CONTROL_MULT = 5'b10000,
		CONTROL_MULTU = 5'b10001,
		CONTROL_DIV = 5'b10010,
		CONTROL_DIVU = 5'b10011,
		CONTROL_LUI = 5'b10100,
		CONTROL_MTLO = 5'b10101,
		CONTROL_MTHI = 5'b10110,
		CONTROL_LWLR = 5'b10111
	} control_t;

	typedef enum logic[2:0] {
		BRANCH_NOTHING = 3'b000,
		BRANCH_EQUAL = 3'b001,
		BRANCH_NOT_EQUAL = 3'b010,
		BRANCH_LTZ = 3'b011,
		BRANCH_GTZ = 3'b100,
		BRANCH_LTEZ = 3'b101,
		BRANCH_GTEZ = 3'b110
	} branch_cond_t;

	wire[31:0] adder_B; // converted into negative if subtraction
	wire[31:0] bitwise_and;
	wire[31:0] bitwise_or;
	wire[31:0] bitwise_xor;
	wire[31:0] adder_result;
	wire[31:0] less_than_unsigned;
	wire[31:0] less_than_signed;
	wire[31:0] shift_left_logical;
	wire[31:0] shift_right_logical;
	wire[31:0] shift_right_arithmetic;
	wire unsigned [63:0] unsigned_product;
	wire [31:0] product_hi;
	wire [31:0] product_lo;
	wire signed [63:0] signed_product;
	wire [31:0] quotient; // register LO
	wire [31:0] remainder; // register HI
	wire [31:0] immediate_zero_extend; // zero extend the immediate for logical operations
	wire [31:0] lwlr_addr;

	initial begin // initialise all values to zero
		alu_result = 32'd0;
		branch_cond_true = 1'd0;
		LO_output = 32'd0;
		HI_output = 32'd0;
	end

	assign immediate_zero_extend = {16'd0,B[15:0]};
	assign bitwise_and = (alu_control == CONTROL_ANDI) ? A & immediate_zero_extend : A & B;
	assign bitwise_or = (alu_control == CONTROL_ORI) ? A & immediate_zero_extend : A | B;
	assign bitwise_xor = (alu_control == CONTROL_XORI) ? A ^ immediate_zero_extend : A ^ B;
	assign less_than_unsigned = (A < B) ? 32'd1 : 32'd0;
	assign less_than_signed = $signed(A) < $signed(B) ? 32'd1 : 32'd0;
	assign adder_B = (alu_control == CONTROL_SUB) ? ~B+1 : B;
	assign adder_result = A + adder_B;
	assign shift_left_logical = (alu_control == CONTROL_SLL) ? B << sa : B << A;
	assign shift_right_logical = (alu_control == CONTROL_SRL) ? B >> sa : B >> A;
	assign shift_right_arithmetic = (alu_control == CONTROL_SRA) ? $signed(B) >>> sa : $signed(B) >>> A;
	assign signed_product = $signed(A) * $signed(B);
	assign unsigned_product = $unsigned(A) * $unsigned(B);
	assign product_hi = (alu_control == CONTROL_MULT) ? signed_product[63:32] : unsigned_product[63:32];
	assign product_lo = (alu_control == CONTROL_MULT) ? signed_product[31:0] : unsigned_product[31:0];
	assign quotient = (alu_control == CONTROL_DIV) ? $signed($signed(A) / $signed(B)) : $unsigned(A) / $unsigned(B);
	assign remainder = (alu_control == CONTROL_DIV) ? $signed($signed(A) % $signed(B)) : $unsigned(A) % $unsigned(B);
	assign lwlr_addr = {adder_result[31:2], 2'b00};
	assign byte_offset = adder_result[1:0];

	always_comb begin
		case (alu_control)
			CONTROL_ADD: begin
				alu_result = adder_result;
			end
			CONTROL_SUB: begin
				alu_result = adder_result;
			end
			CONTROL_AND: begin
				alu_result = bitwise_and;
			end
			CONTROL_ANDI: begin
				alu_result = bitwise_and;
			end
			CONTROL_OR: begin
				alu_result = bitwise_or;
			end
			CONTROL_ORI: begin
				alu_result = bitwise_or;
			end
			CONTROL_XOR: begin
				alu_result = bitwise_xor;
			end
			CONTROL_XORI: begin
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
			CONTROL_SLLV: begin
				alu_result = shift_left_logical;
			end
			CONTROL_SRL: begin
				alu_result = shift_right_logical;
			end
			CONTROL_SRLV: begin
				alu_result = shift_right_logical;
			end
			CONTROL_SRA: begin
				alu_result = shift_right_arithmetic;
			end
			CONTROL_SRAV: begin
				alu_result = shift_right_arithmetic;
			end
			CONTROL_LUI: begin
				alu_result = B << 16;
			end
			CONTROL_LWLR: begin
				alu_result = lwlr_addr;
			end
			default: begin // for BRANCH, MULT/MULTU, DIV/DIVU, MTLO, MTHI
				alu_result = adder_result;
			end
		endcase

		case (branch_cond)
			BRANCH_EQUAL: begin
				branch_cond_true = A == B ? 1'b1 : 1'b0;
			end
			BRANCH_NOT_EQUAL: begin
				branch_cond_true = A != B ? 1'b1 : 1'b0;
			end
			BRANCH_LTZ: begin
				branch_cond_true = $signed(A) < 0 ? 1'b1: 1'b0;
			end
			BRANCH_GTZ: begin
				branch_cond_true = $signed(A) > 0 ? 1'b1: 1'b0;
			end
			BRANCH_LTEZ: begin
				branch_cond_true = $signed(A) <= 0 ? 1'b1: 1'b0;
			end
			BRANCH_GTEZ: begin
				branch_cond_true = $signed(A) >= 0 ? 1'b1: 1'b0;
			end
			default: begin
				branch_cond_true = 1'b0;
			end
		endcase

		if (alu_control == CONTROL_MTLO) begin
			LO_output = A;
			HI_output = product_hi;
		end
		else if (alu_control == CONTROL_MTHI) begin
			LO_output = product_lo;
			HI_output = A;
		end
		else if (alu_control == CONTROL_DIV || alu_control == CONTROL_DIVU) begin
			LO_output = quotient;
			HI_output = remainder;
		end
		else begin
			LO_output = product_lo;
			HI_output = product_hi;
		end
	end

	//assign Z = (alu_result == 0) ? 1'b1 : 1'b0;
	// assign V = (alu_control == CONTROL_ADD || alu_control == CONTROL_SUB) ? ((A[31] && adder_B[31] && !alu_result[31]) || (!A[31] && !adder_B[31] && alu_result[31])) : 0;
	// assign C = (alu_control == CONTROL_ADD || alu_control == CONTROL_SUB) ? adder_result[32] : 0;

endmodule