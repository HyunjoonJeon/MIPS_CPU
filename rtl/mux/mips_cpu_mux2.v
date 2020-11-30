module mux2 (
    input logic [31:0] reg_data_b,
    input logic [31:0] extended_imm,
    input logic select,

    output logic [31:0] alu_input
    );

    // mux that chooses between sign extended immediate value
    // and the output read_data_b to give to ALU

    always_comb begin
        alu_input = select ? extended_imm : reg_data_b;
    end

endmodule