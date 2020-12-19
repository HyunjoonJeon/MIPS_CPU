#!/bin/bash
set -eou pipefail
#input is address + optional instruction

#>&2 echo "Checking if initialisation required..."
if [ -e bin/tc ] && [ -e bin/assembler ] && [ -e bin/reference ] ;then
    :
#>&2 echo "......Done"
else
#>&2 echo "Initialising"
./test/generate_bin.sh
#>&2 echo "......Done"
fi

if [[ $# -eq 0 ]]; then 
    echo "Missing argument: path to CPU folder"
    echo "Example usage: ./test/test_mips_bus.sh rtl"
    exit
fi

ADDRESS="$1"

#>&2 echo "Test CPU In Folder: $1"
if [ 2 -eq "$#" ];then
    if [ -d test/0-assembly/$2 ]; then
    echo $2 | bin/tc
    else
    echo "No such instruction in MIPS I"
    exit
    fi
    ./test/no_init_test_mips_cpu.sh $1 "bus" $2
else
    ./test/regenerate_random_tc.sh
    ./test/no_init_test_mips_cpu.sh $1 "bus"
fi
