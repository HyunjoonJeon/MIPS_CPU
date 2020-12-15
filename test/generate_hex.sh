#!/bin/bash

# to generate hex file for any c program written eg ./generate_hex.sh fib
# run this script in the test folder, ensuring that the .c flie is is in c-cases folder

FILE_NAME="$1"
make c-cases/${FILE_NAME}.mips.bin

if [[ ! -d 1-binary/${FILE_NAME} ]] ; then
   mkdir -p 1-binary/${FILE_NAME}
fi

hexdump -ve '1/4 "%08x" "\n"' c-cases/${FILE_NAME}.mips.bin > 1-binary/${FILE_NAME}/${FILE_NAME}.hex.txt