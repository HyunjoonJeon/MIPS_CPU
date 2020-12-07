module lwlr(
    input logic [31:0] reg_data_b,
    input logic [31:0] data_readdata,
    input logic [1:0] byte_offset,
    input logic lwl,

    output logic [31:0] reg_write_data
    );

    always_comb begin
        // if select == 1 means LWL
        case(byte_offset)
        2'b00: begin
            reg_write_data = lwl ? {data_readdata[7:0], reg_data_b[23:0]} : data_readdata;
        end        
        2'b01: begin
            reg_write_data = lwl ? {data_readdata[15:0], reg_data_b[15:0]} : {reg_data_b[31:24], data_readdata[31:8]};
        end
        2'b10: begin
            reg_write_data = lwl ? {data_readdata[23:0], reg_data_b[7:0]} : {reg_data_b[31:16], data_readdata[31:16]};
        end
        2'b11: begin
            reg_write_data = lwl ? data_readdata : {reg_data_b[31:8], data_readdata[31:24]};
        end
        endcase
    end

endmodule