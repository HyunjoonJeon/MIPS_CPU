//`timescale 1ns/100ps

module pc (
    input logic [31:0] new_pc,
    output logic [31:0] pc,

    input logic clk, 
    input logic reset,
    input logic clk_enable,
    input logic is_branch
    );
    
    initial begin
        pc = 32'hbfc00000;
    end

    logic branching;
    logic [31:0] intermediate_pc;

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= 32'hbfc00000;
        end
        else if (clk_enable) begin
            if (is_branch) begin
                pc <= pc + 4;
                intermediate_pc <= new_pc;
                branching <= 1'b1;
            end
            else if (branching) begin
                pc <= intermediate_pc;
                branching <= 1'b0;
            end
            else begin
                pc <= new_pc;
            end
        end
    end
endmodule
