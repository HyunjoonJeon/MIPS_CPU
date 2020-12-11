module reg_data_mux (
    input logic [31:0] aluout,
    input logic [31:0] data_readdata,
    input logic [31:0] lwlr_data,
    input logic [31:0] signextend_data,
    // pc + 8 value from pcnext
    input logic [31:0] link_pc,
    input logic [1:0] select,
    input logic islwlr,

    output logic [31:0] reg_write_data
    );

    // chooses between alu out and mem out to send to reg write data

    always_comb begin
        case (select)
            2'b00: begin
                reg_write_data = aluout;
            end
            2'b01: begin
                reg_write_data = islwlr ? lwlr_data : data_readdata;
            end
            2'b10: begin
                reg_write_data = signextend_data;
            end
            2'b11: begin
                reg_write_data = link_pc;
            end
            default:
                reg_write_data = aluout;
        endcase
    end

endmodule