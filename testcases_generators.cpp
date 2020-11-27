#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>
#include <fstream>
using namespace std;

//Basic Function: input instructions and will automatically generate random number test cases
//Input by hand type or echo
//Output will generate automatically
//Input "all" will generate all the random testcases for each instructions

int main()
{ 
    string instr;
    getline(cin, instr);
    srand(time(0));

    //need to add certain edge cases after this for loop for some particular tests 
    for (int i = 0; i < 5; i++)
    {
        // (-32768,32767)  as 2^16 2's compliment number
        int i1 = rand() % 32767;            // test 0 to 32767
        int i2 = (rand() % 32767) * -1 - 1; // test -1 to -32768
        int r1 = rand() % 10;
        int r2 = rand() % 10;
        int r3 = rand() % 10;
        int r4 = rand() % 10;
        int r5 = rand() % 10;
        int r6 = rand() % 10;

        //initialise the txt output files to empty ones
        // might add cases where immediates are in form 0x0001 etc.
        if (instr == "addiu" || instr == "all")
        {
            ofstream outfile;
            if(i == 0){
                outfile.open("test/0-assembly/addiu.asm.txt", ios::trunc);
            }
            else{
                outfile.open("test/0-assembly/addiu.asm.txt", ios::app);
            }
            outfile << "addiu $s" << r1 << ",$s" << r2 << "," << i1 << endl;
            outfile << "addiu $s" << r3 << ",$s" << r4 << "," << i2 << endl;
            outfile.close();
        }
        if (instr == "addu" || instr == "all")
        {
            ofstream outfile;
            if(i == 0){
                outfile.open("test/0-assembly/addu.asm.txt", ios::trunc);
            }
            else{
                outfile.open("test/0-assembly/addu.asm.txt", ios::app);
            }
            outfile << "addu $s" << r1 << ",$s" << r2 << ","
                    << ",$s" << r5 << endl;
            outfile << "addu $s" << r3 << ",$s" << r4 << ","
                    << ",$s" << r6 << endl;
            outfile.close();
        }
        if (instr == "and" || instr == "all")
        {
            ofstream outfile;
            if(i == 0){
                outfile.open("test/0-assembly/and.asm.txt", ios::trunc);
            }
            else{
                outfile.open("test/0-assembly/and.asm.txt", ios::app);
            }
            outfile << "and $s" << r1 << ",$s" << r2 << ","
                    << ",$s" << r5 << endl;
            outfile << "and $s" << r3 << ",$s" << r4 << ","
                    << ",$s" << r6 << endl;
            outfile.close();
        }
        if (instr == "andi" || instr == "all")
        {
            ofstream outfile;
            if(i == 0){
                outfile.open("test/0-assembly/andi.asm.txt", ios::trunc);
            }
            else{
                outfile.open("test/0-assembly/andi.asm.txt", ios::app);
            }
            outfile << "andi $s" << r1 << ",$s" << r2 << "," << i1 << endl;
            outfile << "andi $s" << r3 << ",$s" << r4 << "," << i2 << endl;
            outfile.close();
        }
        if (instr == "div" || instr == "all")
        {
            ofstream outfile;
            if(i == 0){
                outfile.open("test/0-assembly/div.asm.txt", ios::trunc);
            }
            else{
                outfile.open("test/0-assembly/div.asm.txt", ios::app);
            }
            outfile << "div $s" << r1 << ",$s" << r2 << ","
                    << ",$s" << r5 << endl;
            outfile << "div $s" << r3 << ",$s" << r4 << ","
                    << ",$s" << r6 << endl;
            outfile.close();
        }
        if (instr == "divu" || instr == "all")
        {
            ofstream outfile;
            if(i == 0){
                outfile.open("test/0-assembly/divu.asm.txt", ios::trunc);
            }
            else{
                outfile.open("test/0-assembly/divu.asm.txt", ios::app);
            }
            outfile << "divu $s" << r1 << ",$s" << r2 << ","
                    << ",$s" << r5 << endl;
            outfile << "divu $s" << r3 << ",$s" << r4 << ","
                    << ",$s" << r6 << endl;
            outfile.close();
        }
        if (instr == "mult" || instr == "all")
        {
            ofstream outfile;
            if(i == 0){
                outfile.open("test/0-assembly/mult.asm.txt", ios::trunc);
            }
            else{
                outfile.open("test/0-assembly/mult.asm.txt", ios::app);
            }
            outfile << "mult $s" << r1 << ",$s" << r2 << ","
                    << ",$s" << r5 << endl;
            outfile << "mult $s" << r3 << ",$s" << r4 << ","
                    << ",$s" << r6 << endl;
            outfile.close();
        }
        if (instr == "multu" || instr == "all")
        {
            ofstream outfile;
            if(i == 0){
                outfile.open("test/0-assembly/multu.asm.txt", ios::trunc);
            }
            else{
                outfile.open("test/0-assembly/multu.asm.txt", ios::app);
            }
            outfile << "multu $s" << r1 << ",$s" << r2 << ","
                    << ",$s" << r5 << endl;
            outfile << "multu $s" << r3 << ",$s" << r4 << ","
                    << ",$s" << r6 << endl;
            outfile.close();
        }
        if (instr == "or" || instr == "all")
        {
            ofstream outfile;
            if(i == 0){
                outfile.open("test/0-assembly/or.asm.txt", ios::trunc);
            }
            else{
                outfile.open("test/0-assembly/or.asm.txt", ios::app);
            }
            outfile << "or $s" << r1 << ",$s" << r2 << ","
                    << ",$s" << r5 << endl;
            outfile << "or $s" << r3 << ",$s" << r4 << ","
                    << ",$s" << r6 << endl;
            outfile.close();
        }
        if (instr == "ori" || instr == "all")
        {
            ofstream outfile;
            if(i == 0){
                outfile.open("test/0-assembly/ori.asm.txt", ios::trunc);
            }
            else{
                outfile.open("test/0-assembly/ori.asm.txt", ios::app);
            }
            outfile << "ori $s" << r1 << ",$s" << r2 << "," << i1 << endl;
            outfile << "ori $s" << r3 << ",$s" << r4 << "," << i2 << endl;
            outfile.close();
        }
    }
}