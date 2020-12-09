if [ ! -d bin ];then
#if bin directory not exist, create one
mkdir bin
fi
#Generate excutable program in bin from cpp files in util
g++ utils/testcase_generators.cpp -o bin/tc
g++ utils/assembler/assembler.cpp -o bin/assembler 
g++ utils/reference_generator.cpp -o bin/ref
