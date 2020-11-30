module avl_master_bc(
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
        if(state==IDLE) begin
            avl_address=address;
            avl_writedata=write_data;
            read_data=tmp_rdata;
            avl_read=read_select;
            avl_write=write_select;
            avl_byteenable=byteenable;
            busy=0;
        end
        else if(state==WAIT)    begin
            avl_address=tmp_addr;
            avl_writedata=tmp_wdata;
            read_data= (avl_waitrequest) ? tmp_rdata : avl_readdata;
            avl_read=tmp_r;
            avl_write=tmp_w;
            avl_byteenable=tmp_ben;
            // busy=1;
            busy = avl_waitrequest;
        end        
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
                    tmp_addr<=address;
                    tmp_wdata<=write_data;
                    tmp_ben<=byteenable;
                    if(read_select^write_select==1)  begin
                        state<=WAIT;
                    end
                end
                WAIT: begin
                    if(avl_waitrequest==0) begin   
                        if(tmp_r==1) begin
                            tmp_rdata<=avl_readdata;
                        end                                     
                        state<=IDLE;
                    end
                end
            endcase
        end
    end

endmodule
