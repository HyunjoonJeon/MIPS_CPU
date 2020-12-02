module mips_cpu_harvard_tb;
    timeunit 1ns / 100ps; //time unit and precision

    parameter INSTR_INIT_FILE = "test/1-binary/addiu.hex.txt";
    parameter DATA_INIT_FILE = "";
    parameter TIMEOUT_CYCLES = 300;

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

    mem_harvard #(INSTR_INIT_FILE) instrInst(.clk(clk), .rst(rst), .ip_address(instr_address), .read_ip(instr_read), .ip_readdata(instr_readdata),.dp_address(data_address), .writedata(data_writedata), .byteenable(byte_enable), .read_dp(data_read), .write_dp(data_write)); //input the INSTR_INIT_FILE
    mem_harvard #(DATA_INIT_FILE) dataInst(.clk(clk), .rst(rst), .ip_address(instr_address), .read_ip(instr_read), .dp_address(data_address), .writedata(data_writedata), .byteenable(byte_enable), .read_dp(data_read), .write_dp(data_write), .dp_readdata(data_readdata)); 
    mips_cpu_harvard cpuInst(.clk(clk), .clk_enable(clk_enable), .reset(rst), .active(active), .register_v0(register_v0), .instr_readdata(instr_readdata), .instr_address(instr_address), .instr_read(instr_read), .byte_enable(byte_enable), .data_address(data_address), .data_write(data_write), .data_read(data_read), .data_readdata(data_readdata));

    // Generate clock
    initial begin
        clk=0;
	clk_enable = 1;
        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            
            #10;
            clk = !clk;
	    
        end

        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end

    initial begin
        rst <= 0;

        @(posedge clk); //reset
        rst <= 1;
        
        @(posedge clk); //start
        rst <= 0;
        
        @(posedge clk);
        assert(active==1) //make sure it is running
        else $display("TB : CPU did not set running=1 after reset.");
	
        while (active) begin
            @(posedge clk);
        end

        $display("TB : finished; active=0");
        $display("register_v0:%d", register_v0);
    
        $finish;
        
    end

    

endmodule
