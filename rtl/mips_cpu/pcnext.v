//`timescale 1ns/100ps

module pcnext (
    input logic [31:0] pc,
    input logic [31:0] extended_imm,
    // instruction [25:0]
    input logic [25:0] j_addr,
    // data from reg for JR and JALR
    input logic [31:0] reg_data_a,

    // control logic from decoder
    input logic [1:0] pc_sel,
    // output from ALU that tells if condition is true
    input logic is_true,

    // pc+8 value connected to reg_data_sel mux3
    output logic [31:0] link_pc,
    // pcnext to go into pc
    output logic [31:0] pcnext
    );

    logic [31:0] pc_increment;
    logic [31:0] shifted_imm;
    assign pc_increment = pc + 4;
    assign link_pc = pc + 4;

    typedef enum logic[1:0] {
        INCREMENT = 2'b00,
        BRANCH = 2'b01,
        JUMP = 2'b10,
        JR = 2'b11
    } select_t;

    initial begin
        pcnext = pc_increment;
    end

    always_comb begin
        case(pc_sel)
            INCREMENT: begin
                pcnext = pc_increment;
            end
            BRANCH: begin
                pcnext = is_true ? $signed(pc) + $signed(extended_imm << 2) : pc_increment;
            end
            JUMP: begin
                pcnext = {pc[31:28], j_addr, 2'b00};
            end
            JR: begin
                pcnext = {reg_data_a[31:2], 2'b00};
            end
        endcase
    end

endmodule