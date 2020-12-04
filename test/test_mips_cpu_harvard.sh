#!/bin/bash
set -eou pipefail
#input is address + optional instruction

>&2 echo "Checking if initialisation required..."
if [ -e bin/tc ] && [ -e bin/assembler ] && [ -e bin/reference ] ;then
>&2 echo "......Done"
else
>&2 echo "Initialising"
./test/generate_bin.sh
>&2 echo "......Done"
fi

>&2 echo "Test CPU In Folder: $1"
if [ 2 -eq "$#" ];then
    ./test/no_init_test_mips_cpu.sh $1 "harvard" $2 
else
    ./test/no_init_test_mips_cpu.sh $1 "harvard"
fi
