#include "mips.hpp"
#include <cctype>
#include <cassert>

bool mips_is_instruction(const string &s)
{
    if(s=="addiu") return true;
    if(s=="addu") return true;
    if(s=="and") return true;
    if(s=="andi") return true;
    if(s=="beq") return true;
    if(s=="bgez") return true;
    if(s=="bgezal") return true;
    if(s=="bgtz") return true;
    if(s=="blez") return true;
    if(s=="bltz") return true;
    if(s=="bltzal") return true;
    if(s=="bne") return true;
    if(s=="div") return true;
    if(s=="divu") return true;
    if(s=="j") return true;
    if(s=="jalr") return true;
    if(s=="jal") return true;
    if(s=="jr") return true;
    if(s=="lb") return true;
    if(s=="lbu") return true;
    if(s=="lh") return true;
    if(s=="lhu") return true;
    if(s=="lui") return true;
    if(s=="lw") return true;
    if(s=="lwl") return true;
    if(s=="lwr") return true;
    if(s=="mthi") return true;
    if(s=="mtlo") return true;
    if(s=="mult") return true;
    if(s=="multu") return true;
    if(s=="or") return true;
    if(s=="ori") return true;
    if(s=="sb") return true;
    if(s=="sh") return true;
    if(s=="sll") return true;
    if(s=="sllv") return true;
    if(s=="slt") return true;
    if(s=="slti") return true;
    if(s=="sltiu") return true;
    if(s=="sltu") return true;
    if(s=="sra") return true;
    if(s=="srav") return true;
    if(s=="srl") return true;
    if(s=="srlv") return true;
    if(s=="subu") return true;
    if(s=="sw") return true;
    if(s=="xor") return true;
    if(s=="xori") return true;
    return false;
}

bool mips_is_label_decl(const string &s)
{
    if(s.size()<2)
    {
        return false;
    }

    if(!(isalpha(s[0]) || s[0]=='_'))
    {
        return false;
    }

    for(int i=1; i<s.size()-1; i++)
    {
        if(!(isalnum(s[i]) || s[i]=='_')){
            return false;
        }
    }

    if(!(s.back()==':'))
    {
        return false;
    }

    return true;
}

bool mips_is_register(const string &s)
{
     if(s.size()<2)
    {
        return false;
    }

    if(!(s[0]=='$'))
    {
        return false;
    }

    for(int i=1; i<s.size()-1; i++)
    {
        if(!isdigit(s[i]))
        {
            return false;
        }
    }

    return true;   
}

bool mips_instruction_is_function(const string &s)
{
    assert(mips_is_instruction(s));
    if(s=="addu") return true;
    if(s=="and") return true;
    if(s=="or") return true;
    if(s=="subu") return true;
    if(s=="slt") return true;
    if(s=="sltu") return true;
    if(s=="xor") return true;
    return false;
}

bool mips_instruction_is_function_immediate(const string &s)
{
    assert(mips_is_instruction(s));
    if(s=="addiu") return true;
    if(s=="andi") return true;
    if(s=="ori") return true;
    if(s=="slti") return true;
    if(s=="sltiu") return true;
    if(s=="xori") return true;
    return false;
}

bool mips_instruction_is_branch(const string &s)
{
    assert(mips_is_instruction(s));
    if(s=="beq") return true;
    if(s=="bne") return true;
    return false;
}

bool mips_instruction_is_branch_comparison(const string &s)
{
    assert(mips_is_instruction(s));
    if(s=="bgez") return true;
    if(s=="bgezal") return true;
    if(s=="bgtz") return true;
    if(s=="blez") return true;
    if(s=="bltz") return true;
    if(s=="bltzal") return true;
    return false;
}

bool mips_instruction_is_jump(const string &s)
{
    assert(mips_is_instruction(s));
    if(s=="j") return true;
    if(s=="jal") return true;
    return false;
}

bool mips_instruction_is_memory_using_offset(const string &s)
{
    assert(mips_is_instruction(s));
    if(s=="lb") return true;
    if(s=="lbu") return true;
    if(s=="lh") return true;
    if(s=="lhu") return true;
    if(s=="lw") return true;
    if(s=="lwl") return true;
    if(s=="lwr") return true;
    if(s=="sb") return true;
    if(s=="sh") return true;
    if(s=="sw") return true;
    return false;
}

bool mips_instruction_is_HiLo(const string &s)
{
    assert(mips_is_instruction(s));
    if(s=="mthi") return true;
    if(s=="mtlo") return true;
    return false;
}

bool mips_instruction_is_MulDiv(const string &s)
{
    assert(mips_is_instruction(s));
    if(s=="mult") return true;
    if(s=="multu") return true;
    if(s=="div") return true;
    if(s=="divu") return true;
    return false; 
}

bool mips_instruction_is_shift(const string &s)
{
    assert(mips_is_instruction(s));
    if(s=="sll") return true;
    if(s=="sra") return true;
    if(s=="srl") return true;
    return false;
}

bool mips_instruction_is_shift_variable(const string &s)
{
    assert(mips_is_instruction(s));
    if(s=="sllv") return true;
    if(s=="srav") return true;
    if(s=="srlv") return true;
    return false;
}

