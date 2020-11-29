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
    assert(n == 1 || n == 2 || n == 3 || n == 4);
    assert(side == "upper" || side == "lower");

    if (side == "upper" && (n == 1 || n == 2))
    {
        res = "lui $s" + r + "," + to_string(rand() % 32767);
    }
    if (side == "upper" && (n == 3 || n == 4))
    {
        res = "lui $s" + r + "," + to_string((rand() % 32767) * -1 - 1);
    }
    if (side == "lower" && (n == 1 || n == 3))
    {
        res = "addiu $s" + r + ",$" + r + "," + to_string(rand() % 32767);
    }
    if (side == "lower" && (n == 2 || n == 4))
    {
        res = "addiu $s" + r + ",$" + r + "," + to_string((rand() % 32767) * -1 - 1);
    }
    return res;
}

int main()
{
    string instr;
    getline(cin, instr);
    srand(time(0));
    string position = "test/0-assembly/"; //storing positionition for the testcases txt
    ofstream outfile;

    int num = 1;

    for (int i = 0; i < num; i++)
    {
        if (instr == "lui") //this instruction should be tested first
        {
            outfile.open(position + instr + "_1.asm.txt", ios::trunc);
            outfile << instr << " $v0," << rand() % 32767 << endl;
            outfile.close();
            outfile.open(position + instr + "_2.asm.txt", ios::trunc);
            outfile << instr << " $v0," << ((rand() % 32767) * -1 - 1) << endl;
            outfile.close();
        }

        if (instr == "addiu")
        { //1.+++,2.+-+,3.-++,4.--+, 5.++-,6.+--,7.-+-,8,---
            for (int i = 1; i <= 4; i++)
            {
                int r1 = rand() % 7;
                outfile.open(position + instr + "_" + to_string(i) + ".asm.txt", ios::trunc);
                outfile << assign_reg(i, "upper", r1) << endl;
                outfile << assign_reg(i, "lower", r1) << endl;
                outfile << instr << " $s" << r1 << ",$s" << r1 << "," << rand() % 32767 << endl;
                outfile << "addiu $v0,$s" << r1 << ",0" << endl;
                outfile.close();
                outfile.open(position + instr + "_" + to_string(i + 4) + ".asm.txt", ios::trunc);
                outfile << assign_reg(i, "upper", r1) << endl;
                outfile << assign_reg(i, "lower", r1) << endl;
                outfile << instr << " $s" << r1 << ",$s" << r1 << "," << (rand() % 32767) * -1 - 1 << endl;
                outfile << "addiu $v0,$s" << r1 << ",0" << endl;
                outfile.close();
            }
        }

        if (instr == "ori" || instr == "andi")
        {
            int c1 = rand() % 3 + 1;
            int c2 = rand() % 3 + 1;
            int r1 = rand() % 7;
            outfile.open(position + instr + "_1.asm.txt", ios::trunc);
            outfile << assign_reg(c1, "upper", r1) << endl;
            outfile << assign_reg(c1, "lower", r1) << endl;
            outfile << instr << " $s" << r1 << ",$s" << r1 << "," << rand() % 32767 << endl;
            outfile << "addiu $v0,$s" << r1 << ",0" << endl;
            outfile.close();
            outfile.open(position + instr + "_2.asm.txt", ios::trunc);
            outfile << assign_reg(c2, "upper", r1) << endl;
            outfile << assign_reg(c2, "lower", r1) << endl;
            outfile << instr << " $s" << r1 << ",$s" << r1 << "," << (rand() % 32767) * -1 - 1 << endl;
            outfile << "addiu $v0,$s" << r1 << ",0" << endl;
            outfile.close();
        }

        if (instr == "and" || instr == "or")
        {
            int r1 = rand() % 7;
            int r2 = rand() % 7;
            int c1 = rand() % 3 + 1;
            int c2 = rand() % 3 + 1;
            outfile.open(position + instr + ".asm.txt", ios::trunc);
            outfile << assign_reg(c1, "upper", r1) << endl;
            outfile << assign_reg(c1, "lower", r1) << endl;
            outfile << assign_reg(c2, "upper", r2) << endl;
            outfile << assign_reg(c2, "lower", r2) << endl;
            outfile << instr << " $s" << r1 << ",$s" << r1 << ",$s" << r2 << endl;
            outfile << "addiu $v0,$s" << r1 << ",0" << endl;
            outfile.close();
        }

        if (instr == "addu" || instr == "div" || instr == "divu" || instr == "mult" || instr == "multu")
        {
            for (int i = 1; i <= 4; i++)
            {
                outfile.open(position + instr + "_" + to_string(i) + ".asm.txt", ios::trunc);
                int c1;
                int c2;
                if (i == 1)
                {
                    c1 = rand() % 2 + 1;
                    c2 = rand() % 2 + 1;
                }
                else if (i == 2)
                {
                    c1 = rand() % 2 + 1;
                    c2 = rand() % 2 + 3;
                }
                else if (i == 3)
                {
                    c1 = rand() % 2 + 3;
                    c2 = rand() % 2 + 1;
                }
                else
                {
                    c1 = rand() % 2 + 3;
                    c2 = rand() % 2 + 3;
                }
                int r1 = rand() % 7;
                int r2 = rand() % 7;
                outfile << assign_reg(c1, "upper", r1) << endl;
                outfile << assign_reg(c1, "lower", r1) << endl;
                outfile << assign_reg(c2, "upper", r2) << endl;
                outfile << assign_reg(c2, "lower", r2) << endl;
                outfile << instr << " $s" << r1 << ",$s" << r1 << ",$s" << r2 << endl;
                outfile << "addiu $v0,$s" << r1 << ",0" << endl;
                outfile.close();
            }
        }
    }
}