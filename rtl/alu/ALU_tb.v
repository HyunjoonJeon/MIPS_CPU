module ALU_tb;
	logic [31:0] A;
	logic [31:0] B;
	logic [3:0] alu_control;
	logic [2:0] branch_cond;

	logic [31:0] alu_result;
	logic Z;
	logic branch_cond_true;

	initial begin
		$dumpfile("ALU_tb.vcd");
		$dumpvars(0, ALU_tb);

		// testing unsigned addition
		A = 32'hBEF41A9C;
		B = 32'hC76B62EF;
		alu_control = 4'b0000; // select ADD
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'h865F7D8B);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing unsigned subtraction case#1
		A = 32'hC76B62EF;
		B = 32'hBEF41A9C;
		alu_control = 4'b0001; // select SUB
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'h08774853);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing unsigned subtraction case#2
		A = 32'hFFFFFFFF;
		B = 32'hFFFFFFFF;
		alu_control = 4'b0001; // select SUB
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd0);
		assert(Z == 1'b1);
		assert(branch_cond_true == 1'b0);

		// testing bitwise AND case#1
		A = 32'hAAAAAAAA;
		B = 32'h55555555;
		alu_control = 4'b0010; // select bitwise AND
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd0);
		assert(Z == 1'b1);
		assert(branch_cond_true == 1'b0);

		// testing bitwise AND case#2
		A = 32'hC76B62EF;
		B = 32'hBEF41A9C;
		alu_control = 4'b0010; // select bitwise AND
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'h8660028C);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing bitwise OR case#1
		A = 32'hAAAAAAAA;
		B = 32'h55555555;
		alu_control = 4'b0011; // select bitwise OR
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'hFFFFFFFF);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing bitwise OR case#2
		A = 32'hC76B62EF;
		B = 32'hBEF41A9C;
		alu_control = 4'b0011; // select bitwise OR
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'hFFFF7AFF);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing bitwise XOR 
		A = 32'hC76B62EF;
		B = 32'hBEF41A9C;
		alu_control = 4'b0100; // select bitwise XOR
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'h799F7873);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing signed slt case#1
		A = 32'h3A247901;
		B = 32'h6851BA29;
		alu_control = 4'b0101; // select slt
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd1);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing signed slt case#2
		A = 32'h917D2A8C;
		B = 32'hEA458C10;
		alu_control = 4'b0101; // select slt
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd1);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing signed slt case#3
		A = 32'h71234569;
		B = 32'h8A12534C;
		alu_control = 4'b0101; // select slt
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd0);
		assert(Z == 1'b1);
		assert(branch_cond_true == 1'b0);

		// testing signed slt case#4
		A = 32'h12345678;
		B = 32'h12345678;
		alu_control = 4'b0101; // select slt
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd0);
		assert(Z == 1'b1);
		assert(branch_cond_true == 1'b0);

		// testing unsigned slt case#1
		A = 32'h3A247901;
		B = 32'h6851BA29;
		alu_control = 4'b0110; // select sltu
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd1);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing unsigned slt case#2
		A = 32'h917D2A8C;
		B = 32'hEA458C10;
		alu_control = 4'b0110; // select sltu
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd1);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing unsigned slt case#3
		A = 32'h71234569;
		B = 32'h8A12534C;
		alu_control = 4'b0110; // select sltu
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd1);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing unsigned slt case#4
		A = 32'h12345678;
		B = 32'h12345678;
		alu_control = 4'b0110; // select sltu
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd0);
		assert(Z == 1'b1);
		assert(branch_cond_true == 1'b0);

		// testing left shift #case1
		A = 32'hA2683C2E;
		B = 32'h0000001F;
		alu_control = 4'b0111; // select sll
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd0);
		assert(Z == 1'b1);
		assert(branch_cond_true == 1'b0);

		// testing left shift #case2
		A = 32'hA2683C2E;
		B = 32'h00000005;
		alu_control = 4'b0111; // select sll
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'h4D0785C0);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing logical right shift #case1
		A = 32'hA2683C2E;
		B = 32'h0000001F;
		alu_control = 4'b1000; // select srl
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'd1);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing logical right shift #case2
		A = 32'hA2683C2E;
		B = 32'h00000005;
		alu_control = 4'b1000; // select srl
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'h051341E1);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing arithmetic right shift
		A = 32'hA2683C2E;
		B = 32'h0000001F;
		alu_control = 4'b1001; // select sra
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'hFFFFFFFF);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing arithmetic right shift #case2
		A = 32'hA2683C2E;
		B = 32'h00000005;
		alu_control = 4'b1001; // select sra
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'hFD1341E1);
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0);

		// testing branch: A = B for BEQ instruction #case1
		A = 32'h3A247901;
		B = 32'h6851BA29;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b001; // select A = B
		#1;
		assert(alu_result == 32'hA276332A); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A = B for BEQ instruction #case2
		A = 32'h1B4F2916;
		B = 32'h1B4F2916;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b001; // select A = B
		#1;
		assert(alu_result == 32'h369E522C); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A != B for BNE instruction #case1
		A = 32'h3A247901;
		B = 32'h6851BA29;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b010; // select A != B
		#1;
		assert(alu_result == 32'hA276332A); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A != B for BNE instruction #case2
		A = 32'h1B4F2916;
		B = 32'h1B4F2916;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b010; // select A != B
		#1;
		assert(alu_result == 32'h369E522C); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A < 0 for BLTZ and BLTZAL instruction #case1
		A = 32'hC348E612;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b011; // select A < 0
		#1;
		assert(alu_result == 32'hD57D3C8A); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A < 0 for BLTZ and BLTZAL instruction #case2
		A = 32'h4348E612;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b011; // select A < 0
		#1;
		assert(alu_result == 32'h557D3C8A); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A < 0 for BLTZ and BLTZAL instruction #case3
		A = 32'd0;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b011; // select A < 0
		#1;
		assert(alu_result == 32'h12345678); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A > 0 for BGTZ instruction #case1
		A = 32'hC348E612;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b100; // A > 0
		#1;
		assert(alu_result == 32'hD57D3C8A); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A > 0 for BGTZ instruction #case2
		A = 32'h4348E612;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b100; // A > 0
		#1;
		assert(alu_result == 32'h557D3C8A); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A > 0 for BGTZ instruction #case3
		A = 32'd0;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b100; // A > 0
		#1;
		assert(alu_result == 32'h12345678); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A <= 0 for BLEZ instruction #case1
		A = 32'hC348E612;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b101; // A <= 0
		#1;
		assert(alu_result == 32'hD57D3C8A); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A <= 0 for BLEZ instruction #case2
		A = 32'h4348E612;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b101; // A <= 0
		#1;
		assert(alu_result == 32'h557D3C8A); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A <= 0 for BLEZ instruction #case3
		A = 32'd0;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b101; // A <= 0
		#1;
		assert(alu_result == 32'h12345678); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A >= 0 for BGEZ and BGEZAL instruction #case1
		A = 32'hC348E612;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b110; // A >= 0
		#1;
		assert(alu_result == 32'hD57D3C8A); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A >= 0 for BGEZ and BGEZAL instruction #case2
		A = 32'h4348E612;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b110; // A >= 0
		#1;
		assert(alu_result == 32'h557D3C8A); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A >= 0 for BGEZ and BGEZAL instruction #case3
		A = 32'd0;
		B = 32'h12345678;
		alu_control = 4'b1110; // select branch
		branch_cond = 3'b110; // A >= 0
		#1;
		assert(alu_result == 32'h12345678); // addition performed
		assert(Z == 1'b0);
		assert(branch_cond_true == 1'b1); // true
	end

	ALU dut(
		.A(A),
		.B(B),
		.alu_control(alu_control),
		.branch_cond(branch_cond),
		.alu_result(alu_result),
		.Z(Z),
		.branch_cond_true(branch_cond_true)
	);

endmodule