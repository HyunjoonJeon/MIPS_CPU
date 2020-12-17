#!/bin/bash
if [ $# -lt 1 ]; then
    # echo "not enough arguments"
    exit 1
fi

if [ ! -d $1 ]; then
    # echo "CPU not found"
    exit 1
fi
DIRECTORY=$(echo "$1" | sed 's/\/$//')

FILES=$(ls -1 $DIRECTORY | grep mips_cpu_ | grep .v$ | awk -v path=$DIRECTORY '{print path "/" $0}')
if [ -d $DIRECTORY/mips_cpu/ ]; then
    FILES="$FILES $(ls -1 $DIRECTORY/mips_cpu/ | grep .v$ | awk -v path=$DIRECTORY '{print path "/mips_cpu/" $0}')"
fi
FILES=$(echo "$FILES" | tr "\n" " ")

# normal avalon mem
iverilog -g2012 test/6-avalon/avalon_basic_tb.v test/6-avalon/avl_slave_mem_2.v $FILES \
    -s avalon_basic_tb \
    -P avalon_basic_tb.INSTR_INIT_FILE=\"test/6-avalon/avalon_test_program.hex.txt\" \
    -o test/6-avalon/avalon_basic_tb 2>/dev/null
./test/6-avalon/avalon_basic_tb > test/6-avalon/logs/avalon_basic_tb.log
RESULT=$?
rm test/6-avalon/avalon_basic_tb
if [ $RESULT -ne 0 ]; then 
    exit 5
fi

# slow avalon mem
iverilog -g2012 test/6-avalon/avalon_slow_tb.v test/6-avalon/avl_slave_mem_slow.v $FILES \
    -s avalon_slow_tb \
    -P avalon_slow_tb.INSTR_INIT_FILE=\"test/6-avalon/avalon_test_program.hex.txt\" \
    -o test/6-avalon/avalon_slow_tb 2>/dev/null
./test/6-avalon/avalon_slow_tb > test/6-avalon/logs/avalon_slow_tb.log
RESULT=$?
rm test/6-avalon/avalon_slow_tb
if [ $RESULT -ne 0 ]; then 
    exit 5
fi

# async avalon mem (waitrequest always 0)
iverilog -g2012 test/6-avalon/avalon_async_tb.v test/6-avalon/avl_slave_mem_async.v $FILES \
    -s avalon_async_tb \
    -P avalon_async_tb.INSTR_INIT_FILE=\"test/6-avalon/avalon_test_program.hex.txt\" \
    -o test/6-avalon/avalon_async_tb 2>/dev/null
./test/6-avalon/avalon_async_tb > test/6-avalon/logs/avalon_async_tb.log
RESULT=$?
rm test/6-avalon/avalon_async_tb
if [ $RESULT -ne 0 ]; then 
    exit 5
fi
exit 0