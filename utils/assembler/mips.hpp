#ifndef mips_hpp
#define mips_hpp

#include "mips_assembly.hpp"
#include <cstdint>
#include <string>
#include <vector>
#include <fstream>


using namespace std;

// Assembly

// Return true if the string v is a valid encoded instruction
bool mips_is_instruction(string s);

// Return true if the string is a valid label declaration
bool mips_is_label_decl(string s);

//Return true if the string is a valid register in an instruction
bool mips_is_register(string s);

// Returns true if the given opname has a function operand and isn't immediate
bool mips_instruction_is_function(string s);

// Returns true if the given opname has a function operand and is immediate
bool mips_instruction_is_function_immediate(string s);

//Returns true if the given opname is a branch instruction that looks at one register
bool mips_instruction_is_branch(string s);

// Returns true if the given opname is a branch instruction comparing two registers
bool mips_instruction_is_branch_comparison(string s);

//Returns true if the given opname is a jump instruction with an instruction index 26-bit field
bool mips_instruction_is_jump(string s);

//Returns true if the given opname is a memory instruction which uses an offset immediate with a base register value
bool mips_instruction_is_memory_using_offset(string s);

//Returns true if the given opname is a move to Hi or Lo related instruction
bool mips_instruction_is_HiLo_mt(string s);

//Returns true if the given opname is a move from Hi or Lo related instruction
bool mips_instruction_is_HiLo_mf(string s);

//Returns true if the given opname is a mulitplication or division instruction
bool mips_instruction_is_MulDiv(string s);

//Returns true if the given opname is non-variable shifting instruction
bool mips_instruction_is_shift(string s);

//Returns true if the given opname is a variable shifting instruction
bool mips_instruction_is_shift_variable(string s);

// Takes a multi-letter opname and turns it into the numeric opcode
uint32_t mips_opname_to_opcode(string s);

//Takes the string representation of the register and converts it to binary for calculating instructions
uint32_t mips_regname_to_regcode(string s, int loc);

// Converts 32 bit binary integer into it's hex equivalent
string to_hex8(uint32_t x);

#endif