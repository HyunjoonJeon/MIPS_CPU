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
    logic [3:0] alu_control;
    logic [1:0] pc_sel, reg_addr_sel, reg_data_sel, branch_cond;
    logic reg_write_enable, signextend_sel, branch_is_true, alu_sel, clken, act;

    // Initial settings
    initial begin
        act = 0;
    end

    // active logic (use clk_enable to halt the execution of instructions when the program ends)
    always_comb begin
        clken = act & clk_enable & !(instr_address==0);
        active = act;
    end

    always_ff @(posedge clk) begin
        if(reset) begin
            act <= 1;
        end
        else if(instr_address==0) begin
            act <= 0;
        end
    end

    // Connecting to all modules
    pc pc(
        .clk(clk),
        .reset(reset),
        .clk_enable(clken),    //changed clk_enable to clken
        .new_pc(next_pc),
        .pc(curr_pc)
    );

    pcnext pcnext(
        .pc(curr_pc),
        .extended_imm(extended_imm),
        .j_addr(j_addr),
        .reg_data_a(reg_data_a),
        .pc_sel(pc_sel),
        .is_true(branch_is_true),
        .link_pc(link_pc),
        .pcnext(next_pc)
    );

    decoder decoder(
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
        .alu_sel(alu_sel)
        .signextend_sel(signextend_sel)
    );

    signextend signextend(
        .immediate(imm),
        .data_readdata(data_readdata),
        .select(signextend_sel),
        .extended_imm(extended_imm),
        .extended_data(extended_data)
    );

    mux1 mux1(
        .rt(rt),
        .rd(rd),
        .select(reg_addr_sel),
        .reg_write_addr(reg_write_addr)
    );

    mux2 mux2(
        .reg_data_b(reg_data_b),
        .extended_imm(extended_imm),
        .select(alu_sel),
        .alu_input(alu_input)
    );

    mux3 mux3(
        .aluout(aluout),
        .data_readdata(data_readdata),
        .signextend_data(extended_data),
        .link_pc(link_pc),
        .select(reg_data_sel),
        .reg_write_data(reg_write_data)
    );

    ALU_decoder ALU_decoder(
        .instr_readdata(instr_readdata),
        .clk(clk),
        .alu_control(alu_control),
        .branch_cond(branch_cond)
    );

    ALU ALU( // not yet added HI and LO
        .A(reg_data_a),
        .B(alu_input),
        .alu_control(alu_control),
        .branch_cond(branch_cond),
        .alu_result(aluout),
        .branch_cond_true(branch_is_true)
    );

    register_file register_file(
        .clk(clk),
        .reset(reset),
        .read_reg1(rs),
        .read_reg2(rt),
        .read_data_a(reg_data_a),
        .read_data_b(reg_data_b),
        .write_reg(reg_write_addr),
        .write_enable(reg_write_enable),
        .write_data(reg_write_data)
        .clk_enable(clken),
        .register_v0(register_v0)
    );

endmodule