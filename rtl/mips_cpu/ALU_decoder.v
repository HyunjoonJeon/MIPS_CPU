module ALU_decoder (
    input logic[31:0] instr_readdata,
    output logic[4:0] alu_control,
    output logic[2:0] branch_cond,
    output logic[4:0] sa,
    output logic LO_write_enable,
    output logic HI_write_enable
    );

    typedef enum logic[5:0] {
        OPCODE_R = 6'b000000, // refer to func_t
        OPCODE_BRANCH = 6'b000001, // for instructions BGEZ, BGEZAL, BLTZ, BLTZAL - refer to branch_t
        OPCODE_ADDIU = 6'b001001,
        OPCODE_ANDI = 6'b001100,
        OPCODE_BEQ = 6'b000100,
        OPCODE_BGTZ = 6'b000111,
        OPCODE_BLEZ = 6'b000110,
        OPCODE_BNE = 6'b000101,
        OPCODE_LB = 6'b100000,
        OPCODE_LBU = 6'b100100,
        OPCODE_LH = 6'b100001,
        OPCODE_LHU = 6'b100101,
        OPCODE_LW = 6'b100011,
        OPCODE_LWL = 6'b100010,
        OPCODE_LWR = 6'b100110,
        OPCODE_ORI = 6'b001101,
        OPCODE_SB = 6'b101000,
        OPCODE_SH = 6'b101001,
        OPCODE_SLTI = 6'b001010,
        OPCODE_SLTIU = 6'b001011,
        OPCODE_SW = 6'b101011,
        OPCODE_XORI = 6'b001110,
        OPCODE_LUI = 6'b001111,
        OPCODE_J = 6'b000010,
        OPCODE_JAL = 6'b000011
    } opcode_t;

    typedef enum logic[5:0] { // for R-type instructions (OPCODE = 000000)
        FUNC_ADDU = 6'b100001,
        FUNC_AND = 6'b100100,
        FUNC_MULT = 6'b011000,
        FUNC_MULTU = 6'b011001,
        FUNC_OR = 6'b100101,
        FUNC_SLL = 6'b000000,
        FUNC_SLLV = 6'b000100,
        FUNC_SLT = 6'b101010,
        FUNC_SLTU = 6'b101011,
        FUNC_SRA = 6'b000011,
        FUNC_SRAV = 6'b000111,
        FUNC_SRL = 6'b000010,
        FUNC_SRLV = 6'b000110,
        FUNC_SUBU = 6'b100011,
        FUNC_XOR = 6'b100110,
        FUNC_DIV = 6'b011010,
        FUNC_DIVU = 6'b011011,
        FUNC_MTLO = 6'b010011,
        FUNC_MTHI = 6'b010001,
        FUNC_JALR = 6'b001001,
        FUNC_JR = 6'b001000
    } func_t;

    typedef enum logic[4:0] { // for Branch instructions (OPCODE = 000001)
        BRANCH_BGEZ = 5'b00001,
        BRANCH_BGEZAL = 5'b10001,
        BRANCH_BLTZ = 5'b00000,
        BRANCH_BLTZAL = 5'b10000
    } branch_t;

    typedef enum logic[4:0] {
        CONTROL_ADD = 5'b00000,
        CONTROL_SUB = 5'b00001,
        CONTROL_AND = 5'b00010,
        CONTROL_ANDI = 5'b00011,
        CONTROL_OR = 5'b00100,
        CONTROL_ORI = 5'b00101,
        CONTROL_XOR = 5'b00110,
        CONTROL_XORI = 5'b00111,
        CONTROL_SLT = 5'b01000,
        CONTROL_SLTU = 5'b01001,
        CONTROL_SLL = 5'b01010,
        CONTROL_SLLV = 5'b01011,
        CONTROL_SRL = 5'b01100,
        CONTROL_SRLV = 5'b01101,
        CONTROL_SRA = 5'b01110,
        CONTROL_SRAV = 5'b01111,
        CONTROL_MULT = 5'b10000,
        CONTROL_MULTU = 5'b10001,
        CONTROL_DIV = 5'b10010,
        CONTROL_DIVU = 5'b10011,
        CONTROL_LUI = 5'b10100,
        CONTROL_MTLO = 5'b10101,
        CONTROL_MTHI = 5'b10110,
        CONTROL_LWLR = 5'b10111
    } alu_control_t;

    opcode_t instr_opcode;
    func_t func_code;
    branch_t branch_field;
    
    initial begin
        alu_control = 5'd0;
        branch_cond = 3'd0;
        LO_write_enable = 1'b0;
        HI_write_enable = 1'b0;
    end

    assign instr_opcode = instr_readdata[31:26];
    assign func_code = instr_readdata[5:0];
    assign branch_field = instr_readdata[20:16];
    assign sa = instr_readdata[10:6];

    always_comb begin
        if (instr_opcode == OPCODE_R) begin
            case(func_code)
                FUNC_ADDU: begin
                    alu_control = CONTROL_ADD;
                end
                FUNC_AND: begin
                    alu_control = CONTROL_AND;
                end
                FUNC_OR: begin
                    alu_control = CONTROL_OR;
                end
                FUNC_MULT: begin
                    alu_control = CONTROL_MULT;
                end
                FUNC_MULTU: begin
                    alu_control = CONTROL_MULTU;
                end
                FUNC_SLL: begin
                    alu_control = CONTROL_SLL;
                end
                FUNC_SLLV: begin
                    alu_control = CONTROL_SLLV;
                end
                FUNC_SLT: begin
                    alu_control = CONTROL_SLT;
                end
                FUNC_SLTU: begin
                    alu_control = CONTROL_SLTU;
                end
                FUNC_SRA: begin
                    alu_control = CONTROL_SRA;
                end
                FUNC_SRAV: begin
                    alu_control = CONTROL_SRAV;
                end
                FUNC_SRL: begin
                    alu_control = CONTROL_SRL;
                end
                FUNC_SRLV: begin
                    alu_control = CONTROL_SRLV;
                end
                FUNC_SUBU: begin
                    alu_control = CONTROL_SUB;
                end
                FUNC_XOR: begin
                    alu_control = CONTROL_XOR;
                end
                FUNC_DIV: begin
                    alu_control = CONTROL_DIV;
                end
                FUNC_DIVU: begin
                    alu_control = CONTROL_DIVU;
                end
                FUNC_MTHI: begin
                    alu_control = CONTROL_MTHI;
                end
                FUNC_MTLO: begin
                    alu_control = CONTROL_MTLO;
                end
                default: begin // jump instructions
                    // do nothing, no need to update alu_control
                end
            endcase
        end
        else if (instr_opcode == OPCODE_BRANCH || instr_opcode == OPCODE_BEQ || instr_opcode == OPCODE_BGTZ || instr_opcode == OPCODE_BLEZ || instr_opcode == OPCODE_BNE) begin
            alu_control = CONTROL_ADD;
        end
        else if (instr_opcode == OPCODE_ADDIU || instr_opcode == OPCODE_LB || instr_opcode == OPCODE_LBU || instr_opcode == OPCODE_LH || instr_opcode == OPCODE_LHU || instr_opcode == OPCODE_LW || instr_opcode == OPCODE_LWL || instr_opcode == OPCODE_LWR || instr_opcode == OPCODE_SB || instr_opcode == OPCODE_SH || instr_opcode == OPCODE_SW) begin
            alu_control = CONTROL_ADD;
        end
        else if (instr_opcode == OPCODE_LWL || instr_opcode == OPCODE_LWR) begin
            alu_control = CONTROL_LWLR;
        end
        else if (instr_opcode == OPCODE_ANDI) begin
            alu_control = CONTROL_ANDI;
        end
        else if (instr_opcode == OPCODE_ORI) begin
            alu_control = CONTROL_ORI;
        end
        else if (instr_opcode == OPCODE_SLTI) begin
            alu_control = CONTROL_SLT;
        end
        else if (instr_opcode == OPCODE_SLTIU) begin
            alu_control = CONTROL_SLTU;
        end
        else if (instr_opcode == OPCODE_XORI) begin
            alu_control = CONTROL_XORI;
        end
        else if (instr_opcode == OPCODE_LUI) begin
            alu_control = CONTROL_LUI;
        end
        else begin // J, JALR, JAL, JR, LUI
            // no need to update alu_control
        end
    end

    always_comb begin
        case (instr_opcode)
            OPCODE_BEQ: begin
                branch_cond = 3'b001; // A = B
            end
            OPCODE_BNE: begin
                branch_cond = 3'b010; // A != B
            end
            OPCODE_BGTZ: begin
                branch_cond = 3'b100; // A > 0
            end
            OPCODE_BLEZ: begin
                branch_cond = 3'b101; // A <= 0
            end
            OPCODE_BRANCH: begin
                case (branch_field)
                    BRANCH_BGEZ: begin
                        branch_cond = 3'b110; // A >= 0
                    end
                    BRANCH_BGEZAL: begin
                        branch_cond = 3'b110; // A >= 0
                    end
                    BRANCH_BLTZ: begin
                        branch_cond = 3'b011; // A < 0
                    end
                    BRANCH_BLTZAL: begin
                        branch_cond = 3'b011; // A < 0
                    end
                endcase
            end
            default: begin
                branch_cond = 3'b000; // no branch condition
            end
        endcase
    end

    always_comb begin
        if (instr_opcode == OPCODE_R) begin
            case (func_code)
                FUNC_DIV: begin
                    LO_write_enable = 1;
                    HI_write_enable = 1;
                end
                FUNC_DIVU: begin
                    LO_write_enable = 1;
                    HI_write_enable = 1;
                end
                FUNC_MTHI: begin
                    LO_write_enable = 0;
                    HI_write_enable = 1;
                end
                FUNC_MTLO: begin
                    LO_write_enable = 1;
                    HI_write_enable = 0;
                end
                FUNC_MULT: begin
                    LO_write_enable = 1;
                    HI_write_enable = 1;
                end
                FUNC_MULTU: begin
                    LO_write_enable = 1;
                    HI_write_enable = 1;
                end
                default: begin
                    LO_write_enable = 0;
                    HI_write_enable = 0;
                end
            endcase
        end
        else begin
            LO_write_enable = 0;
            HI_write_enable = 0;
        end
    end

endmodule