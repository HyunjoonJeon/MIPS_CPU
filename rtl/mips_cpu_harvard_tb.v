module mips_cpu_harvard_tb;
    timeunit 1ns / 100ps; //time unit and precision

    parameter INSTR_INIT_FILE = "test/1-binary/addiu.hex.txt";
    parameter DATA_INIT_FILE = "";
    parameter TIMEOUT_CYCLES = 40;

    logic clk;
    logic rst;
    logic clk_enable;

    logic active;
    logic[31:0] register_v0;

    logic[31:0] instr_address;
    logic instr_read;
    logic[31:0] instr_readdata;
    
    logic[31:0] data_address;
    logic[31:0] data_writedata;
    logic[3:0] byte_enable;
    logic data_read;
    logic data_write;
    logic[31:0] data_readdata;

    integer counter;

    mem_harvard #(.INSTR_INIT_FILE(INSTR_INIT_FILE), .DATA_INIT_FILE(DATA_INIT_FILE), .BLOCK_SIZE(8192)) instrInst(.clk(clk), .rst(rst), .ip_address(instr_address), .read_ip(instr_read), .ip_readdata(instr_readdata),.dp_address(data_address), .writedata(data_writedata), .byteenable(byte_enable), .read_dp(data_read), .write_dp(data_write)); //input the INSTR_INIT_FILE
    // mem_harvard #(DATA_INIT_FILE) dataInst(.clk(clk), .rst(rst), .ip_address(instr_address), .read_ip(instr_read), .dp_address(data_address), .writedata(data_writedata), .byteenable(byte_enable), .read_dp(data_read), .write_dp(data_write), .dp_readdata(data_readdata)); 
    mips_cpu_harvard cpuInst(.clk(clk), .clk_enable(clk_enable), .reset(rst), .active(active), .register_v0(register_v0), .instr_readdata(instr_readdata), .instr_address(instr_address), .instr_read(instr_read), .byte_enable(byte_enable), .data_address(data_address), .data_write(data_write), .data_read(data_read), .data_readdata(data_readdata));

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
        $display("end instr address: %h", instr_address);
        $display("end data: %h",instr_readdata);
        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end

    initial begin
        $display("");
        clk_enable=1;
        rst = 0;

        //test mem
        // instr_address=32'hbfc00000;
        // instr_read=1;
        #1;
        $display("active: %b",active);

        @(posedge clk); //reset
        rst = 1;
        @(posedge clk);
        #1;
        
        // @(posedge clk); //start
        rst = 0;
        
        @(posedge clk);

        $display("instr_address: %h",instr_address);
        $display("instr data: %h",instr_readdata);
        $display("read mem: %b",instr_read);
        $display("active: %b",active);
        // assert(active==1) //make sure it is running
        // else $display("TB : CPU did not set running=1 after reset.");
        #4;
        $display("probe: %h",data_address);
        @(negedge active);

        // while (active) begin
        //     @(posedge clk);
        // end

        $display("TB : finished; active=0");
        $display("register_v0:%d", register_v0);
    
        $finish;
        
    end

    

endmodule
