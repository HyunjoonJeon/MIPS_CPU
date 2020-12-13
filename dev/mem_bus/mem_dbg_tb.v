module mem_dbg_tb();
    logic clk;
    logic rst;
    logic stall;

    //harvard IOs
    logic[31:0] ip_address;
    logic read_ip;
    logic[31:0] ip_data;

    logic[31:0] dp_address;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic read_dp;
    logic write_dp;
    logic[31:0] dp_data;

    //avalon IOs
    logic[31:0] avl_readdata;
    logic avl_waitrequest;
    logic[31:0] avl_address;
    logic[3:0] avl_byteenable;
    logic[31:0] avl_writedata;
    logic avl_read;
    logic avl_write;

    //debug IOs
    logic[31:0] dbg_address;
    logic[31:0] dbg_writedata;
    logic dbg_write;
    logic[31:0] dbg_readdata;

    parameter TIMEOUT_CYCLES = 1000;

    integer counter=0;

    initial begin
        clk=0;
        repeat (TIMEOUT_CYCLES) begin
            #1;
            clk=!clk;
            #1;
            clk=!clk;
            counter++;
        end
        $fatal(2,"simulation timeout after %d clock cycles",TIMEOUT_CYCLES);
    end

    initial begin
        $dumpfile("mem_dbg_tb.vcd");
        $dumpvars(0, mem_dbg_tb);

        read_ip=0;
        read_dp=0;
        write_dp=0;

        byteenable=4'b1111;
        ip_address=32'hbfc00000;
        dp_address=32'h00000afc;
        writedata=32'h12345678;

        dbg_address=32'h00000afc;
        dbg_writedata=32'h12abcdef;
        dbg_write=0;

        @(posedge clk);
        $display("data: %h",dp_data);

        $display("debug port write");
        dbg_write=1;
        @(posedge clk);
        @(posedge clk);
        dbg_write=0;
        #1;
        read_dp=1;
        @(negedge stall);
        read_dp=0;
        $display("new data: %h",dp_data);
        read_dp=0;

        $display("test dbg read");
        dp_address=32'h000002fb;
        writedata=32'h12345678;
        write_dp=1;
        @(negedge stall);
        write_dp=0;
        #1;
        dbg_address=32'h000002fb;
        @(posedge clk);
        @(posedge clk);
        $display("debug read: %h",dbg_readdata);
        read_dp=1;
        @(negedge stall);
        $display("check: %h",dp_data);
        

        $display("\ncycle count: %d", counter);
        $finish;

    end



    //////// modules ///////////////////////
    harvard_to_avalon busInterface(
        clk,
        rst,
        stall,
        ip_address,
        read_ip,
        ip_data,
        dp_address,
        writedata,
        byteenable,
        read_dp,
        write_dp,
        dp_data,
        avl_readdata,
        avl_waitrequest,
        avl_address,
        avl_byteenable,
        avl_writedata,
        avl_read,
        avl_write
    );

    avl_slave_mem_dbg #(.INSTR_INIT_FILE("test_data_1_20.txt"), .DATA_INIT_FILE("test_data_1_20.txt"), .BLOCK_SIZE(8192)) memDev(
        clk,
        rst,
        avl_address,
        avl_byteenable,
        avl_writedata,
        avl_read,
        avl_write,
        avl_readdata,
        avl_waitrequest,
        dbg_address,
        dbg_writedata,
        dbg_write,
        dbg_readdata
    );
endmodule