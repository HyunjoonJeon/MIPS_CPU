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

// Returns true if the given opname has a function operand
bool mips_instruction_has_function(const string &s);

//Returns true if the given opname has a destination operand
bool mips_instruction_is_branch(const string &s);

//Returns true if the given opname has an immediate 16-bit field
bool mips_instruction_has_immediate(const string &s);

//Returns true if the giveen opname has an offset 16-bit field
bool mips_instruction_has_offset(const string &s);

//Returns true if the given opname has a instruction index 26-bit field
bool mips_instruction_has_jump_field(const string &s);

// Takes a multi-letter opname and turns it into the numeric opcode
uint32_t mips_opname_to_opcode(const string &s);

// Converts 32 bit binary integer into it's hex equivalent
string to_hex8(uint32_t x);

#endif