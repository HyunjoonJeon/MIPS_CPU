module harvard_to_avalon_tb();
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
        $dumpfile("harvard_to_avalon_tb.vcd");
        $dumpvars(0, harvard_to_avalon_tb);

        read_ip=1;
        read_dp=0;
        write_dp=0;

        byteenable=4'b1111;
        ip_address=32'hbfc00000;
        dp_address=0;
        writedata=32'h12345678;

        #2;
        repeat (4) begin
            @(negedge stall);
            $display("%h",ip_data);
            ip_address=ip_address+4;
        end

        #2;
        $display("");
        read_dp=1;
        byteenable=4'b1000;
        repeat (4) begin
            @(negedge stall);
            $display("%h",dp_data);
            byteenable=byteenable>>1;
        end
        read_dp=0;
        #2;

        write_dp=1;
        byteenable=4'b0001;
        writedata=32'hddccbbaa;
        repeat (4) begin
            @(negedge stall);
            byteenable=byteenable<<1;
            dp_address=dp_address+4;
        end
        write_dp=0;
        #2;
                
        $display("");
        read_dp=1;
        byteenable=4'b1111;
        dp_address=0;
        repeat (4) begin
            @(negedge stall);
            $display("%h",dp_data);
            dp_address=dp_address+4;
        end
                        
        read_ip=0;
        read_dp=0;
        write_dp=0;
        #4;

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

    avl_slave_mem memDev(
        clk,
        rst,
        avl_address,
        avl_byteenable,
        avl_writedata,
        avl_read,
        avl_write,
        avl_readdata,
        avl_waitrequest
    );
endmodule