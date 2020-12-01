#!/bin/bash
set -eou pipefail
#input is address + optional instruction
#can be used for both harvard and bus tests

ADR="$1"
if [ 2 -eq "$#" ];then
    #run all test cases for $2 particular instr
    TESTCASES="../test/0-assembly/$2*.asm.txt"
    INSTR="$2"
    for i in ${TESTCASES} ; do
    # Extract just the testcase name from the filename. See `man basename` for what this command does.
    TESTNAME=$(basename ${i} .asm.txt)
    #echo "$2 ${TESTNAME} "
    # Dispatch to the main test-case script
    SUB=$((${#TESTNAME}-${#INSTR}))
    if [ 1 -eq ${SUB} ];then
    echo "Testcase not exist for ${INSTR}"
    else
    ./3.sh ${ADR} ${INSTR} ${TESTNAME}
    fi
    done

else
    #first run the 5 basic test cases that needed to be tested
    ./no_init_test_mips_cpu.sh ${ADR} "lui"
    ./no_init_test_mips_cpu.sh ${ADR} "addiu"
    ./no_init_test_mips_cpu.sh ${ADR} "lw"
    ./no_init_test_mips_cpu.sh ${ADR} "sw"
    ./no_init_test_mips_cpu.sh ${ADR} "jr"

    #run all testcase for all test cases
    TESTCASES="../test/0-assembly/*.asm.txt"
    for i in ${TESTCASES} ; do
    # Extract just the testcase name from the filename. See `man basename` for what this command does.
    TESTNAME=$(basename ${i} .asm.txt)
    INSTR=${TESTNAME%%_*}
    #echo "${TESTNAME} ${INSTR}"
    # Dispatch to the main test-case script
    if [ ${INSTR} != 'lui' ] && [ ${INSTR} != 'addiu' ] && [ ${INSTR} != 'lw' ] && [ ${INSTR} != 'sw' ] && [ ${INSTR} != 'jr' ];
    then
    ./3.sh ${ADR} ${INSTR} ${TESTNAME}
    fi

    done

fi

