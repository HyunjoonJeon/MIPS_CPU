#ifndef mips_hpp
#define mips_hpp

#include <cstdint>
#include <string>
#include <vector>
#include <fstream>

using namespace std;

// Assembly

// Return true if the string v is a valid encoded instruction
bool mips_is_instruction(const string &s);

// Return true if the string is a valid label declaration
bool mips_is_label_decl(const string &s);

//Return true if the string is a valid register in an instruction
bool mips_is_register(const string &s);

// Returns true if the given opname has a function operand and isn't immediate
bool mips_instruction_is_function(const string &s);

// Returns true if the given opname has a function operand and is immediate
bool mips_instruction_is_function_immediate(const string &s);

//Returns true if the given opname is a branch instruction that looks at one register
bool mips_instruction_is_branch(const string &s);

// Returns true if the given opname is a branch instruction comparing two registers
bool mips_instruction_is_branch_comparison(const string &s);

//Returns true if the given opname is a jump instruction with an instruction index 26-bit field
bool mips_instruction_is_jump(const string &s);

//Returns true if the given opname is a memory instruction which uses an offset immediate with a base register value
bool mips_instruction_is_memory_using_offset(const string &s);

//Returns true if the given opname is a Hi or Lo related instruction
bool mips_instruction_is_HiLo(const string &s);

//Returns true if the given opname is a mulitplication or division instruction
bool mips_instruction_is_MulDiv(const string &s);

//Returns true if the given opname is non-variable shifting instruction
bool mips_instruction_is_shift(const string &s);

//Returns true if the given opname is a variable shifting instruction
bool mips_instruction_is_shift_variable(const string &s);

// Takes a multi-letter opname and turns it into the numeric opcode
uint32_t mips_opname_to_opcode(const string &s);

// Converts 32 bit binary integer into it's hex equivalent
string to_hex8(uint32_t x);

#endif