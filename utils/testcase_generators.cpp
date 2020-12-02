#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>
#include <fstream>
#include <vector>
#include <cassert>
using namespace std;

//ADDIU,ANDI,ORI,LUI
//ADDU,AND,DIV,DIVU,MULT,MULTU,OR

string assign_reg(int n, string side, int R)
{ // 1 == ++, 2 == +-,3 == -+, 4 == --
    string res;
    string r = to_string(R);
    assert(n == 1 || n == 2);
    assert(side == "upper" || side == "lower");

    if (side == "upper")
    {
        res = "lui $s" + r + "," + to_string(rand() % 65535);
    }
    if (side == "lower" && n == 1)
    {
        res = "addiu $s" + r + ",$s" + r + "," + to_string(rand() % 32767);
    }
    if (side == "lower" && n == 2)
    {
        res = "addiu $s" + r + ",$s" + r + "," + to_string((rand() % 32767) * -1 - 1);
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
    // the immediate should not be signed, so only positive value allowed
    {
        outfile.open(position + instr + ".asm.txt", ios::trunc);
        outfile << instr << " $v0," << rand() % 65535 << endl;
        outfile.close();
    }

    if (instr == "addiu")
    {   //
        //the immediate here should be signed
        for (int i = 1; i <= 2; i++)
        {
            int r1 = rand() % 7;
            outfile.open(position + instr + "_" + to_string(i) + ".asm.txt", ios::trunc);
            outfile << assign_reg(i, "upper", r1) << endl;
            outfile << assign_reg(i, "lower", r1) << endl;
            outfile << instr << " $s" << r1 << ",$s" << r1 << "," << rand() % 32767 << endl;
            outfile << "addiu $v0,$s" << r1 << ",0" << endl;
            outfile.close();
            outfile.open(position + instr + "_" + to_string(i + 2) + ".asm.txt", ios::trunc);
            outfile << assign_reg(i, "upper", r1) << endl;
            outfile << assign_reg(i, "lower", r1) << endl;
            outfile << instr << " $s" << r1 << ",$s" << r1 << "," << (rand() % 32767) * -1 - 1 << endl;
            outfile << "addiu $v0,$s" << r1 << ",0" << endl;
            outfile.close();
        }
    }

    if (instr == "ori" || instr == "andi")
    {
        int r1 = rand() % 7;
        int r2 = rand() % 7;
        outfile.open(position + instr + "_1.asm.txt", ios::trunc);
        outfile << assign_reg(1, "upper", r1) << endl;
        outfile << assign_reg(1, "lower", r1) << endl;
        outfile << instr << " $s" << r1 << ",$s" << r1 << "," << rand() % 32767 << endl;
        outfile << "addiu $v0,$s" << r1 << ",0" << endl;
        outfile.close();
        outfile.open(position + instr + "_2.asm.txt", ios::trunc);
        outfile << assign_reg(2, "upper", r2) << endl;
        outfile << assign_reg(2, "lower", r2) << endl;
        outfile << instr << " $s" << r2 << ",$s" << r2 << "," << (rand() % 32767) * -1 - 1 << endl;
        outfile << "addiu $v0,$s" << r2 << ",0" << endl;
        outfile.close();
    }

    if (instr == "and" || instr == "or")
    {
        int r1 = rand() % 7;
        int r2 = rand() % 7;
        outfile.open(position + instr + ".asm.txt", ios::trunc);
        outfile << assign_reg(1, "upper", r1) << endl;
        outfile << assign_reg(1, "lower", r1) << endl;
        outfile << assign_reg(2, "upper", r2) << endl;
        outfile << assign_reg(2, "lower", r2) << endl;
        outfile << instr << " $s" << r1 << ",$s" << r1 << ",$s" << r2 << endl;
        outfile << "addiu $v0,$s" << r1 << ",0" << endl;
        outfile.close();
    }

    if (instr == "addu")
    {
        for (int i = 1; i <= 4; i++)
        {
            //11,12,21,22
            outfile.open(position + instr + "_" + to_string(i) + ".asm.txt", ios::trunc);
            int r1 = rand() % 7;
            int r2 = rand() % 7;
            int c1,c2;
            if(i == 1){c1 = c2 = 1;}
            if(i == 2){c1 = 1; c2 = 2;}
            if(i == 3){c1= 2;c2 = 1;}
            if(i == 4){c1 = c2 = 2;}
            outfile << assign_reg(1, "upper", r1) << endl;
            outfile << assign_reg(c1, "lower", r1) << endl;
            outfile << assign_reg(1, "upper", r2) << endl;
            outfile << assign_reg(c2, "lower", r2) << endl;
            outfile << instr << " $s" << r1 << ",$s" << r1 << ",$s" << r2 << endl;
            outfile << "addiu $v0,$s" << r1 << ",0" << endl;
            outfile.close();
        }
    }

    if (instr == "mult" || instr == "multu"  || instr == "div" || instr == "divu"){
        for (int i = 1; i <= 4; i++)
        {
            //11,12,21,22
            int r1 = rand() % 7;
            int r2 = rand() % 7;
            int c1,c2;
            if(i == 1){c1 = c2 = 1;}
            if(i == 2){c1 = 1; c2 = 2;}
            if(i == 3){c1= 2;c2 = 1;}
            if(i == 4){c1 = c2 = 2;}
            outfile.open(position + instr + "_" + to_string(i) + ".asm.txt", ios::trunc);
            outfile << assign_reg(1, "upper", r1) << endl;
            outfile << assign_reg(c1, "lower", r1) << endl;
            outfile << assign_reg(1, "upper", r2) << endl;
            outfile << assign_reg(c2, "lower", r2) << endl;
            outfile << instr << " $s" << r1 << ",$s" << r2 << endl;
            outfile << "mfhi $v0" << endl;
            outfile.close();
            outfile.open(position + instr + "_" + to_string(i+4) + ".asm.txt", ios::trunc);
            outfile << assign_reg(1, "upper", r1) << endl;
            outfile << assign_reg(c1, "lower", r1) << endl;
            outfile << assign_reg(1, "upper", r2) << endl;
            outfile << assign_reg(c2, "lower", r2) << endl;
            outfile << instr << " $s" << r1 << ",$s" << r2 << endl;
            outfile << "mflo $v0" << endl;
            outfile.close();
        }
    }
}