module mips_cpu_harvard_tb;
    timeunit 1ns / 100ps; //time unit and precision

    parameter INSTR_INIT_FILE = "test/1-binary/subu/subu_2.hex.txt";
    parameter DATA_INIT_FILE = "";
    parameter TIMEOUT_CYCLES = 40;

    logic clk;
    logic rst;
    logic clk_enable;

    logic active;
    logic[31:0] register_v0;

    // Avalon bus connections
    logic[31:0] address, writedata, readdata;
    logic[3:0] byteenable;
    logic read, write, waitrequest;

    integer counter;

    // Generate clock
    initial begin
        clk=0;
        counter=0;
        repeat (TIMEOUT_CYCLES) begin
            #1;
            clk = !clk;            
            #1;
            clk = !clk;
            counter++;
        end
        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end

    initial begin
        $display("");
        clk_enable=1;
        rst = 0;
        #1;

        @(posedge clk); //reset
        rst = 1;
        @(posedge clk);
        #2;
        rst = 0;
        
        assert(active==1) //make sure it is running
        else $display("TB : CPU did not set running=1 after reset.");
        @(negedge active);

        $display("TB : finished; active=0");
        $display("register_v0:%h", register_v0);
    
        $finish;
        
    end

    avl_slave_mem #(.INSTR_INIT_FILE(INSTR_INIT_FILE), .DATA_INIT_FILE(DATA_INIT_FILE), .BLOCK_SIZE(8192)) avlMem(
        .clk(clk),
        .rst(rst),
        .address(address),
        .byteenable(byteenable),
        .writedata(writedata),
        .read(read),
        .write(write),
        .readdata(readdata),
        .waitrequest(waitrequest)
    );

    mips_cpu_bus CPU(
        .clk(clk),
        .reset(rst),
        .active(active),
        .register_v0(register_v0),
        .address(address),
        .write(write),
        .read(read),
        .waitrequest(waitrequest),
        .writedata(writedata),
        .byteenable(byteenable),
        .readdata(readdata)
    );    
endmodule
