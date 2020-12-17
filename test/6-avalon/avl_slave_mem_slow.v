module avl_slave_mem_slow(
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
    
    parameter DELAY = 100;

    logic[1:0] state;

    logic[7:0] data[BLOCK_SIZE-1:0];
    logic[7:0] instr[BLOCK_SIZE-1:0];
    logic[7:0] block3[BLOCK_SIZE-1:0];

    logic[31:0] counter;
    logic[31:0] next_counter;

    parameter b3_start = 32'hffffffff-(BLOCK_SIZE-1);

    //tmp blocks for mem initialisation
    logic[31:0] init_b1 [(BLOCK_SIZE/4)-1:0];
    logic[31:0] init_b2 [(BLOCK_SIZE/4)-1:0];

    logic[31:0] b0_address, b1_address, b2_address, b3_address;
    logic[1:0] offset;

    assign b0_address = address;
    assign b1_address = address+1;
    assign b2_address = address+2;
    assign b3_address = address+3;
    assign offset = address[1:0];

    assign next_counter=counter+1;

    initial begin
        integer i;
        for(i=0; i<BLOCK_SIZE; i++) begin     //change initial values back to 0 after testing
            data[i]=0;
            instr[i]=0;
            block3[i]=0;
        end
        for(i=0; i<(BLOCK_SIZE/4);i++) begin
            init_b1[i]=0;
            init_b2[i]=0;
        end
        if(INSTR_INIT_FILE!="") begin
            $readmemh(INSTR_INIT_FILE,init_b2);
            for(i=0;i<(BLOCK_SIZE/4);i++) begin
                instr[4*i]=init_b2[i];
                instr[4*i+1]=init_b2[i]>>8;
                instr[4*i+2]=init_b2[i]>>16;
                instr[4*i+3]=init_b2[i]>>24;
            end
        end
        if(DATA_INIT_FILE!="") begin
            $readmemh(DATA_INIT_FILE,init_b1);
            for(i=0;i<(BLOCK_SIZE/4);i++) begin
                data[4*i]=init_b1[i];
                data[4*i+1]=init_b1[i]>>8;
                data[4*i+2]=init_b1[i]>>16;
                data[4*i+3]=init_b1[i]>>24;
            end
        end
        readdata=0;
        waitrequest=0;
        state=IDLE;
        counter=0;
    end

    always @* begin     //avalon address alignment and read/write checks
        if(read & write) $fatal(2,"Avalon Read and Write asserted simultaneously! Transaction address:%h",address);
        if(offset!=0 && (read^write)) $fatal(2,"Attempted to access non word-aligned memory address:%h",address);
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
            readdata<=0;
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
                    if(counter<DELAY) begin
                        counter<=next_counter;
                    end
                    else begin
                        if(read==1 && write==0) begin   //read
                            readdata[7:0] <= !byteenable[0] ? 8'h00 : (b0_address<32'hbfc00000) ? data[b0_address] : (b0_address<b3_start) ? instr[b0_address-32'hbfc00000] : block3[b0_address-b3_start];
                            readdata[15:8] <= !byteenable[1] ? 8'h00 : (b1_address<32'hbfc00000) ? data[b1_address] : (b1_address<b3_start) ? instr[b1_address-32'hbfc00000] : block3[b1_address-b3_start];
                            readdata[23:16] <= !byteenable[2] ? 8'h00 : (b2_address<32'hbfc00000) ? data[b2_address] : (b2_address<b3_start) ? instr[b2_address-32'hbfc00000] : block3[b2_address-b3_start];
                            readdata[31:24] <= !byteenable[3] ? 8'h00 : (b3_address<32'hbfc00000) ? data[b3_address] : (b3_address<b3_start) ? instr[b3_address-32'hbfc00000] : block3[b3_address-b3_start];                        
                        end
                        else if(read==0 && write==1) begin  //write
                            if(byteenable[0]) begin
                                if(b0_address<32'hbfc00000) data[b0_address] <= writedata[7:0];
                                else if(b0_address<b3_start) instr[b0_address-32'hbfc00000] <= writedata[7:0];
                                else block3[b0_address-b3_start] <= writedata[7:0];
                            end

                            if(byteenable[1]) begin
                                if(b1_address<32'hbfc00000) data[b1_address] <= writedata[15:8];
                                else if(b1_address<b3_start) instr[b1_address-32'hbfc00000] <= writedata[15:8];
                                else block3[b1_address-b3_start] <= writedata[15:8];
                            end

                            if(byteenable[2]) begin
                                if(b2_address<32'hbfc00000) data[b2_address] <= writedata[23:16];
                                else if(b2_address<b3_start) instr[b2_address-32'hbfc00000] <= writedata[23:16];
                                else block3[b2_address-b3_start] <= writedata[23:16];
                            end

                            if(byteenable[3]) begin
                                if(b3_address<32'hbfc00000) data[b3_address] <= writedata[31:24];
                                else if(b3_address<b3_start) instr[b3_address-32'hbfc00000] <= writedata[31:24];
                                else block3[b3_address-b3_start] <= writedata[31:24];
                            end
                        end
                        //end mem op
                        state<=CHILL;
                    end
                end
                CHILL: begin
                    counter<=0;
                    state<=IDLE;
                end
            endcase
        end
    end

endmodule