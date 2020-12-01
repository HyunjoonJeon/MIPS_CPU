module ALU_tb;
	logic [31:0] A;
	logic [31:0] B;
	logic [4:0] alu_control;
	logic [2:0] branch_cond;
	logic [31:0] LO_input;
	logic [31:0] HI_input;

	logic [31:0] alu_result;
	logic branch_cond_true;
	logic [31:0] LO_output;
	logic [31:0] HI_output;

	initial begin
		$dumpfile("ALU_tb.vcd");
		$dumpvars(0, ALU_tb);

		LO_input = 32'd0;
		HI_input = 32'd0;
		branch_cond = 3'b000; // no branch

		// testing unsigned addition
		A = 32'hBEF41A9C;
		B = 32'hC76B62EF;
		alu_control = 5'b00000; // select ADD
		#1;
		assert(alu_result == 32'h865F7D8B);
		assert(branch_cond_true == 1'b0);

		// testing unsigned subtraction case#1
		A = 32'hC76B62EF;
		B = 32'hBEF41A9C;
		alu_control = 5'b00001; // select SUB
		#1;
		assert(alu_result == 32'h08774853);
		assert(branch_cond_true == 1'b0);

		// testing unsigned subtraction case#2
		A = 32'hFFFFFFFF;
		B = 32'hFFFFFFFF;
		alu_control = 5'b00001; // select SUB
		#1;
		assert(alu_result == 32'd0);
		assert(branch_cond_true == 1'b0);

		// testing bitwise AND case#1
		A = 32'hAAAAAAAA;
		B = 32'h55555555;
		alu_control = 5'b00010; // select bitwise AND
		#1;
		assert(alu_result == 32'd0);
		assert(branch_cond_true == 1'b0);

		// testing bitwise AND case#2
		A = 32'hC76B62EF;
		B = 32'hBEF41A9C;
		alu_control = 5'b00010; // select bitwise AND
		#1;
		assert(alu_result == 32'h8660028C);
		assert(branch_cond_true == 1'b0);

		// testing bitwise OR case#1
		A = 32'hAAAAAAAA;
		B = 32'h55555555;
		alu_control = 5'b00011; // select bitwise OR
		#1;
		assert(alu_result == 32'hFFFFFFFF);
		assert(branch_cond_true == 1'b0);

		// testing bitwise OR case#2
		A = 32'hC76B62EF;
		B = 32'hBEF41A9C;
		alu_control = 5'b00011; // select bitwise OR
		#1;
		assert(alu_result == 32'hFFFF7AFF);
		assert(branch_cond_true == 1'b0);

		// testing bitwise XOR 
		A = 32'hC76B62EF;
		B = 32'hBEF41A9C;
		alu_control = 5'b00100; // select bitwise XOR
		#1;
		assert(alu_result == 32'h799F7873);
		assert(branch_cond_true == 1'b0);

		// testing signed slt case#1
		A = 32'h3A247901;
		B = 32'h6851BA29;
		alu_control = 5'b00101; // select slt
		#1;
		assert(alu_result == 32'd1);
		assert(branch_cond_true == 1'b0);

		// testing signed slt case#2
		A = 32'h917D2A8C;
		B = 32'hEA458C10;
		alu_control = 5'b00101; // select slt
		#1;
		assert(alu_result == 32'd1);
		assert(branch_cond_true == 1'b0);

		// testing signed slt case#3
		A = 32'h71234569;
		B = 32'h8A12534C;
		alu_control = 5'b00101; // select slt
		#1;
		assert(alu_result == 32'd0);
		assert(branch_cond_true == 1'b0);

		// testing signed slt case#4
		A = 32'h12345678;
		B = 32'h12345678;
		alu_control = 5'b00101; // select slt
		#1;
		assert(alu_result == 32'd0);
		assert(branch_cond_true == 1'b0);

		// testing unsigned slt case#1
		A = 32'h3A247901;
		B = 32'h6851BA29;
		alu_control = 5'b00110; // select sltu
		#1;
		assert(alu_result == 32'd1);
		assert(branch_cond_true == 1'b0);

		// testing unsigned slt case#2
		A = 32'h917D2A8C;
		B = 32'hEA458C10;
		alu_control = 5'b00110; // select sltu
		#1;
		assert(alu_result == 32'd1);
		assert(branch_cond_true == 1'b0);

		// testing unsigned slt case#3
		A = 32'h71234569;
		B = 32'h8A12534C;
		alu_control = 5'b00110; // select sltu
		#1;
		assert(alu_result == 32'd1);
		assert(branch_cond_true == 1'b0);

		// testing unsigned slt case#4
		A = 32'h12345678;
		B = 32'h12345678;
		alu_control = 5'b00110; // select sltu
		#1;
		assert(alu_result == 32'd0);
		assert(branch_cond_true == 1'b0);

		// testing left shift #case1
		A = 32'hA2683C2E;
		B = 32'h0000001F;
		alu_control = 5'b00111; // select sll
		#1;
		assert(alu_result == 32'd0);
		assert(branch_cond_true == 1'b0);

		// testing left shift #case2
		A = 32'hA2683C2E;
		B = 32'h00000005;
		alu_control = 5'b00111; // select sll
		#1;
		assert(alu_result == 32'h4D0785C0);
		assert(branch_cond_true == 1'b0);

		// testing logical right shift #case1
		A = 32'hA2683C2E;
		B = 32'h0000001F;
		alu_control = 5'b01000; // select srl
		#1;
		assert(alu_result == 32'd1);
		assert(branch_cond_true == 1'b0);

		// testing logical right shift #case2
		A = 32'hA2683C2E;
		B = 32'h00000005;
		alu_control = 5'b01000; // select srl
		#1;
		assert(alu_result == 32'h051341E1);
		assert(branch_cond_true == 1'b0);

		// testing arithmetic right shift
		A = 32'hA2683C2E;
		B = 32'h0000001F;
		alu_control = 5'b01001; // select sra
		#1;
		assert(alu_result == 32'hFFFFFFFF);
		assert(branch_cond_true == 1'b0);

		// testing arithmetic right shift #case2
		A = 32'hA2683C2E;
		B = 32'h00000005;
		alu_control = 5'b01001; // select sra
		#1;
		assert(alu_result == 32'hFD1341E1);
		assert(branch_cond_true == 1'b0);

		// testing branch: A = B for BEQ instruction #case1
		A = 32'h3A247901;
		B = 32'h6851BA29;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b001; // select A = B
		#1;
		assert(alu_result == 32'hA276332A); // addition performed
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A = B for BEQ instruction #case2
		A = 32'h1B4F2916;
		B = 32'h1B4F2916;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b001; // select A = B
		#1;
		assert(alu_result == 32'h369E522C); // addition performed
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A != B for BNE instruction #case1
		A = 32'h3A247901;
		B = 32'h6851BA29;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b010; // select A != B
		#1;
		assert(alu_result == 32'hA276332A); // addition performed
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A != B for BNE instruction #case2
		A = 32'h1B4F2916;
		B = 32'h1B4F2916;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b010; // select A != B
		#1;
		assert(alu_result == 32'h369E522C); // addition performed
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A < 0 for BLTZ and BLTZAL instruction #case1
		A = 32'hC348E612;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b011; // select A < 0
		#1;
		assert(alu_result == 32'hD57D3C8A); // addition performed
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A < 0 for BLTZ and BLTZAL instruction #case2
		A = 32'h4348E612;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b011; // select A < 0
		#1;
		assert(alu_result == 32'h557D3C8A); // addition performed
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A < 0 for BLTZ and BLTZAL instruction #case3
		A = 32'd0;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b011; // select A < 0
		#1;
		assert(alu_result == 32'h12345678); // addition performed
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A > 0 for BGTZ instruction #case1
		A = 32'hC348E612;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b100; // A > 0
		#1;
		assert(alu_result == 32'hD57D3C8A); // addition performed
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A > 0 for BGTZ instruction #case2
		A = 32'h4348E612;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b100; // A > 0
		#1;
		assert(alu_result == 32'h557D3C8A); // addition performed
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A > 0 for BGTZ instruction #case3
		A = 32'd0;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b100; // A > 0
		#1;
		assert(alu_result == 32'h12345678); // addition performed
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A <= 0 for BLEZ instruction #case1
		A = 32'hC348E612;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b101; // A <= 0
		#1;
		assert(alu_result == 32'hD57D3C8A); // addition performed
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A <= 0 for BLEZ instruction #case2
		A = 32'h4348E612;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b101; // A <= 0
		#1;
		assert(alu_result == 32'h557D3C8A); // addition performed
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A <= 0 for BLEZ instruction #case3
		A = 32'd0;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b101; // A <= 0
		#1;
		assert(alu_result == 32'h12345678); // addition performed
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A >= 0 for BGEZ and BGEZAL instruction #case1
		A = 32'hC348E612;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b110; // A >= 0
		#1;
		assert(alu_result == 32'hD57D3C8A); // addition performed
		assert(branch_cond_true == 1'b0); // not true

		// testing branch: A >= 0 for BGEZ and BGEZAL instruction #case2
		A = 32'h4348E612;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b110; // A >= 0
		#1;
		assert(alu_result == 32'h557D3C8A); // addition performed
		assert(branch_cond_true == 1'b1); // true

		// testing branch: A >= 0 for BGEZ and BGEZAL instruction #case3
		A = 32'd0;
		B = 32'h12345678;
		alu_control = 5'b00000; // select add
		branch_cond = 3'b110; // A >= 0
		#1;
		assert(alu_result == 32'h12345678); // addition performed
		assert(branch_cond_true == 1'b1); // true

		// testing lui
		A = 32'd0;
		B = 32'h00001468;
		alu_control = 5'b01110; // select lui
		branch_cond = 3'b000;
		#1;
		assert(alu_result == 32'h14680000);
		assert(branch_cond_true == 1'b0);

		// testing mtlo
		A = 32'h12345678;
		B = 32'h7B93A612;
		alu_control = 5'b01111; // select mtlo
		#1;
		assert(alu_result == 32'h8DC7FC8A);
		assert(branch_cond_true == 1'b0);
		assert(LO_output == 32'h7B93A612);

		// testing mthi
		A = 32'h12345678;
		B = 32'h7B93A612;
		alu_control = 5'b10000; // select mthi
		#1;
		assert(alu_result == 32'h8DC7FC8A);
		assert(branch_cond_true == 1'b0);
		assert(HI_output == 32'h7B93A612);

		// testing mult #case1
		A = 32'h86E1FB43;
		B = 32'h6B72C901;
		alu_control = 5'b01010; // select mult
		#1;
		assert(alu_result == 32'hF254C444);
		assert(branch_cond_true == 1'b0);
		assert(LO_output == 32'hD9FF9643);
		assert(HI_output == 32'hCD2A258D);

		// testing mult #case2
		A = 32'h73A219F6;
		B = 32'h48C1B302;
		alu_control = 5'b01010; // select mult
		#1;
		assert(alu_result == 32'hBC63CCF8);
		assert(branch_cond_true == 1'b0);
		assert(LO_output == 32'h01E135EC);
		assert(HI_output == 32'h20DD155E);

		// testing multu #case1
		A = 32'h86E1FB43;
		B = 32'h6B72C901;
		alu_control = 5'b01011; // select multu
		#1;
		assert(alu_result == 32'hF254C444);
		assert(branch_cond_true == 1'b0);
		assert(LO_output == 32'hD9FF9643);
		assert(HI_output == 32'h389CEE8E);

		// testing multu #case2
		A = 32'h73A219F6;
		B = 32'h48C1B302;
		alu_control = 5'b01011; // select multu
		#1;
		assert(alu_result == 32'hBC63CCF8);
		assert(branch_cond_true == 1'b0);
		assert(LO_output == 32'h01E135EC);
		assert(HI_output == 32'h20DD155E);

		// testing div
		A = 32'h8396A10C;
		B = 32'h02A13C92;
		alu_control = 5'b01100; // select div
		#1;
		assert(alu_result == 32'h8637DD9E);
		assert(branch_cond_true == 1'b0);
		assert(LO_output == 32'hFFFFFFD1);
		assert(HI_output == 32'hFF30BFDA);

		// testing divu
		A = 32'h8396A10C;
		B = 32'h02A13C92;
		alu_control = 5'b01101; // select divu
		#1;
		assert(alu_result == 32'h8637DD9E);
		assert(branch_cond_true == 1'b0);
		assert(LO_output == 32'h00000032);
		assert(HI_output == 32'h0018CC88);
	end

	ALU dut(
		.A(A),
		.B(B),
		.alu_control(alu_control),
		.branch_cond(branch_cond),
		.LO_input(LO_input),
		.HI_input(HI_input),
		.alu_result(alu_result),
		.branch_cond_true(branch_cond_true),
		.LO_output(LO_output),
		.HI_output(HI_output)
	);

endmodule