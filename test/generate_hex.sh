#!/bin/bash

# to generate hex file for any c program written eg ./generate_hex.sh fib
# run this script in the test folder, ensuring that the .c flie is is in c-cases folder

if [[ $# -eq 0 ]]; then 
    echo "Missing argument: name of file to compile"
    echo "Example usage: ./generate_hex.sh fib_1"
    exit
fi

INSTR="$1"
TESTCASES="0-assembly/${INSTR}/${INSTR}*.c"

if [[ ! -d 1-binary/${INSTR} ]] ; then
   mkdir -p 1-binary/${INSTR}
fi

for i in ${TESTCASES}; do
    # Extract just the testcase name from the filename.
    TESTNAME=$(basename ${i} .c)
    make 0-assembly/${INSTR}/${TESTNAME}.mips.bin
    hexdump -ve '1/4 "%08x" "\n"' 0-assembly/${INSTR}/${TESTNAME}.mips.bin > 1-binary/${INSTR}/${TESTNAME}.hex.txt
done