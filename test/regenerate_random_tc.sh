if [ ! -d test/0-assembly/lui ];then
mkdir -p test/0-assembly/lui
fi
if [ ! -d test/0-assembly/addiu ];then
mkdir -p test/0-assembly/addiu
fi
if [ ! -d test/0-assembly/addu ];then
mkdir -p test/0-assembly/addu
fi
if [ ! -d test/0-assembly/and ];then
mkdir -p test/0-assembly/and
fi
if [ ! -d test/0-assembly/andi ];then
mkdir -p test/0-assembly/andi
fi
if [ ! -d test/0-assembly/div ];then
mkdir -p test/0-assembly/div
fi
if [ ! -d test/0-assembly/divu ];then
mkdir -p test/0-assembly/divu
fi
if [ ! -d test/0-assembly/mult ];then
mkdir -p test/0-assembly/mult
fi
if [ ! -d test/0-assembly/or ];then
mkdir -p test/0-assembly/or
fi
if [ ! -d test/0-assembly/ori ];then
mkdir -p test/0-assembly/ori
fi
if [ ! -d test/0-assembly/xor ];then
mkdir -p test/0-assembly/xor
fi
if [ ! -d test/0-assembly/xori ];then
mkdir -p test/0-assembly/xori
fi
if [ ! -d test/0-assembly/subu ];then
mkdir -p test/0-assembly/subu
fi
echo "lui" |  bin/tc 
echo "addiu" |  bin/tc
echo "addu" |  bin/tc 
echo "and" |  bin/tc 
echo "andi" |  bin/tc  
echo "div" |  bin/tc 
echo "divu" |  bin/tc 
echo "mult" |  bin/tc 
echo "or" |  bin/tc 
echo "ori" |  bin/tc 
echo "xor" |  bin/tc 
echo "xori" |  bin/tc 
echo "subu" |  bin/tc 
