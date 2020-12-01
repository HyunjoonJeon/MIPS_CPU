#!/bin/bash
set -eou pipefail
#input is address + optional instruction
# can be used for both harvard and bus tests

>&2 echo "Checking if initialisation required..."
if [ -e ../bin/tc ];then
>&2 echo "......Done"
else
>&2 echo "Initialising"
./generate_bin.sh
>&2 echo "......Done"
fi

>&2 echo "Test CPU In Folder: $1"
if [ 2 -eq "$#" ];then
    ./no_init_test_mips_cpu.sh $1 $2
else
    ./no_init_test_mips_cpu.sh $1
fi