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
        outfile.open(position + instr + "/"+ instr + "_1.asm.txt",ios::trunc);
        outfile << instr << " $2 " << rand() % 32767 << endl;
        outfile << "jr $0" << endl;
        outfile.close();
        outfile.open(position + instr + "/"+ instr + "_2.asm.txt",ios::trunc);
        outfile << instr << " $2 " << to_string((rand() % 32767)+32768) << endl;
        outfile << "jr $0" << endl;
        outfile.close();
    }

    if (instr == "addiu")
    {   //
        //the immediate here should be signed
        for (int i = 1; i <= 2; i++)
        {
            int r1 = rand() % 17 + 8;
            outfile.open(position + instr + "/" + instr + "_" + to_string(i) + ".asm.txt",ios::trunc);
            outfile << assign_reg(i,"upper", r1) << endl;
            outfile << assign_reg(i,"lower", r1) << endl;
            outfile << instr << " $" << r1 << " $" << r1 << " " << rand() % 32767 << endl;
            outfile << "addiu $2 $" << r1 << " 0" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
            outfile.open(position + instr + "/" + instr + "_" + to_string(i + 2) + ".asm.txt",ios::trunc);
            outfile << assign_reg(i,"upper", r1) << endl;
            outfile << assign_reg(i,"lower", r1) << endl;
            outfile << instr << " $" << r1 << " $" << r1 << " " << (rand() % 32767) * -1 - 1 << endl;
            outfile << "addiu $2 $" << r1 << " 0" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
        }
    }

    if (instr == "ori" || instr == "andi" || instr == "xori")
    {
        int r1 = rand() % 17 + 8;
        int r2 = rand() % 17 + 8;
        outfile.open(position+ instr + "/" + instr + "_1.asm.txt",ios::trunc);
        outfile << assign_reg(1,"upper", r1) << endl;
        outfile << assign_reg(1,"lower", r1) << endl;
        outfile << instr << " $" << r1 << " $" << r1 << " " << rand() % 32767 << endl;
        outfile << "addiu $2 $" << r1 << " 0" << endl;
        outfile << "jr $0" << endl;
        outfile.close();
        outfile.open(position+ instr + "/" + instr + "_2.asm.txt",ios::trunc);
        outfile << assign_reg(2,"upper", r2) << endl;
        outfile << assign_reg(2,"lower", r2) << endl;
        outfile << instr << " $" << r2 << " $" << r2 << " " << (rand() % 32767) * -1 - 1 << endl;
        outfile << "addiu $2 $" << r2 << " 0" << endl;
        outfile << "jr $0" << endl;
        outfile.close();
    }

    if (instr == "and" || instr == "or" || instr == "xor")
    {
        int r1 = rand() % 17 + 8;
        int r2 = rand() % 17 + 8;
        outfile.open(position+ instr + "/" + instr + "_1.asm.txt",ios::trunc);
        outfile << assign_reg(1,"upper",r1) << endl;
        outfile << assign_reg(1,"lower",r1) << endl;
        outfile << assign_reg(2,"upper",r2) << endl;
        outfile << assign_reg(2,"lower",r2) << endl;
        outfile << instr << " $" << r1 << " $" << r1 << " $" << r2 << endl;
        outfile << "addiu $2 $" << r1 << " 0" << endl;
        outfile << "jr $0" << endl;
        outfile.close();
    }

    if (instr == "addu" || instr == "subu")
    {
        for (int i = 1; i <= 4; i++)
        {
            //11 12 21 22
            outfile.open(position+ instr + "/" + instr + "_" + to_string(i) + ".asm.txt",ios::trunc);
            int r1 = rand() % 17 + 8;
            int r2 = rand() % 17 + 8;
            int c1,c2;
            if(i == 1){c1 = c2 = 1;}
            if(i == 2){c1 = 1; c2 = 2;}
            if(i == 3){c1= 2;c2 = 1;}
            if(i == 4){c1 = c2 = 2;}
            outfile << assign_reg(c1,"upper", r1) << endl;
            outfile << assign_reg(c1,"lower", r1) << endl;
            outfile << assign_reg(c2,"upper", r2) << endl;
            outfile << assign_reg(c2,"lower", r2) << endl;
            outfile << instr << " $" << r1 << " $" << r1 << " $" << r2 << endl;
            outfile << "addiu $2 $" << r1 << " 0" << endl;
            outfile << "jr $0" << endl;
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
            outfile << "# Multiplying by 0(hi)";
            outfile << "lui $" << r1 << " " << to_string(rand() % 65535);
            outfile << "addiu $" << r1 << " $" << r1 << " " << to_string((rand() % 65535)-32768);
            outfile << "addiu $" << r2 << " $" << r2 << " 0";
            outfile << instr << " $" << r1 << " $" << r2 << endl;
            outfile << "mfhi $2" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
            outfile.open(position+ instr + "/" + instr + "_10.asm.txt",ios::trunc);
            outfile << "# Multiplying by 0(lo)";
            outfile << "lui $" << r1 << " " << to_string(rand() % 65535);
            outfile << "addiu $" << r1 << " $" << r1 << " " << to_string((rand() % 65535)-32768);
            outfile << "addiu $" << r2 << " $" << r2 << " 0";
            outfile << instr << " $" << r1 << " $" << r2 << endl;
            outfile << "mflo $2" << endl;
            outfile << "jr $0" << endl;
            outfile.close();
        }
    }
}