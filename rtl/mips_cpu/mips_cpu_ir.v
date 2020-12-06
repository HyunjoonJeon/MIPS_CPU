module instr_reg (
    input logic clk,
    input logic [31:0] instr_readdata,
    input logic reset,
    input logic clk_enable,

    output logic [31:0] curr_instr
    );

    initial begin
        curr_instr = 0;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            curr_instr <= 0;
        end
        else if (clk_enable) begin
            curr_instr <= instr_readdata;
        end
    end

endmodule
