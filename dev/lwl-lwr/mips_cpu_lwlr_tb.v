module lwlr_tb();
    logic [31:0] reg_data_b;
    logic [31:0] data_readdata;
    logic [1:0] byte_offset;
    logic lwl;

    output logic [31:0] reg_write_data;

    initial begin
        $dumpfile("lwlr_tb.vcd");

        reg_data_b = 32'haabbccdd;
        data_readdata = 32'h00112233;
        byte_offset = 2'b10;
        lwl = 1'b0;
        #1;
        assert (reg_write_data == 32'haa001122);

        // byte_offset = 1 = LWL
        reg_data_b = 32'haabbccdd;
        data_readdata = 32'h00112233;
        byte_offset = 2'b10;
        lwl = 1'b1;
        #1;
        assert (reg_write_data == 32'h2233ccdd);
    end

    lwlr dut(
        .reg_data_b(reg_data_b),
        .data_readdata(data_readdata),
        .byte_offset(byte_offset),
        .lwl(lwl),
        .reg_write_data(reg_write_data)
    );

endmodule