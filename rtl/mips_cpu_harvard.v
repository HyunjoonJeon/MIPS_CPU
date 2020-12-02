module mips_cpu_harvard(
    input logic clk,
    input logic clk_enable,
    input logic reset,

    output logic active,
    output logic [31:0] register_v0,

    // Connections to mem
    input logic [31:0] instr_readdata,
    output logic [31:0] instr_address,
    output logic [3:0] byte_enable,
    output logic instr_read,

    output logic [31:0] data_address,
    output logic data_write,
    output logic data_read,
    output logic [31:0] data_writedata,
    input logic [31:0] data_readdata
    );

    // Breaking down instruction word
    logic [25:0] j_addr;
    logic [15:0] imm;
    logic [4:0] rs, rt, rd, reg_write_addr;
    
    assign j_addr = instr_readdata[25:0];
    assign imm = instr_readdata[15:0];
    assign rs = instr_readdata[25:21];
    assign rt = instr_readdata[20:16];
    assign rd = instr_readdata[15:11];

    // Intermediate signals
    logic [31:0] curr_pc, next_pc, link_pc, extended_imm, extended_data;
    logic [31:0] alu_input, aluout, reg_write_data, reg_data_a, reg_data_b;
    logic [31:0] LO_alu2reg, LO_reg2alu, HI_alu2reg, HI_reg2alu;
    logic [4:0] alu_control, shamt;
    logic [2:0] branch_cond;
    logic [1:0] pc_sel, reg_addr_sel, reg_data_sel;
    logic reg_write_enable, signextend_sel, branch_is_true, alu_sel, clken, act, LO_write_enable, HI_write_enable;

    // Initial settings
    initial begin
        act = 0;
    end

    // active logic (use clk_enable to halt the execution of instructions when the program ends)
    always_comb begin
        clken = act & clk_enable & !(instr_readdata==32'h00000008); //!(instr_address==0);
        active = act;
        instr_address = curr_pc;
        instr_read=1;
        data_writedata = reg_data_b;
        data_address = aluout;
    end

    always_ff @(posedge clk) begin
        if(reset) begin
            act <= 1;
        end
        else if(instr_readdata==32'h00000008) begin
            act <= 0;
        end
    end

    // Connecting to all modules
    pc pc_1(
        .clk(clk),
        .reset(reset),
        .clk_enable(clken),    //changed clk_enable to clken
        .new_pc(next_pc),
        .pc(curr_pc)
    );

    pcnext pcnext_1(
        .pc(curr_pc),
        .extended_imm(extended_imm),
        .j_addr(j_addr),
        .reg_data_a(reg_data_a),
        .pc_sel(pc_sel),
        .is_true(branch_is_true),
        .link_pc(link_pc),
        .pcnext(next_pc)
    );

    decoder decoder_1(
        .instr_readdata(instr_readdata),
        .clk_enable(clken),    //changed clk_enable to clken
        .reset(reset),
        .active(active),
        .is_true(branch_is_true),
        .pc_sel(pc_sel),
        .data_write(data_write),
        .data_read(data_read),
        .byte_enable(byte_enable),
        .reg_write_enable(reg_write_enable),
        .reg_addr_sel(reg_addr_sel),
        .reg_data_sel(reg_data_sel),
        .alu_sel(alu_sel),
        .signextend_sel(signextend_sel)
    );

    signextend signextend_1(
        .immediate(imm),
        .data_readdata(data_readdata),
        .select(signextend_sel),
        .extended_imm(extended_imm),
        .extended_data(extended_data)
    );

    mux1 mux1_1(
        .rt(rt),
        .rd(rd),
        .select(reg_addr_sel),
        .reg_write_addr(reg_write_addr)
    );

    mux2 mux2_1(
        .reg_data_b(reg_data_b),
        .extended_imm(extended_imm),
        .select(alu_sel),
        .alu_input(alu_input)
    );

    mux3 mux3_1(
        .aluout(aluout),
        .data_readdata(data_readdata),
        .signextend_data(extended_data),
        .link_pc(link_pc),
        .select(reg_data_sel),
        .reg_write_data(reg_write_data)
    );

    ALU_decoder ALU_decoder_1(
        .instr_readdata(instr_readdata),
        .alu_control(alu_control),
        .branch_cond(branch_cond),
        .sa(shamt),
        .LO_write_enable(LO_write_enable),
        .HI_write_enable(HI_write_enable)
    );

    ALU ALU_1(
        .A(reg_data_a),
        .B(alu_input),
        .alu_control(alu_control),
        .branch_cond(branch_cond),
        .sa(shamt),
        .LO_input(LO_reg2alu),
        .HI_input(HI_reg2alu),
        .alu_result(aluout),
        .branch_cond_true(branch_is_true),
        .LO_output(LO_alu2reg),
        .HI_output(HI_alu2reg)
    );

    reg_file_hi_lo reg_file_hi_lo_1(
        .clk(clk),
        .reset(reset),
        .clk_enable(clken),
        .LO_input(LO_alu2reg),
        .HI_input(HI_alu2reg),
        .LO_write_enable(LO_write_enable),
        .HI_write_enable(HI_write_enable),
        .LO_output(LO_reg2alu),
        .HI_output(HI_reg2alu)
    );

    register_file register_file_1(    // need to add reg_v0 output? and also need a clk_enable?
        .clk(clk),
	    .clk_enable(clken),
        .reset(reset),
        .read_reg1(rs),
        .read_reg2(rt),
        .read_data_a(reg_data_a),
        .read_data_b(reg_data_b),
	    .register_v0(register_v0),
        .write_reg(reg_write_addr),
        .write_enable(reg_write_enable),
        .write_data(reg_write_data)
    );

endmodule
