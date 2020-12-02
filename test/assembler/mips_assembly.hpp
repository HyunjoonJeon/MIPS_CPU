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

    if(!s[0]=='$')
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
    uint32_t opcode = 00000000000000000000000000000000;
    if(mips_instruction_is_branch)
    {
        opcode + 000001<<26;
    }
    if(s=="addiu") return opcode + 001001<<26;
    if(s=="addu") return opcode + 100001;
    if(s=="and") return opcode + 100100;
    if(s=="andi") return opcode + 001100<<26;
    if(s=="beq") return opcode + 000100<<26;
    if(s=="bgez") return opcode + 00001<<16;
    if(s=="bgezal") return opcode + 10001<<16;
    if(s=="bgtz") return opcode + 000111<<26;
    if(s=="blez") return opcode + 000110<<26;
    if(s=="bltz") return opcode + 00000<<16;
    if(s=="bltzal") return opcode + 10000<<16;
    if(s=="bne") return opcode + 000101<<26;
    if(s=="div") return opcode + 011010;
    if(s=="divu") return opcode + 011011;
    if(s=="j") return opcode + 000010<<26;
    if(s=="jalr") return opcode + 001001;
    if(s=="jal") return opcode + 000011<<26;
    if(s=="jr") return opcode + 001000;
    if(s=="lb") return opcode + 100000<<26;
    if(s=="lbu") return opcode + 100100<<26;
    if(s=="lh") return opcode + 100001<<26;
    if(s=="lhu") return opcode + 100101<<26;
    if(s=="lui") return opcode + 001111<<26;
    if(s=="lw") return opcode + 100011<<26;
    if(s=="lwl") return opcode + 100010<<26;
    if(s=="lwr") return opcode + 100110<<26;
    if(s=="mthi") return opcode + 010001;
    if(s=="mtlo") return opcode + 010011;
    if(s=="mult") return opcode + 011000;
    if(s=="multu") return opcode + 011001;
    if(s=="or") return opcode + 100101;
    if(s=="ori") return opcode + 001101<<26;
    if(s=="sb") return opcode + 101000<<26;
    if(s=="sh") return opcode + 101001<<26;
    if(s=="sll") return opcode + 000000;
    if(s=="sllv") return opcode + 000100;
    if(s=="slt") return opcode + 101010;
    if(s=="slti") return opcode + 001010<<26;
    if(s=="sltiu") return opcode + 001011<<26;
    if(s=="sltu") return opcode + 101011;
    if(s=="sra") return opcode + 000011;
    if(s=="srav") return opcode + 000111;
    if(s=="srl") return opcode + 000010;
    if(s=="srlv") return opcode + 000110;
    if(s=="subu") return opcode + 100011;
    if(s=="sw") return opcode + 101011<<26;
    if(s=="xor") return opcode + 100110;
    if(s=="xori") return opcode + 001110<<26;
}

uint32_t mips_regname_to_regcode(const string &s, int loc)
{
    assert(mips_is_register(s));
    int x = 26-5*loc;
    uint32_t regno = 00000000000000000000000000000000;
    if(s=="$0") return regno + 000000<<x;
    if(s=="$1") return regno + 000001<<x;
    if(s=="$2") return regno + 000010<<x;
    if(s=="$3") return regno + 000011<<x;
    if(s=="$4") return regno + 000100<<x;
    if(s=="$5") return regno + 000101<<x;
    if(s=="$6") return regno + 000110<<x;
    if(s=="$7") return regno + 000111<<x;
    if(s=="$8") return regno + 001000<<x;
    if(s=="$9") return regno + 001001<<x;
    if(s=="$10") return regno + 001010<<x;
    if(s=="$11") return regno + 001011<<x;
    if(s=="$12") return regno + 001100<<x;
    if(s=="$13") return regno + 001101<<x;
    if(s=="$14") return regno + 001110<<x;
    if(s=="$15") return regno + 001111<<x;
    if(s=="$16") return regno + 010000<<x;
    if(s=="$17") return regno + 010001<<x;
    if(s=="$18") return regno + 010010<<x;
    if(s=="$19") return regno + 010011<<x;
    if(s=="$20") return regno + 010100<<x;
    if(s=="$21") return regno + 010101<<x;
    if(s=="$22") return regno + 010110<<x;
    if(s=="$23") return regno + 010111<<x;
    if(s=="$24") return regno + 011000<<x;
    if(s=="$25") return regno + 011001<<x;
    if(s=="$26") return regno + 011010<<x;
    if(s=="$27") return regno + 011011<<x;
    if(s=="$28") return regno + 011100<<x;
    if(s=="$29") return regno + 011101<<x;
    if(s=="$30") return regno + 011110<<x;
    if(s=="$31") return regno + 011111<<x;
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