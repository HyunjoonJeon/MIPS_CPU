#!/bin/bash
set -eou pipefail

# specifying the directory containing the RTL CPU implementation
# optional argument specifying which testcase of the instruction to test
DIRECTORY="$1"
INSTR="$2"
TESTCASE="$3"
#TESTCASE_TYPE ="test/0-assembly/${INSTR}/*.asm.txt"

>&2 echo "Test CPU in directory ${DIRECTORY} of instruction ${INSTR}"

>&2 echo "1 - Assembling input file"
 bin/assembler <test/0-assembly/${INSTR}/${TESTCASE}.asm.txt >test/1-binary/${INSTR}/${TESTCASE}.hex.txt

>&2 echo "2 - Compiling test-bench"
# Compile the cpu under specific directory and instructions.
# -s specifies exactly which testbench should be top-level
# The -P command is used to modify the RAM_INIT_FILE parameter on the test-bench at compile-time
iverilog -g 2012 \
   ${DIRECTORY}/mips_cpu_harvard.v ${DIRECTORY}/mips_cpu_harvard_tb.v ${DIRECTORY}/mem_harvard.v ${DIRECTORY}/mips_cpu/*.v \
   -s mips_cpu_harvard_tb \
   -P mips_cpu_harvard_tb.INSTR_INIT_FILE=\"test/1-binary/${INSTR}/${TESTCASE}.hex.txt\" \
   -o test/2-simulator/mips_cpu_harvard_tb_${TESTCASE}

>&2 echo "3 - Running test-bench"
# Run the simulator, and capture all output to a file
# Use +e to disable automatic script failure if the command fails, as
# it is possible the simulation might go wrong.
set +e
test/2-simulator/mips_cpu_harvard_tb_${TESTCASE} > test/3-output/${INSTR}/mips_cpu_harvard_tb_${TESTCASE}.stdout
# Capture the exit code of the simulator in a variable
RESULT=$?
set -e

# Check whether the simulator returned a failure code, and immediately quit
if [[ "${RESULT}" -ne 0 ]] ; then
   echo "  ${TESTCASE} ${INSTR} FAIL"
   exit
fi

>&2 echo "4 - Extracting result of testcases"
# This is the prefix for simulation output lines containing value of register_v0
PATTERN="register_v0:"
NOTHING=""
# Use "grep" to look only for lines containing PATTERN
set +e
grep "${PATTERN}" test/3-output/${INSTR}/mips_cpu_harvard_tb_${TESTCASE}.stdout > test/3-output/${INSTR}/mips_cpu_harvard_tb_${TESTCASE}.out-lines
set -e
# Use "sed" to replace "CPU : OUT   :" with nothing
sed -e "s/${PATTERN}/${NOTHING}/g" test/3-output/${INSTR}/mips_cpu_harvard_tb_${TESTCASE}.out-lines > test/3-output/${INSTR}/mips_cpu_harvard_tb_${TESTCASE}.out

>&2 echo "5 - Running reference simulator"
# not complete, do not know how to come up with reference outputs
#bin/reference <test/1-binary/${TESTCASE}.hex.txt >test/4-reference/${TESTCASE}.out


>&2 echo "6 - Comparing output"
set +e
diff -w test/4-reference/${INSTR}/${TESTCASE}.out test/3-output/${INSTR}/mips_cpu_harvard_tb_${TESTCASE}.out
RESULT=$?
set -e

# Based on whether differences were found, either pass or fail
if [[ "${RESULT}" -ne 0 ]] ; then
   echo "  ${TESTCASE} ${INSTR} FAIL"
else
   echo "  ${TESTCASE} ${INSTR} PASS"
fi





