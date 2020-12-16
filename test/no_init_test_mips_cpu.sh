#!/bin/bash
set -eou pipefail
#input is address + type of cpu(bus or harvard) + optional instruction
#can be used for both harvard and bus tests

ADR="$1"
TYPE="$2"
if [ 3 -eq "$#" ];then
    #run all test cases for $2 particular instr
    INSTR="$3"

    TESTCASES="test/0-assembly/${INSTR}/${INSTR}*.asm.txt"
    CCASES="test/0-assembly/${INSTR}/${INSTR}*.mips.bin"

    for i in ${TESTCASES}; do
    # Extract just the testcase name from the filename. See `man basename` for what this command does.
    TESTNAME=$(basename ${i} .asm.txt)
    # Dispatch to the main test-case script
    SUB=$((${#TESTNAME}-${#INSTR}))
    if [ 1 -eq ${SUB} ];then
        for c in ${CCASES}; do
            TESTNAME=$(basename ${c} .mips.bin)
            # Dispatch to the main test-case script
            SUB=$((${#TESTNAME}-${#INSTR}))
            if [ 1 -eq ${SUB} ];then
                echo "Testcase doesn't exist for ${INSTR} ${TESTNAME}"
            else
                ISBIN=true
                if [ ${TYPE} == 'harvard' ];then
                #echo "harvard !"
                    ./test/one_instr_harvard.sh ${ADR} ${INSTR} ${TESTNAME} ${ISBIN}
                fi
                if [ ${TYPE} == 'bus' ];then
                #echo "bus"
                    ./test/one_instr_bus.sh ${ADR} ${INSTR} ${TESTNAME} ${ISBIN}
                fi
            fi
        done
    else
        ISBIN=false
        if [ ${TYPE} == 'harvard' ];then
        #echo "harvard !"
        ./test/one_instr_harvard.sh ${ADR} ${INSTR} ${TESTNAME} ${ISBIN}
        fi
        if [ ${TYPE} == 'bus' ];then
        #echo "bus"
        ./test/one_instr_bus.sh ${ADR} ${INSTR} ${TESTNAME} ${ISBIN}
        fi
    fi
    done

else
    #first run the 5 basic test cases that needed to be tested
    ./test/no_init_test_mips_cpu.sh ${ADR} ${TYPE} "lui"
    ./test/no_init_test_mips_cpu.sh ${ADR} ${TYPE} "addiu" 
    ./test/no_init_test_mips_cpu.sh ${ADR} ${TYPE} "lw" 
    ./test/no_init_test_mips_cpu.sh ${ADR} ${TYPE} "sw" 
    ./test/no_init_test_mips_cpu.sh ${ADR} ${TYPE} "jr" 

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
        if [ ${TYPE} == 'harvard' ];then
        #echo "harvard !"
        ./test/one_instr_harvard.sh ${ADR} ${INSTR} ${TESTNAME}
        fi
        if [ ${TYPE} == 'bus' ];then
        #echo "bus"
        ./test/one_instr_bus.sh ${ADR} ${INSTR} ${TESTNAME}
        fi
    fi
    done

fi

