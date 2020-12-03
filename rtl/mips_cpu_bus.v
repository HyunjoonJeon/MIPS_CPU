module mips_cpu_bus(
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);
    // harvard mem wires
    logic[31:0] instr_address, instr_readdata;  //instr port
    logic instr_read;
    logic[31:0] data_address, data_writedata, data_readdata;    //data port
    logic[3:0] data_byteenable;
    logic data_write, data_read;

    // intermediate wires
    wire clk_enable, stall;

    assign clk_enable = !stall;
    
    harvard_to_avalon memBus(
        .clk(clk),
        .rst(reset),
        .stall(stall),
        //harvard IOs
        .ip_address(instr_address),
        .read_ip(instr_read),
        .ip_data(instr_readdata),
        .dp_address(data_address),
        .writedata(data_writedata),
        .byteenable(data_byteenable),
        .read_dp(data_read),
        .write_dp(data_write),
        .dp_data(data_readdata),
        //Avalon IOs
        .avl_readdata(readdata),
        .avl_waitrequest(waitrequest),
        .avl_address(address),
        .avl_byteenable(byteenable),
        .avl_writedata(writedata),
        .avl_read(read),
        .avl_write(write)
    );

    mips_cpu_harvard cpuInst(
        .clk(clk),
        .clk_enable(clk_enable),
        .reset(reset),
        .active(active),
        .register_v0(register_v0),
        .instr_readdata(instr_readdata),
        .instr_address(instr_address),
        .instr_read(instr_read),
        .byte_enable(data_byteenable),
        .data_address(data_address),
        .data_write(data_write),
        .data_read(data_read),
        .data_writedata(data_writedata),
        .data_readdata(data_readdata)
    );

endmodule