uint32_t mips_opname_to_opcode(const string &s)
{
    assert(mips_is_instruction(s));
    uint32_t opcode = 0;
    if(mips_instruction_is_branch(s))
    {
        opcode + (1<<26);
    }
    if(s=="addiu") return opcode + (9<<26);
    if(s=="addu") return opcode + 33;
    if(s=="and") return opcode + 36;
    if(s=="andi") return opcode + (12<<26);
    if(s=="beq") return opcode + (4<<26);
    if(s=="bgez") return opcode + (1<<16);
    if(s=="bgezal") return opcode + (17<<16);
    if(s=="bgtz") return opcode + (7<<26);
    if(s=="blez") return opcode + (6<<26);
    if(s=="bltz") return opcode + (0<<16);
    if(s=="bltzal") return opcode + (16<<16);
    if(s=="bne") return opcode + (5<<26);
    if(s=="div") return opcode + 26;
    if(s=="divu") return opcode + 27;
    if(s=="j") return opcode + (2<<26);
    if(s=="jalr") return opcode + 9;
    if(s=="jal") return opcode + (3<<26);
    if(s=="jr") return opcode + 8;
    if(s=="lb") return opcode + (32<<26);
    if(s=="lbu") return opcode + (36<<26);
    if(s=="lh") return opcode + (33<<26);
    if(s=="lhu") return opcode + (37<<26);
    if(s=="lui") return opcode + (15<<26);
    if(s=="lw") return opcode + (35<<26);
    if(s=="lwl") return opcode + (34<<26);
    if(s=="lwr") return opcode + (38<<26);
    if(s=="mthi") return opcode + 17;
    if(s=="mtlo") return opcode + 19;
    if(s=="mult") return opcode + 24;
    if(s=="multu") return opcode + 25;
    if(s=="or") return opcode + 37;
    if(s=="ori") return opcode + (13<<26);
    if(s=="sb") return opcode + (40<<26);
    if(s=="sh") return opcode + (41<<26);
    if(s=="sll") return opcode + 0;
    if(s=="sllv") return opcode + 4;
    if(s=="slt") return opcode + 42;
    if(s=="slti") return opcode + (10<<26);
    if(s=="sltiu") return opcode + (11<<26);
    if(s=="sltu") return opcode + 43;
    if(s=="sra") return opcode + 3;
    if(s=="srav") return opcode + 7;
    if(s=="srl") return opcode + 2;
    if(s=="srlv") return opcode + 6;
    if(s=="subu") return opcode + 35;
    if(s=="sw") return opcode + (43<<26);
    if(s=="xor") return opcode + 38;
    if(s=="xori") return opcode + (14<<26);
}

uint32_t mips_regname_to_regcode(const string &s, int loc)
{
    assert(mips_is_register(s));
    int x = 26-5*loc;
    uint32_t regno = 0;
    if(s=="$0") return regno + (0<<x);
    if(s=="$1") return regno + (1<<x);
    if(s=="$2") return regno + (2<<x);
    if(s=="$3") return regno + (3<<x);
    if(s=="$4") return regno + (4<<x);
    if(s=="$5") return regno + (5<<x);
    if(s=="$6") return regno + (6<<x);
    if(s=="$7") return regno + (7<<x);
    if(s=="$8") return regno + (8<<x);
    if(s=="$9") return regno + (9<<x);
    if(s=="$10") return regno + (10<<x);
    if(s=="$11") return regno + (11<<x);
    if(s=="$12") return regno + (12<<x);
    if(s=="$13") return regno + (13<<x);
    if(s=="$14") return regno + (14<<x);
    if(s=="$15") return regno + (15<<x);
    if(s=="$16") return regno + (16<<x);
    if(s=="$17") return regno + (17<<x);
    if(s=="$18") return regno + (18<<x);
    if(s=="$19") return regno + (19<<x);
    if(s=="$20") return regno + (20<<x);
    if(s=="$21") return regno + (21<<x);
    if(s=="$22") return regno + (22<<x);
    if(s=="$23") return regno + (23<<x);
    if(s=="$24") return regno + (24<<x);
    if(s=="$25") return regno + (25<<x);
    if(s=="$26") return regno + (26<<x);
    if(s=="$27") return regno + (27<<x);
    if(s=="$28") return regno + (28<<x);
    if(s=="$29") return regno + (29<<x);
    if(s=="$30") return regno + (30<<x);
    if(s=="$31") return regno + (31<<x);
}


string to_hex8(uint32_t x)
{
    char tmp[16]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
    string res;
    res.push_back(tmp[(x>>28)&0xF]);
    res.push_back(tmp[(x>>24)&0xF]);
    res.push_back(tmp[(x>>20)&0xF]);
    res.push_back(tmp[(x>>16)&0xF]);
    res.push_back(tmp[(x>>12)&0xF]);
    res.push_back(tmp[(x>>8)&0xF]);
    res.push_back(tmp[(x>>4)&0xF]);
    res.push_back(tmp[(x>>0)&0xF]);
    return res;
}