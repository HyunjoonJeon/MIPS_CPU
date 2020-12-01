module mem_harvard_dbg(     //async output, readdata output maintains value when read is not asserted
    input logic clk,
    input logic rst,
    
    //Instruction port
    input logic[31:0] ip_address,
    input logic read_ip,
    output logic[31:0] ip_readdata,

    //Data port
    input logic[31:0] dp_address,
    input logic[31:0] writedata,
    input logic[3:0] byteenable,
    input logic read_dp,
    input logic write_dp,
    output logic[31:0] dp_readdata,

    //Debug port (fully async)
    input logic[31:0] dbg_address,
    output logic[31:0] dbg_readdata,

    output logic stall
);

    parameter INSTR_INIT_FILE = "";
    parameter DATA_INIT_FILE = "";
    parameter BLOCK_SIZE = 8192;

    logic[7:0] block1 [BLOCK_SIZE-1:0];   //data block
    logic[7:0] block2 [BLOCK_SIZE-1:0];  //instruction block
    logic[31:0] tmp_idata;
    logic[31:0] tmp_ddata;

    wire[7:0] ti0,ti1,ti2,ti3;
    wire[7:0] td0,td1,td2,td3;
    wire ben0, ben1, ben2, ben3;
    wire[31:0] ip_offset_address;

    initial begin
        integer i;
        for(i=0;i<BLOCK_SIZE;i++) begin   //init values set to non-zero for testing, remember to change them back to 0
            block1[i]=0;
            block2[i]=0;
        end
        if(INSTR_INIT_FILE!="") begin
            $display("loading instruction mem with %s",INSTR_INIT_FILE);
            $readmemh(INSTR_INIT_FILE,block2);
        end
        if(DATA_INIT_FILE!="") begin
            $display("loading data mem with %s",DATA_INIT_FILE);
            $readmemh(DATA_INIT_FILE,block1);
        end
        tmp_idata=0;
        tmp_ddata=0;
        stall=0;      
    end

    assign ip_offset_address = ip_address-32'hbfc00000;

    assign ben0 = byteenable[0];
    assign ben1 = byteenable[1];
    assign ben2 = byteenable[2];
    assign ben3 = byteenable[3];

    assign ti0 = tmp_idata[7:0];
    assign ti1 = tmp_idata[15:8];
    assign ti2 = tmp_idata[23:16];
    assign ti3 = tmp_idata[31:24];

    assign td0 = tmp_ddata[7:0];
    assign td1 = tmp_ddata[15:8];
    assign td2 = tmp_ddata[23:16];
    assign td3 = tmp_ddata[31:24];

    always_comb begin
        ip_readdata[7:0] = read_ip ? block2[ip_offset_address] : ti0;
        ip_readdata[15:8] = read_ip ? block2[ip_offset_address+1] : ti1;
        ip_readdata[23:16] = read_ip ? block2[ip_offset_address+2] : ti2;
        ip_readdata[31:24] = read_ip ? block2[ip_offset_address+3] : ti3;

        dp_readdata[7:0] = read_dp ? (ben0 ? block1[dp_address] : 8'h00) : td0;
        dp_readdata[15:8] = read_dp ? (ben1 ? block1[dp_address+1] : 8'h00) : td1;
        dp_readdata[23:16] = read_dp ? (ben2 ? block1[dp_address+2] : 8'h00) : td2;
        dp_readdata[31:24] = read_dp ? (ben3 ? block1[dp_address+3] : 8'h00) : td3;        

        //Debug port
        dbg_readdata[7:0] = (dbg_address<32'hbfc00000) ? block1[dbg_address] : block2[dbg_address-32'hbfc00000];
        dbg_readdata[15:8] = (dbg_address<32'hbfc00000) ? block1[dbg_address+1] : block2[dbg_address-32'hbfc00000+1];
        dbg_readdata[23:16] = (dbg_address<32'hbfc00000) ? block1[dbg_address+2] : block2[dbg_address-32'hbfc00000+2];
        dbg_readdata[31:24] = (dbg_address<32'hbfc00000) ? block1[dbg_address+3] : block2[dbg_address-32'hbfc00000+3];
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            tmp_idata=0;
            tmp_ddata=0;
            stall=0;
        end
        else begin
            if(read_ip==1) begin
                tmp_idata[7:0]<=block2[ip_offset_address];
                tmp_idata[15:8]<=block2[ip_offset_address+1];
                tmp_idata[23:16]<=block2[ip_offset_address+2];
                tmp_idata[31:24]<=block2[ip_offset_address+3];
            end
            if(write_dp==1) begin
                block1[dp_address] <= ben0 ? writedata[7:0] : block1[dp_address];
                block1[dp_address+1] <= ben1 ? writedata[15:8] : block1[dp_address+1];
                block1[dp_address+2] <= ben2 ? writedata[23:16] : block1[dp_address+2];
                block1[dp_address+3] <= ben3 ? writedata[31:24] : block1[dp_address+3];

                tmp_ddata[7:0] <= ben0 ? writedata[7:0] : tmp_ddata[7:0];
                tmp_ddata[15:8] <= ben1 ? writedata[15:8] : tmp_ddata[15:8];
                tmp_ddata[23:16] <= ben2 ? writedata[23:16] : tmp_ddata[23:16];
                tmp_ddata[31:24] <= ben3 ? writedata[31:24] : tmp_ddata[31:24];
            end
            else if(read_dp==1) begin
                tmp_ddata[7:0]<=block1[dp_address];
                tmp_ddata[15:8]<=block1[dp_address+1];
                tmp_ddata[23:16]<=block1[dp_address+2];
                tmp_ddata[31:24]<=block1[dp_address+3];
            end
        end
    end
    
endmodule