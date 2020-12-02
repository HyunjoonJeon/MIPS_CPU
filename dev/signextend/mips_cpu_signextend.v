module signextend (
    input logic [15:0] immediate,
    input logic [31:0] data_readdata,
    input logic select,

    // connected to alu_sel mux2
    output logic [31:0] extended_imm,
    // connected to reg_data_sel mux3
    output logic [31:0] extended_data
    );

    // always extend instruction immediate
    assign extended_imm = { {16{immediate[15]}}, immediate[15:0]};
    wire byte_msb;
    wire half_msb;

    assign byte_msb = data_readdata[7];
    assign half_msb = data_readdata[15];

    always_comb begin
        // extend mem data according to select bit
        if (select == 0)
            // sign extend byte
            extended_data = { {24{byte_msb}}, data_readdata[7:0]};
        else
            extended_data = { {16{half_msb}}, data_readdata[15:0]};
    end
    
endmodule 