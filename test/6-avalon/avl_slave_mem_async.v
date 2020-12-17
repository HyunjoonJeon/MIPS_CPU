module avl_slave_mem_async(
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

    parameter INSTR_INIT_FILE = "";
    parameter DATA_INIT_FILE = "";
    parameter BLOCK_SIZE = 8192;

    logic[31:0] data [BLOCK_SIZE-1:0];
    logic[31:0] instr [BLOCK_SIZE-1:0];
    
    logic[31:0] tmp_readdata, tmp_writedata, write_carry;
    logic[7:0] b0, b1, b2, b3;
    logic ben0, ben1, ben2, ben3;
    logic[1:0] offset;

    initial begin
        integer i;
        for(i=0;i<BLOCK_SIZE;i++)   begin
            data[i]=i;
            instr[i]=i;
        end
        if(INSTR_INIT_FILE!="") begin
            $readmemh(INSTR_INIT_FILE,instr);
        end
        if(DATA_INIT_FILE!="") begin
            $readmemh(DATA_INIT_FILE,data);
        end
        readdata=0;
        waitrequest=0;
    end

    assign ben0 = byteenable[0];
    assign ben1 = byteenable[1];
    assign ben2 = byteenable[2];
    assign ben3 = byteenable[3];

    // read
    assign tmp_readdata = (address<32'hbfc00000) ? data[address>>2] : instr[(address-32'hbfc00000)>>2];
    assign b0 = tmp_readdata[7:0];
    assign b1 = tmp_readdata[15:8];
    assign b2 = tmp_readdata[23:16];
    assign b3 = tmp_readdata[31:24];
    
    //write
    assign write_carry = (address<32'hbfc00000) ? data[address>>2] : instr[(address-32'hbfc00000)>>2];
    assign tmp_writedata[7:0] = byteenable[0] ? writedata[7:0] : write_carry[7:0];
    assign tmp_writedata[15:8] = byteenable[1] ? writedata[15:8] : write_carry[15:8];
    assign tmp_writedata[23:16] = byteenable[2] ? writedata[23:16] : write_carry[23:16];
    assign tmp_writedata[31:24] = byteenable[3] ? writedata[31:24] : write_carry[31:24];

    assign offset=address[1:0];

    always @* begin     //avalon address alignment and read/write checks
        if(read & write) $fatal(2,"Avalon Read and Write asserted simultaneously! Transaction address:%h",address);
        if(offset!=0 && (read^write)) $fatal(2,"Attempted to access non word-aligned memory address:%h",address);
    end

    always_comb begin
        if(read==1) begin
            readdata[7:0] = ben0 ? b0 : 8'h00;
            readdata[15:8] = ben1 ? b1 : 8'h00;
            readdata[23:16] = ben2 ? b2 : 8'h00;
            readdata[31:24] = ben3 ? b3 : 8'h00;
        end
    end

    always_ff @(posedge clk) begin
        if(write==1) begin
            if(address<32'hbfc00000) begin
                data[address>>2] <= tmp_writedata;
            end
            else begin
                instr[(address-32'hbfc00000)>>2] <= tmp_writedata;
            end
        end
    end

endmodule