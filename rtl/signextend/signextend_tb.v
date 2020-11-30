module signextend_tb();
    logic [15:0] immediate;
    logic [31:0] data_readdata;
    logic select;

    logic [31:0] extended_imm;
    logic [31:0] extended_data;

    initial begin
        $dumpfile("signextend_tb.vcd");
        $dumpvars(0, signextend_tb);

        // only testing simple edge-cases (false positives and false negatives)
        immediate = 16'hffff;
        data_readdata = 32'hfff0;
        select = 0; // sign extend byte 
        #1;
        assert(extended_imm==32'hffffffff);
        assert(extended_data==32'hfffffff0);

        immediate = 16'h00ff;
        data_readdata = 32'h000f;
        select = 0;
        #1;
        assert(extended_imm==32'hff);
        assert(extended_data==32'hf);

        immediate = 16'hc84d;
        data_readdata = 32'hfff0;
        select = 1; // sign extend half word
        #1;
        assert(extended_imm==32'hffffc84d);
        assert(extended_data==32'hfffffff0);

        immediate = 16'h7aec;
        data_readdata = 32'h29c7;
        select = 1;
        #1;
        assert(extended_imm==32'h7aec);
        assert(extended_data==32'h29c7);
    end

    signextend dut(
        .immediate(immediate),
        .data_readdata(data_readdata),
        .select(select),
        .extended_imm(extended_imm),
        .extended_data(extended_data)
    );

endmodule