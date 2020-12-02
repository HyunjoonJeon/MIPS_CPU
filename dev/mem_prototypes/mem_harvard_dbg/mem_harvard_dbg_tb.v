module mem_harvard_dbg_tb();
    logic clk;
    logic rst;
    
    logic[31:0] ip_address;
    logic read_ip;
    logic[31:0] ip_data;

    logic[31:0] dp_address;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic read_dp;
    logic write_dp;
    logic[31:0] dp_data;
    logic stall;

    logic[31:0] dbg_address;
    logic[31:0] dbg_readdata;

    parameter INSTR_INIT_FILE = "";
    parameter DATA_INIT_FILE = "";

    parameter TIMEOUT_CYCLES = 300;

    initial begin
        clk=0;
        repeat (TIMEOUT_CYCLES) begin
            #1
            clk=!clk;
            #1;
            clk=!clk;
        end
        $fatal(2,"simulation cycle timeout");
    end

    initial begin
        rst=0;
        ip_address=32'hbfc00000;
        read_ip=0;
        dp_address=0;
        writedata=0;
        byteenable=4'b1111;
        read_dp=0;
        write_dp=0;
        dbg_address=0;

        #4;
        $display("reading data block");
        repeat (5) begin
            $display("%h",dbg_readdata);
            dbg_address=dbg_address+4;
            #1;
        end

        $display("\nreading instruction block");
        dbg_address=32'hbfc00000;
        #1;
        repeat (5) begin
            $display("%h",dbg_readdata);
            dbg_address=dbg_address+4;
            #1;
        end
        
        // #1;
        // read_ip=1;
        // read_dp=0;
        // $display("read instr port");
        // repeat (7) begin
        //     @(negedge clk);
        //     $display("instr port: %h",ip_data);
        //     ip_address=ip_address+4;
        // end
        // $display("\nread data port");
        // read_ip=0;
        // read_dp=1;
        // repeat (7) begin
        //     @(negedge clk);
        //     $display("data port: %h",dp_data);
        //     dp_address=dp_address+4;
        // end
        // read_dp=0;

        // read_dp=1;
        // dp_address=32'h00000ac0;
        // repeat (2) begin
        //     $display("\nread_dp: %b",read_dp);
        //     repeat (5) begin
        //         @(negedge clk);
        //         $display("%h",dp_data);
        //         dp_address=dp_address+4;
        //     end
        //     dp_address=32'h00000ac0;
        //     read_dp=!read_dp;
        // end
        // read_dp=0;

        // $display("writing data port");
        // write_dp=1;
        // byteenable=4'b1101;
        // // dp_address=32'h0000ffac;
        // writedata=32'h11111111;
        // repeat (5) begin
        //     @(negedge clk);
        //     dp_address=dp_address+4;
        //     writedata=writedata+32'h11111111;
        // end
        // write_dp=0;
        // byteenable=4'b1111;

        // dp_address=32'h00000ac1;
        // read_dp=1;
        // $display("\nread data port");
        // repeat (5) begin
        //     @(negedge clk);
        //     $display("%h",dp_data);
        //     dp_address=dp_address+4;
        // end
        // read_dp=0;

        // read_dp=1;
        // dp_address=8191;
        // #2;
        // $display("\nend of data block: %h",dp_data);

        $finish;

    end

    mem_harvard_dbg #(.INSTR_INIT_FILE("test_data_1_20.txt"), .DATA_INIT_FILE("test_data_1_20.txt")) mem(  //instruction mem, data mem
        .clk(clk),
        .rst(rst),
        .ip_address(ip_address),
        .read_ip(read_ip),
        .ip_readdata(ip_data),
        .dp_address(dp_address),
        .writedata(writedata),
        .byteenable(byteenable),
        .read_dp(read_dp),
        .write_dp(write_dp),
        .dp_readdata(dp_data),
        .stall(stall),
        .dbg_address(dbg_address),
        .dbg_readdata(dbg_readdata)
    );


endmodule