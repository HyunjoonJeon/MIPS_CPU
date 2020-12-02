module pcnext_tb();
    logic [31:0] pc;
    logic [31:0] extended_imm;
    logic [25:0] j_addr;
    logic [31:0] reg_data_a;
    logic [1:0] pc_sel;
    logic is_true;

    logic [31:0] link_pc;
    logic [31:0] pcnext;

    initial begin
        $dumpfile("pcnext_tb.vcd");
        $dumpvars(0, pcnext_tb);

        extended_imm = 32'h5912abc3;
        reg_data_a = 32'hffff4214;
        j_addr = 26'h325039;

        // testing the 5 situatons
        // normal pc increment
        pc_sel = 2'b00;
        pc = 32'hBFC00000;
        #1;
        assert(pcnext==pc+4);

        // branch and condition met
        pc_sel = 2'b01;
        is_true = 1'b1;
        pc = 32'hBFC32000;
        #1;
        assert(pcnext==pc+4+extended_imm<<2);
        assert(link_pc==pc+8);

        // branch but condition not met
        pc_sel = 2'b01;
        is_true = 1'b0;
        #1; 
        assert(pcnext==pc+4);
        assert(link_pc==pc+8);
        // J and JAL 
        pc_sel = 2'b10;
        #1;
        assert(pcnext==j_addr<<2 | (pc+4) & 32'hf000000);

        // JR
        pc_sel = 2'b11;
        #1;
        assert(pcnext==reg_data_a);
    end

    pcnext dut(
        .pc(pc),
        .extended_imm(extended_imm),
        .j_addr(j_addr),
        .reg_data_a(reg_data_a),
        .pc_sel(pc_sel),
        .is_true(is_true),
        .link_pc(link_pc),
        .pcnext(pcnext)
    );

endmodule