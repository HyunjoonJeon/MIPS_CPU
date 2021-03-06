//`timescale 1ns/100ps

module pc (
    input logic [31:0] new_pc,
    output logic [31:0] pc,

    input logic clk, 
    input logic reset,
    input logic clk_enable
    );

    logic [31:0] intermediate_pc;

    initial begin
        pc = 32'hbfc00000;
        intermediate_pc = 32'hbfc00000;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= 32'hbfc00000;
            intermediate_pc <= 32'hbfc00000;
        end
        else if (clk_enable) begin
            pc <= intermediate_pc;
            intermediate_pc <= new_pc;
        end
    end
endmodule
