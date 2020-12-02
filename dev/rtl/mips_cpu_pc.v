module pc (
    input logic [31:0] new_pc,
    output logic [31:0] pc,

    input logic clk, 
    input logic reset,
    input logic clk_enable
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= 32'hBFC00000;
        end
        else if (clk_enable) begin
            pc <= new_pc;
        end
    end
endmodule
