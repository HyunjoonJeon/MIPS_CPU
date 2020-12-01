#ADR = ${dirname {$PWD}}
#Generate excutable program in bin from cpp files in util
g++ ./util/testcase_generator.cpp -o ./bin/tc
g++ ./util/assembler.cpp -o ./bin/assembler
g++ ./util/reference_generator.cpp -o ./bin/ref