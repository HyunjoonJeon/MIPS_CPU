module mux1 (
    input logic [4:0] rt,
    input logic [4:0] rd,
    input logic [1:0] select,

    output logic [4:0] reg_write_addr
    );

    // mux that takes in instr_readdata[20:16] rt, and [15:11] rd
    // uses decoder select output to choose which to give to reg_write_addr

    always_comb begin
        reg_write_addr = select[1] ? 32'd31 : (select[0] ? rd : rt );
    end

endmodule

    