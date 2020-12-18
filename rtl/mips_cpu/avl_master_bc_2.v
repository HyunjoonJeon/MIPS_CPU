module avl_master_bc_2(
    input logic clk,
    input logic rst,

    //Avalon IOs
    input logic[31:0] avl_readdata,
    input logic avl_waitrequest,
    output logic[31:0] avl_address,
    output logic[3:0] avl_byteenable,
    output logic[31:0] avl_writedata,
    output logic avl_read,
    output logic avl_write,

    //Data IOs
    input logic[31:0] address,
    input logic[31:0] write_data,
    input logic[3:0] byteenable,
    input logic read_select,
    input logic write_select,
    output logic[31:0] read_data,
    output logic busy
);

    typedef enum logic[1:0] {
        IDLE = 2'b00,
        WAIT = 2'b11
    } state_t;

    logic[1:0] state;
    logic tmp_r;
    logic tmp_w;
    logic[31:0] tmp_addr;
    logic[3:0] tmp_ben;
    logic[31:0] tmp_rdata;
    logic[31:0] tmp_wdata;
    logic[31:0] tmp_avl_readdata;

    logic[31:0] proc_address;
    logic[1:0] offset;
    logic[31:0] proc_writedata;
    logic[31:0] proc_readdata;
    logic[3:0] proc_ben;

    assign proc_address[31:2] = address[31:2];
    assign proc_address[1:0] = 2'b00;
    assign offset = address[1:0];

    assign tmp_avl_readdata[7:0] = tmp_ben[0] ? avl_readdata[7:0] : 8'h00;
    assign tmp_avl_readdata[15:8] = tmp_ben[1] ? avl_readdata[15:8] : 8'h00;
    assign tmp_avl_readdata[23:16] = tmp_ben[2] ? avl_readdata[23:16] : 8'h00;
    assign tmp_avl_readdata[31:24] = tmp_ben[3] ? avl_readdata[31:24] : 8'h00;

    initial begin
        state=IDLE;
        tmp_rdata=0;
        avl_address=0;
        avl_writedata=0;
        avl_read=0;
        avl_write=0;
        tmp_addr=0;
        tmp_ben=4'b1111;
        tmp_r=0;
        tmp_w=0;
    end

    always_comb begin
        case (offset)
            2'b00: begin 
                proc_ben = byteenable;
                proc_writedata = write_data;
            end
            2'b01: begin
                proc_ben = byteenable<<1;
                proc_writedata = write_data<<8;
            end
            2'b10: begin
                proc_ben = byteenable<<2;
                proc_writedata = write_data<<16;
            end
            2'b11: begin
                proc_ben = byteenable<<3;
                proc_writedata = write_data<<24;
            end
        endcase
        if(state==IDLE) begin
            avl_address=proc_address;
            avl_writedata=proc_writedata;
            proc_readdata=tmp_rdata;
            avl_read=read_select & !rst;
            avl_write=write_select & !rst;
            avl_byteenable=proc_ben;
            busy=0;
        end
        else if(state==WAIT)    begin
            avl_address=tmp_addr;
            avl_writedata=tmp_wdata;
            proc_readdata = (avl_waitrequest) ? tmp_rdata : tmp_avl_readdata;
            avl_read=tmp_r;
            avl_write=tmp_w;
            avl_byteenable=tmp_ben;
            busy = avl_waitrequest;
        end        
        case (offset)
            2'b00: read_data = proc_readdata;
            2'b01: read_data = proc_readdata>>8;
            2'b10: read_data = proc_readdata>>16;
            2'b11: read_data = proc_readdata>>24;
        endcase
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            tmp_addr<=0;
            tmp_rdata<=0;
            tmp_wdata<=0;
            tmp_ben<=4'b1111;
            tmp_r<=0;
            tmp_w<=0;
            state<=IDLE;
        end
        else begin
            case(state)
                IDLE: begin
                    tmp_r<=read_select;
                    tmp_w<=write_select;
                    tmp_addr<=proc_address;
                    tmp_wdata<=proc_writedata;
                    tmp_ben<=proc_ben;
                    if(read_select^write_select==1)  begin
                        state<=WAIT;
                    end
                end
                WAIT: begin
                    if(avl_waitrequest==0) begin   
                        if(tmp_r==1) begin
                            tmp_rdata[7:0] <= tmp_ben[0] ? avl_readdata[7:0] : 8'h00;
                            tmp_rdata[15:8] <= tmp_ben[1] ? avl_readdata[15:8] : 8'h00;
                            tmp_rdata[23:16] <= tmp_ben[2] ? avl_readdata[23:16] : 8'h00;
                            tmp_rdata[31:24] <= tmp_ben[3] ? avl_readdata[31:24] : 8'h00;
                        end                                     
                        state<=IDLE;
                    end
                end
            endcase
        end
    end

endmodule
