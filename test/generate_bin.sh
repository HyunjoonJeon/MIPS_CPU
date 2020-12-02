if [ ! -d bin ];then
#if bin directory not exist, create one
mkdir bin
fi
#Generate excutable program in bin from cpp files in util
g++ util/testcase_generators.cpp -o bin/tc
g++ util/assembler.cpp -o bin/assembler
g++ util/reference_generator.cpp -o bin/ref
echo "lui" | bin/tc 
echo "addiu" | bin/tc
echo "addu" | bin/tc 
echo "and" | bin/tc 
echo "and" | bin/tc 
echo "andi" | bin/tc  
echo "div" | bin/tc 
echo "divu" | bin/tc 
echo "mult" | bin/tc 
echo "multu" | bin/tc 
echo "or" | bin/tc 
echo "ori" | bin/tc 
