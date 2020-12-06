module harvard_to_avalon(
    input logic clk,
    input logic rst,
    output logic stall,

    //Harvard Data IOs
    input logic[31:0] ip_address,   //Instruction port
    input logic read_ip,
    output logic[31:0] ip_data,

    input logic[31:0] dp_address,   //Data port
    input logic[31:0] writedata,
    input logic[3:0] byteenable,
    input logic read_dp,
    input logic write_dp,
    output logic[31:0] dp_data,

    //Avalon IOs
    input logic[31:0] avl_readdata,
    input logic avl_waitrequest,
    output logic[31:0] avl_address,
    output logic[3:0] avl_byteenable,
    output logic[31:0] avl_writedata,
    output logic avl_read,
    output logic avl_write
);
    typedef enum logic[2:0] {
        IDLE = 3'b000,
        INSTR = 3'b011,
        DATA = 3'b111,
        CLEAR = 3'b101,
        ISET = 3'b110,
        CHILL = 3'b001
    } state_t;

    //avalon bus controller wires
    logic[31:0] bus_address;
    logic[31:0] bus_writedata;
    logic[3:0] bus_byteenable;
    logic bus_read;
    logic bus_write;
    logic[31:0] bus_readdata;
    logic bus_busy;

    logic[2:0] state;

    initial begin
        state=IDLE;
        bus_address=0;
        bus_writedata=0;
        bus_byteenable=4'b1111;
        bus_read=0;
        bus_write=0;
        ip_data=0;
        dp_data=0;
        stall=0;
    end

    always_comb begin
        if(state==IDLE) begin
            stall=(read_dp^write_dp) | read_ip;
            bus_address = (read_dp^write_dp) ? dp_address : ip_address;
            bus_writedata = (read_dp^write_dp) ? writedata : 0;
            bus_byteenable = (read_dp^write_dp) ? byteenable : 4'b1111;
            bus_read = (read_dp^write_dp) ? read_dp : read_ip;
            bus_write = (read_dp^write_dp) ? write_dp : 0;
        end
        else if(state==INSTR) begin
            stall=1;            
            bus_address=ip_address;
            bus_writedata=0;
            bus_byteenable=4'b1111;
            bus_read=1;
            bus_write=0;
        end
        else if(state==DATA) begin
            stall=1;
            bus_address=dp_address;
            bus_writedata=writedata;
            bus_byteenable=byteenable;
            bus_read=read_dp;
            bus_write=write_dp;
        end
        else if(state==CLEAR) begin
            stall=1;
            bus_address=ip_address;
            bus_writedata=0;
            bus_byteenable=4'b1111;
            bus_read=0;
            bus_write=0;
        end
        else if(state==ISET) begin
            stall=1;
            bus_address=ip_address;
            bus_writedata=0;
            bus_byteenable=4'b1111;
            bus_read=1;
            bus_write=0;
        end
        else if(state==CHILL) begin
            stall=0;
            bus_address = (read_dp^write_dp) ? dp_address : ip_address;
            bus_writedata = (read_dp^write_dp) ? writedata : 0;
            bus_byteenable = (read_dp^write_dp) ? byteenable : 4'b1111;
            bus_read=0;
            bus_write=0;
        end

    end

    always_ff @(posedge clk) begin
        if(rst) begin
            state=IDLE;
            bus_address=0;
            bus_writedata=0;
            bus_byteenable=4'b1111;
            bus_read=0;
            bus_write=0;
            ip_data=0;
            dp_data=0;
            stall=0;
        end
        else begin
            if(state==IDLE) begin
                if(read_dp^write_dp) begin
                    state<=DATA;
                end
                else if(read_ip) begin
                    state<=INSTR;
                end
            end
            else if(state==INSTR) begin
                if(!bus_busy) begin
                    ip_data<=bus_readdata;
                    state<=CHILL;
                end
            end
            else if(state==DATA) begin
                if(!bus_busy) begin
                    if(read_dp) begin
                        dp_data<=bus_readdata;
                    end
                    else if(write_dp) begin
                        dp_data<=writedata;
                    end
                    if(read_ip) begin
                        state<=CLEAR;
                    end
                    else begin
                        state<=CHILL;
                    end
                end
            end
            else if(state==CLEAR) begin
                state<=ISET;
            end
            else if(state==ISET) begin
                state<=INSTR;
            end
            else if(state==CHILL) begin
                state<=IDLE;
            end
        end
    end

    //////// bus controller /////////////////////////////////////////////
    avl_master_bc bus_con(
        clk,
        rst,
        avl_readdata,
        avl_waitrequest,
        avl_address,
        avl_byteenable,
        avl_writedata,
        avl_read,
        avl_write,
        bus_address,
        bus_writedata,
        bus_byteenable,
        bus_read,
        bus_write,
        bus_readdata,
        bus_busy
    );
endmodule