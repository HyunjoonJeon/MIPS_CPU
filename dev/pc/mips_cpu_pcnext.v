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

    wire [31:0] pc_increment;
    assign pc_increment = pc + 4;

    assign link_pc = pc + 8;

    typedef enum logic[1:0] {
        INCREMENT = 2'b00,
        BRANCH = 2'b01,
        JUMP = 2'b10,
        JR = 2'b11
    } select_t;

    always_comb begin
        case(pc_sel)
            INCREMENT: begin
                pcnext = pc_increment;
            end
            BRANCH: begin
                pcnext = is_true ? pc_increment + extended_imm << 2 : pc_increment;
            end
            JUMP: begin
                pcnext = j_addr << 2 | (pc_increment & 32'hf0000000);
            end
            JR: begin
                pcnext = reg_data_a;
            end
        endcase
    end

endmodule