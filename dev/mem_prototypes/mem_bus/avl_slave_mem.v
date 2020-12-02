module avl_slave_mem(
    input logic clk,
    input logic rst,
    input logic[31:0] address,
    input logic[3:0] byteenable,
    input logic[31:0] writedata,
    input logic read,
    input logic write,
    output logic[31:0] readdata,
    output logic waitrequest
);
    typedef enum logic[1:0] {
        IDLE = 2'b00,
        BUSY = 2'b11,
        CHILL = 2'b01
    } state_t;

    parameter INSTR_INIT_FILE = "";
    parameter DATA_INIT_FILE = "";
    parameter BLOCK_SIZE = 8192;

    logic[1:0] state;

    reg[7:0] data[BLOCK_SIZE-1:0];
    reg[7:0] instr[BLOCK_SIZE-1:0];

    initial begin
        integer i;
        for(i=0; i<BLOCK_SIZE; i++) begin     //change initial values back to 0 after testing
            data[i]=0;
            instr[i]=0;
        end
        if(INSTR_INIT_FILE!="") begin
            readmemh(INSTR_INIT_FILE,instr);
        end
        if(DATA_INIT_FILE!="") begin
            readmemh(DATA_INIT_FILE,data);
        end
        readdata=0;
        waitrequest=0;
        state=IDLE;
    end

    always_comb begin
        if(state==IDLE) begin
            waitrequest=read^write;
        end
        else if(state==BUSY) begin
            waitrequest=1;
        end
        else if(state==CHILL) begin
            waitrequest=0;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            readdata[7:0]<=0;
            readdata[15:8]<=0;
            readdata[23:16]<=0;
            readdata[31:24]<=0;
            state<=IDLE;
        end
        else begin
            case(state)
                IDLE: begin
                    if(read^write==1) begin
                        state<=BUSY;
                    end
                end
                BUSY: begin
                    //perform mem op here
                    if(read==1 && write==0) begin   //read
                        if(address<32'hbfc00000) begin
                            readdata[7:0] <= (byteenable[0]) ? data[address] : 8'h00;
                            readdata[15:8] <= (byteenable[1]) ?  data[address+1] : 8'h00;
                            readdata[23:16] <= (byteenable[2]) ? data[address+2] : 8'h00;
                            readdata[31:24] <= (byteenable[3]) ? data[address+3] : 8'h00;
                        end
                        else begin  
                            readdata[7:0] <= byteenable[0] ? instr[(address-32'hbfc00000)] : 8'h00;
                            readdata[15:8] <= byteenable[1] ? instr[(address-32'hbfc00000+1)] : 8'h00;
                            readdata[23:16] <= byteenable[2] ? instr[(address-32'hbfc00000+2)] : 8'h00;
                            readdata[31:24] <= byteenable[3] ? instr[(address-32'hbfc00000+3)] : 8'h00;
                        end
                    end
                    else if(read==0 && write==1) begin  //write
                        if(address<32'hbfc00000) begin
                            data[address] <= byteenable[0] ? writedata[7:0] : data[address];
                            data[address+1] <= byteenable[1] ? writedata[15:8] : data[address+1];
                            data[address+2] <= byteenable[2] ? writedata[23:16] : data[address+2];
                            data[address+3] <= byteenable[3] ? writedata[31:24] : data[address+3];
                        end
                        else begin
                            instr[(address-32'hbfc00000)] <= byteenable[0] ? writedata[7:0] : instr[(address-32'hbfc00000)];
                            instr[(address-32'hbfc00000+1)] <= byteenable[1] ? writedata[15:8] : instr[(address-32'hbfc00000+1)];
                            instr[(address-32'hbfc00000+2)] <= byteenable[2] ? writedata[23:16] : instr[(address-32'hbfc00000+2)];
                            instr[(address-32'hbfc00000+3)] <= byteenable[3] ? writedata[31:24] : instr[(address-32'hbfc00000+3)];
                        end
                    end
                    //end mem op
                    state<=CHILL;
                end
                CHILL: begin
                    state<=IDLE;
                end
            endcase
        end
    end

endmodule