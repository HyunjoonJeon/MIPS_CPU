#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>
#include <fstream>
#include <vector>
#include <cassert>
using namespace std;

//ADDIU ANDI ORI LUI XOR 
//ADDU AND DIV DIVU OR XOR SUBU
string hex_random_generator(int n){
    string res = "";
    for(int i = 0;i < n;i++){
        int k = rand() % 15;
        if(k == 0) res.append("0");
        if(k == 1) res.append("1");
        if(k == 2) res.append("2");
        if(k == 3) res.append("3");
        if(k == 4) res.append("4");
        if(k == 5) res.append("5");
        if(k == 6) res.append("6");
        if(k == 7) res.append("7");
        if(k == 8) res.append("8");
        if(k == 9) res.append("9");
        if(k == 10) res.append("a");
        if(k == 11) res.append("b");
        if(k == 12) res.append("c");
        if(k == 13) res.append("d");
        if(k == 14) res.append("e");
        if(k == 15) res.append("f");
    }
    return res;
}

string assign_reg(int n ,string side,int R)
{ 
    string res;
    string r = to_string(R);
    assert(n == 1 || n == 2);
    assert(side == "upper" || side == "lower");

    if (side == "lower" && (n == 1|| n ==2))
    {
        res = "addiu $" + r + " $" + r + " " + to_string((rand() % 65535)-32768);
    }
    if (side == "upper" && n == 1)
    {
        res = "lui $" + r + " " + to_string(rand() % 32767);
    }
    if (side == "upper" && n == 2)
    {
        res = "lui $" + r + " " + to_string((rand() % 32767)+32768);
    }
    return res;
}

