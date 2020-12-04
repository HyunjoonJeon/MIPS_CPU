//`timescale 1ns/100ps

module decoder(
    input logic [31:0] instr_readdata,
    input logic clk_enable,
    input logic reset,
    input logic active,

    // logic from ALU that says if condition for branch is true
    input logic is_true,

    // PC
    output logic [1:0] pc_sel,
    
    // memory stuff
    // combinatorial reads and writes to data RAM
    output logic data_write,
    output logic data_read,
    output logic [3:0] byte_enable,
    
    // register file stuff(assume register number is passed directly to registerfile)
    output logic reg_write_enable,

    // mux controls 
    output logic [1:0] reg_addr_sel,
    output logic alu_sel,
    output logic [1:0] reg_data_sel,
    output logic signextend_sel,
    // bit 1 is whether LWLR, bit 0 to select between
    output logic [1:0] lwlr_sel
    );
    
    // opcode for all type R instructions = 0
    typedef enum logic[5:0] {
        OPCODE_R = 6'b000000,
        OPCODE_J = 6'b000010,
        OPCODE_JAL = 6'b000011,
        OPCODE_BRANCH = 6'b000001,
        OPCODE_BGTZ = 6'b000111,
        OPCODE_BLEZ = 6'b000110,
        OPCODE_BNE = 6'b000101,
        OPCODE_LB = 6'b100000,
        OPCODE_LH = 6'b100001,
        OPCODE_LBU = 6'b100100,
        OPCODE_LHU = 6'b100101,
        OPCODE_LW = 6'b100011,
        OPCODE_LWL = 6'b100010,
        OPCODE_LWR = 6'b100110,
        OPCODE_SW = 6'b101011,
        OPCODE_SB = 6'b101000,
        OPCODE_SH = 6'b101001
    } opcode_t;

    opcode_t instr_opcode;

    assign instr_opcode = instr_readdata[31:26];

    logic[4:0] rs;
    logic[4:0] rt;
    logic[4:0] rd;
    wire[5:0] funct_code;

    // type R
    assign rs = instr_readdata[25:21];
    assign rt = instr_readdata[20:16];
    assign rd = instr_readdata[15:11];
    assign funct_code = instr_readdata[5:0];

    // type I
    logic[15:0] immediate;
    assign immediate = instr_readdata[15:0];
    
    //type J
    logic[25:0] j_addr;
    assign j_addr = instr_readdata[25:0];

    always_comb begin
        if (clk_enable) begin
            // general stuff 
            case(instr_opcode)
                OPCODE_R: begin
                    alu_sel = 1'b0;
                    // assume rd is implied = $31 if JALR 
                    reg_addr_sel = 2'b01;
                    // sel alu out unless JALR
                    reg_data_sel = (funct_code == 6'b001001) ?  2'b11 : 2'b00;
                    // write unless funct code == JR or starts with 01 -> uses HI and LO
                    reg_write_enable = (funct_code == 6'b001000 || funct_code[5] == 1'b0 && funct_code[4] == 1'b1) ? 1'b0:1'b1;
                    // if its JR or uses HI & LO
                    if (funct_code == 6'b001000 || funct_code[5] == 1'b0 && funct_code[4] == 1'b1) begin 
                        // if its not MFHI or MFLO
                        if (funct_code != 6'b010000 && funct_code != 6'b010010) begin
                            reg_write_enable = 1'b0;
                        end
                        // if it is MFHI or MFLO then write
                        else begin
                            reg_write_enable = 1'b1;
                        end
                    end
                    else begin
                        reg_write_enable = 1'b1;
                    end
                    // pc_sel JR if JR or JALR else pc + 4
                    pc_sel = (funct_code == 6'b001000 || funct_code == 6'b001001) ? 2'b11 : 2'b00;
                    byte_enable = 4'b1111;
                    data_read = 1'b0;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
                OPCODE_BRANCH: begin
                    // BGEZ and BLTZ (branch no link)
                    reg_addr_sel = 2'b11;
                    reg_data_sel = 2'b11;
                    // condition for link
                    reg_write_enable = (rt[4] == 1'b1 && is_true) ? 1'b1 : 1'b0;
                    pc_sel = 2'b01;
                    data_read = 1'b0;
                    data_write = 1'b0;
                    byte_enable = 4'b1111;
                    lwlr_sel = 2'b00;
                end
                // BGTZ, BLEZ, BNE have the same controls
                OPCODE_BGTZ: begin
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b0;
                    pc_sel = is_true ? 2'b01 : 2'b00;
                    byte_enable = 4'b1111;
                    data_read = 1'b0;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
                OPCODE_BLEZ: begin
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b0;
                    pc_sel = is_true ? 2'b01 : 2'b00;
                    byte_enable = 4'b1111;
                    data_read = 1'b0;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
                OPCODE_BNE: begin
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b0;
                    pc_sel = is_true ? 2'b01 : 2'b00;
                    byte_enable = 4'b1111;
                    data_read = 1'b0;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
                OPCODE_LB: begin
                    reg_addr_sel = 2'b00;
                    reg_data_sel = 2'b10;
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b1;
                    pc_sel = 2'b00;
                    byte_enable = 4'b0001;
                    data_read = 1'b1;
                    data_write = 1'b0;
                    signextend_sel = 1'b0;
                    lwlr_sel = 2'b00;
                end
                OPCODE_LH: begin
                    reg_addr_sel = 2'b00;
                    reg_data_sel = 2'b10;
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b1;
                    pc_sel = 2'b00;
                    byte_enable = 4'b0011;
                    data_read = 1'b1;
                    data_write = 1'b0;
                    signextend_sel = 1'b1;
                    lwlr_sel = 2'b00;
                end 
                OPCODE_LBU: begin
                    reg_addr_sel = 2'b00;
                    reg_data_sel = 2'b01;
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b1;
                    pc_sel = 2'b00;
                    byte_enable = 4'b0001;
                    data_read = 1'b1;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
                OPCODE_LHU: begin
                    reg_addr_sel = 2'b00;
                    reg_data_sel = 2'b01;
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b1;
                    pc_sel = 2'b00;
                    byte_enable = 4'b0011;
                    data_read = 1'b1;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
                OPCODE_LW: begin
                    reg_addr_sel = 2'b00;
                    reg_data_sel = 2'b01;
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b1;
                    pc_sel = 2'b00;
                    byte_enable = 4'b1111;
                    data_read = 1'b1;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
                OPCODE_LWL: begin
                    alu_sel = 1'b1;
                    reg_addr_sel = 2'b00;
                    reg_data_sel = 2'b00;
                    reg_write_enable = 1'b1;
                    pc_sel = 2'b00;
                    byte_enable = 4'b1111;
                    data_read = 1'b1;
                    data_write = 1'b0;
                    lwlr_sel = 2'b11;
                end
                OPCODE_LWR: begin
                    alu_sel = 1'b1;
                    reg_addr_sel = 2'b00;
                    reg_data_sel = 2'b00;
                    reg_write_enable = 1'b1;
                    pc_sel = 2'b00;
                    byte_enable = 4'b1111;
                    data_read = 1'b1;
                    data_write = 1'b0;
                    lwlr_sel = 2'b10;
                end
                OPCODE_SW: begin
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b0;
                    pc_sel = 2'b00;
                    byte_enable = 4'b1111;
                    data_read = 1'b0;
                    data_write = 1'b1;
                    lwlr_sel = 2'b00;
                end
                OPCODE_LB: begin
                    reg_addr_sel = 2'b00;
                    reg_data_sel = 2'b01;
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b1;
                    pc_sel = 2'b00;
                    byte_enable = 4'b0001;
                    data_read = 1'b1;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
                OPCODE_SB: begin
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b0;
                    pc_sel = 2'b00;
                    byte_enable = 4'b0001;
                    data_read = 1'b0;
                    data_write = 1'b1;
                    lwlr_sel = 2'b00;
                end
                OPCODE_SH: begin
                    alu_sel = 1'b1;
                    reg_write_enable = 1'b0;
                    pc_sel = 2'b00;
                    byte_enable = 4'b0011;
                    data_read = 1'b0;
                    data_write = 1'b1;
                    lwlr_sel = 2'b00;
                end
                OPCODE_J: begin
                    pc_sel = 2'b10;
                    reg_write_enable = 0;
                    byte_enable = 4'b1111;
                    data_read = 1'b0;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
                OPCODE_JAL: begin
                    pc_sel = 2'b10;
                    reg_addr_sel = 2'b11;
                    reg_data_sel = 2'b11;
                    reg_write_enable = 1;
                    byte_enable = 4'b1111;
                    data_read = 1'b0;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
                // everything else (type I arithmetics: rt = alu)
                default: begin
                    alu_sel = 1'b1;
                    reg_addr_sel = 2'b00;
                    reg_data_sel = 2'b00;
                    reg_write_enable = 1'b1;
                    pc_sel = 2'b00;
                    byte_enable = 4'b1111;
                    data_read = 1'b0;
                    data_write = 1'b0;
                    lwlr_sel = 2'b00;
                end
            endcase
        end
    end

endmodule