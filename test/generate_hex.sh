#!/bin/bash

# to generate hex file for any c program written eg ./generate_hex.sh fib
# run this script in the test folder, ensuring that the .c flie is is in 7/ctests/instr folder
# generates a .s and .hex.txt file in same folder

if [[ $# -eq 0 ]]; then 
    echo "Missing argument: name of file to compile"
    echo "Example usage: ./generate_hex.sh fib_1"
    exit
fi

INSTR="$1"
TESTCASES="7-ctests/${INSTR}/${INSTR}*.c"

for i in ${TESTCASES}; do
    # Extract just the testcase name from the filename.
    TESTNAME=$(basename ${i} .c)
    make 7-ctests/${INSTR}/${TESTNAME}.mips.s
    make 7-ctests/${INSTR}/${TESTNAME}.mips.bin    
    hexdump -ve '1/4 "%08x" "\n"' 7-ctests/${INSTR}/${TESTNAME}.mips.bin > 7-ctests/${INSTR}/${TESTNAME}.hex.txt
    rm 7-ctests/${INSTR}/${TESTNAME}.mips.bin    
done