int main()
{
    string instr;
    getline(cin,instr);
    srand(time(0));
    string position = "./test/0-assembly/"; //storing positionition for the testcases txt
    ofstream outfile;

    if (instr == "lui") //this instruction should be tested first
    // the immediate should not be signed  so only positive value allowed
    {
        for(int i = 1;i <= 3;i++){
        outfile.open(position + instr + "/"+ instr + "_" + to_string(i) +".asm.txt",ios::trunc);
        outfile << instr << " $2 " << rand() % 32767 << endl;
        outfile << "jr $0" << endl;
        outfile.close();
        outfile.open(position + instr + "/"+ instr + "_" +  to_string(i+3)+".asm.txt",ios::trunc);
        outfile << instr << " $2 " << to_string((rand() % 32767)+32768) << endl;
        outfile << "jr $0" << endl;
        outfile.close();
        }
    }

    if (instr == "addiu")
    {   //
        //the immediate here should be signed
        string first = hex_random_generator(3);
        string second = hex_random_generator(3);
        outfile.open(position + instr + "/" + instr + "_1.asm.txt",ios::trunc);
        outfile << "# Check for sign extend (f" << first << ")" << endl;
        outfile << "addiu $2 $2 0xf" << first << endl;
        outfile << "jr $0" << endl;
        outfile.close();
        outfile.open(position + instr + "/" + instr + "_2.asm.txt",ios::trunc);
        outfile << "# Check for sign extend (0"<< second << ")" << endl;
        outfile << "addiu $2 $2 0x0" << second << endl;
        outfile << "jr $0" << endl;
        outfile.close();
        
        for (int i = 3; i <= 4; i++)
        {
            int r1 = rand() % 17 + 8;
            outfile.open(position + instr + "/" + instr + "_" + to_string(i) + ".asm.txt",ios::trunc);
            outfile << "# Addiu case using lui" << endl;
            outfile << assign_reg(i-2,"upper", r1) << endl;
            outfile << assign_reg(i-2,"lower", r1) << endl;
            outfile << instr << " $" << r1 << " $" << r1 << " " << rand() % 32767 << endl;
            outfile << "addiu $2 $" << r1 << " 0" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
            outfile.open(position + instr + "/" + instr + "_" + to_string(i + 2) + ".asm.txt",ios::trunc);
            outfile << "# Addiu case using lui" << endl;
            outfile << assign_reg(i-2,"upper", r1) << endl;
            outfile << assign_reg(i-2,"lower", r1) << endl;
            outfile << instr << " $" << r1 << " $" << r1 << " " << (rand() % 32767) * -1 - 1 << endl;
            outfile << "addiu $2 $" << r1 << " 0" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
        }
    }

    if (instr == "ori" || instr == "andi" || instr == "xori")
    {
        string one = hex_random_generator(3);
        string two = hex_random_generator(3);
        outfile.open(position+ instr + "/" + instr + "_1.asm.txt",ios::trunc);
        outfile << "# Check for sign extend (f" << one << ")" << endl; 
        outfile << "addiu $20 $0 0xffff" << endl;
        outfile << instr << " $2 $20 0xf" << one << endl;
        outfile << "jr $0" << endl;
        outfile.close();
        outfile.open(position+ instr + "/" + instr + "_2.asm.txt",ios::trunc);  
        outfile << "# Check for sign extend (0" << two << ")" << endl; 
        outfile << "addiu $20 $0 0xffff" << endl;
        outfile << instr << " $2 $20 0xf" << two << endl;
        outfile << "jr $0" << endl;
        outfile.close();

        for(int i = 3; i <= 5;i++){
        int r1 = rand() % 17 + 8;
        int r2 = rand() % 17 + 8;
        outfile.open(position + instr + "/" + instr + "_" + to_string(i) + ".asm.txt",ios::trunc);
        outfile << assign_reg(1,"upper", r1) << endl;
        outfile << assign_reg(1,"lower", r1) << endl;
        outfile << instr << " $" << r1 << " $" << r1 << " " << rand() % 32767 << endl;
        outfile << "addiu $2 $" << r1 << " 0" << endl;
        outfile << "jr $0" << endl;
        outfile.close();
        outfile.open(position + instr + "/" + instr + "_" + to_string(i+3) + ".asm.txt",ios::trunc);
        outfile << assign_reg(2,"upper", r2) << endl;
        outfile << assign_reg(2,"lower", r2) << endl;
        outfile << instr << " $" << r2 << " $" << r2 << " " << (rand() % 32767) * -1 - 1 << endl;
        outfile << "addiu $2 $" << r2 << " 0" << endl;
        outfile << "jr $0" << endl;
        outfile.close();
        }
    }

    if (instr == "and" || instr == "or" || instr == "xor")
    {
        for(int i = 1; i <= 5;i++){
        int r1 = rand() % 17 + 8;
        int r2 = rand() % 17 + 8;
        outfile.open(position + instr + "/" + instr + "_" + to_string(i) + ".asm.txt",ios::trunc);
        outfile << assign_reg(1,"upper",r1) << endl;
        outfile << assign_reg(1,"lower",r1) << endl;
        outfile << assign_reg(2,"upper",r2) << endl;
        outfile << assign_reg(2,"lower",r2) << endl;
        outfile << instr << " $" << r1 << " $" << r1 << " $" << r2 << endl;
        outfile << "addiu $2 $" << r1 << " 0" << endl;
        outfile << "jr $0" << endl;
        outfile.close();
        }
    }

    if (instr == "addu" || instr == "subu")
    {
        for (int i = 1; i <= 8; i++)
        {
            //11 12 21 22
            outfile.open(position+ instr + "/" + instr + "_" + to_string(i) + ".asm.txt",ios::trunc);
            int r1 = rand() % 17 + 8;
            int r2 = rand() % 17 + 8;
            int c1,c2;
            if(i == 1|| i == 5){c1 = c2 = 1;}
            if(i == 2|| i == 6){c1 = 1; c2 = 2;}
            if(i == 3|| i == 7){c1= 2;c2 = 1;}
            if(i == 4|| i == 8){c1 = c2 = 2;}
            outfile << assign_reg(c1,"upper", r1) << endl;
            outfile << assign_reg(c1,"lower", r1) << endl;
            outfile << assign_reg(c2,"upper", r2) << endl;
            outfile << assign_reg(c2,"lower", r2) << endl;
            outfile << instr << " $" << r1 << " $" << r1 << " $" << r2 << endl;
            outfile << "addiu $2 $" << r1 << " 0" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
        }
        if(instr == "addu"){
            outfile.open(position+ instr + "/" + instr + "_9.asm.txt",ios::trunc);
            outfile <<"# Adding extreme numbers ffffffff + ffffffff" << endl;
            outfile <<"addiu $17 $17 0xffff" << endl;
            outfile <<"addiu $23 $23 0xffff" << endl;
            outfile <<"addu $17 $17 $23 " << endl;
            outfile <<"addiu $2 $17 0" << endl;
            outfile <<"jr $0" << endl;
            outfile.close();
        }
    }

    if (instr == "mult" ||  instr == "div" || instr == "divu" /*||instr == "multu"*/){
        for (int i = 1; i <= 4; i++)
        {
            //11 12 21 22
            int r1 = rand() % 17 + 8;
            int r2 = rand() % 17 + 8;
            int c1,c2;
            if(i == 1){c1 = c2 = 1;}
            if(i == 2){c1 = 1; c2 = 2;}
            if(i == 3){c1= 2;c2 = 1;}
            if(i == 4){c1 = c2 = 2;}
            outfile.open(position + instr + "/"+ instr + "_" + to_string(i) + ".asm.txt",ios::trunc);
            outfile << assign_reg(c1,"upper", r1) << endl;
            outfile << assign_reg(c1,"lower", r1) << endl;
            outfile << assign_reg(c1,"upper", r2) << endl;
            outfile << assign_reg(c2,"lower", r2) << endl;
            outfile << instr << " $" << r1 << " $" << r2 << endl;
            outfile << "mfhi $2" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
            outfile.open(position+ instr + "/" + instr + "_" + to_string(i+4) + ".asm.txt",ios::trunc);
            outfile << assign_reg(c1,"upper", r1) << endl;
            outfile << assign_reg(c1,"lower", r1) << endl;
            outfile << assign_reg(c2,"upper", r2) << endl;
            outfile << assign_reg(c2,"lower", r2) << endl;
            outfile << instr << " $" << r1 << " $" << r2 << endl;
            outfile << "mflo $2" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
        }
        if(instr == "mult"){
            //added special case for multiplying by 0
            int r1 = rand() % 17 + 8;
            int r2 = rand() % 17 + 8;
            outfile.open(position+ instr + "/" + instr + "_9.asm.txt",ios::trunc);
            outfile << "# Multiplying by 0(hi)" << endl;
            outfile << "lui $" << r1 << " " << to_string(rand() % 65535)<< endl;
            outfile << "addiu $" << r1 << " $" << r1 << " " << to_string((rand() % 65535)-32768)<< endl;
            outfile << "addiu $" << r2 << " $" << r2 << " 0"<< endl;
            outfile << instr << " $" << r1 << " $" << r2 << endl;
            outfile << "mfhi $2" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
            outfile.open(position+ instr + "/" + instr + "_10.asm.txt",ios::trunc);
            outfile << "# Multiplying by 0(lo)"<< endl;
            outfile << "lui $" << r1 << " " << to_string(rand() % 65535)<< endl;
            outfile << "addiu $" << r1 << " $" << r1 << " " << to_string((rand() % 65535)-32768)<< endl;
            outfile << "addiu $" << r2 << " $" << r2 << " 0"<< endl;
            outfile << instr << " $" << r1 << " $" << r2 << endl;
            outfile << "mflo $2" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
        }
        if(instr == "div" || instr == "divu"){
            outfile.open(position+ instr + "/" + instr + "_9.asm.txt",ios::trunc);
            outfile << "# Divide when numerator is zero(lo)" << endl;
            outfile << "lui $15 " << to_string((rand() % 32767)+32768) << endl;
            outfile << "addiu $15 $15 " << to_string((rand() % 65535)-32768)<< endl;
            outfile << "addiu $14 $14 0"<< endl;
            outfile << instr << " $15 $14 $15" << endl;
            outfile << "mflo $2" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
            outfile.open(position+ instr + "/" + instr + "_10.asm.txt",ios::trunc);
            outfile << "# Divide when numerator is zero(hi)" << endl;
            outfile << "lui $15 " << to_string((rand() % 32767)+32768) << endl;
            outfile << "addiu $15 $15 " << to_string((rand() % 65535)-32768)<< endl;
            outfile << "addiu $14 $14 0"<< endl;
            outfile << instr << " $15 $14 $15" << endl;
            outfile << "mfhi $2" << endl;
            outfile << "jr $0" << endl;
            outfile.close(); 

        }
    }
}