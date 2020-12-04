#!/bin/bash
set -eou pipefail
#input is address + optional instruction
#can be used for both harvard and bus tests

ADR="$1"
TYPE = "$3"
if [ 2 -eq "$#" ];then
    #run all test cases for $2 particular instr
    INSTR="$2"
    TESTCASES="test/0-assembly/${INSTR}/${INSTR}*.asm.txt"
    for i in ${TESTCASES} ; do
    # Extract just the testcase name from the filename. See `man basename` for what this command does.
    TESTNAME=$(basename ${i} .asm.txt)
    #echo "$2 ${TESTNAME} "
    # Dispatch to the main test-case script
    SUB=$((${#TESTNAME}-${#INSTR}))
    if [ 1 -eq ${SUB} ];then
    echo "Testcase not exist for ${INSTR} ${TESTNAME}"
    else
        if [ ${TYPE} == "harvard" ];then
        ./test/one_instr_harvard.sh ${ADR} ${INSTR} ${TESTNAME}
        fi
        if [ ${TYPE} == "bus" ];then
        ./test/one_instr_bus.sh ${ADR} ${INSTR} ${TESTNAME}
        fi
    fi
    done

else
    #first run the 5 basic test cases that needed to be tested
    ./test/no_init_test_mips_cpu.sh ${ADR} "lui" ${TYPE}
    ./test/no_init_test_mips_cpu.sh ${ADR} "addiu" ${TYPE}
    ./test/no_init_test_mips_cpu.sh ${ADR} "lw" ${TYPE}
    ./test/no_init_test_mips_cpu.sh ${ADR} "sw" ${TYPE}
    ./test/no_init_test_mips_cpu.sh ${ADR} "jr" ${TYPE}

    #run all testcase for all test cases
    TESTCASES="test/0-assembly/*/*.asm.txt"
    for i in ${TESTCASES} ; do
    # Extract just the testcase name from the filename. See `man basename` for what this command does.
    TESTNAME=$(basename ${i} .asm.txt)
    INSTR=${TESTNAME%%_*}
    #echo "${TESTNAME} ${INSTR}"
    # Dispatch to the main test-case script
    if [ ${INSTR} != 'lui' ] && [ ${INSTR} != 'addiu' ] && [ ${INSTR} != 'lw' ] && [ ${INSTR} != 'sw' ] && [ ${INSTR} != 'jr' ];
    then
    ./test/one_instr_harvard.sh ${ADR} ${INSTR} ${TESTNAME}
    fi

    done

fi

