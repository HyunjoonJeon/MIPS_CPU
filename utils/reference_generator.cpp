#include <iostream>
#include <assert.h>
#include <map>
#include <string>
#include <cmath>
using namespace std;

//lui 001111 DONE
//andi 001100 DONE
//addiu 001001 DONE
//ori 001101 DONE
//addu 000000  f=100001 DONE
//or 000000 f=100101 DONE
//and 000000 f=100100 DONE
//mfhi 000000 f=010000 DONE
//mflo 000000 f=010010 DONE
//div 000000    f=011010 DONE
//divu 000000 f= 011011 DONE
//mult 000000 f=011000 DONE
//jr 000000 f = 001000 DONE
//multu 000000 f=011001 CANNOT DO HERE

string hex_to_bin(string long_hex)
{
    string bin = "";
    for (int i = 0; i < long_hex.size(); i++)
    {
        char hex = long_hex.at(i);
        if (hex == ' ')
            bin.append("");
        if (hex == '0')
            bin.append("0000");
        if (hex == '1')
            bin.append("0001");
        if (hex == '2')
            bin.append("0010");
        if (hex == '3')
            bin.append("0011");
        if (hex == '4')
            bin.append("0100");
        if (hex == '5')
            bin.append("0101");
        if (hex == '6')
            bin.append("0110");
        if (hex == '7')
            bin.append("0111");
        if (hex == '8')
            bin.append("1000");
        if (hex == '9')
            bin.append("1001");
        if (hex == 'a')
            bin.append("1010");
        if (hex == 'b')
            bin.append("1011");
        if (hex == 'c')
            bin.append("1100");
        if (hex == 'd')
            bin.append("1101");
        if (hex == 'e')
            bin.append("1110");
        if (hex == 'f')
            bin.append("1111");
    }
    return bin;
}
string bin_to_hex(string long_bin)
{
    string hex;
    for (int i = 0; i < long_bin.size(); i += 4)
    {
        string sub_bin = long_bin.substr(i, 4);
        if (sub_bin == "0000")
            hex.append("0");
        if (sub_bin == "0001")
            hex.append("1");
        if (sub_bin == "0010")
            hex.append("2");
        if (sub_bin == "0011")
            hex.append("3");
        if (sub_bin == "0100")
            hex.append("4");
        if (sub_bin == "0101")
            hex.append("5");
        if (sub_bin == "0110")
            hex.append("6");
        if (sub_bin == "0111")
            hex.append("7");
        if (sub_bin == "1000")
            hex.append("8");
        if (sub_bin == "1001")
            hex.append("9");
        if (sub_bin == "1010")
            hex.append("a");
        if (sub_bin == "1011")
            hex.append("b");
        if (sub_bin == "1100")
            hex.append("c");
        if (sub_bin == "1101")
            hex.append("d");
        if (sub_bin == "1110")
            hex.append("e");
        if (sub_bin == "1111")
            hex.append("f");
    }
    return hex;
}
long bin_to_int(string long_bin){
    long res = 0;
    for (int i = long_bin.size()-1; i >0;i--)
    {
        if (long_bin.at(i) == '1')
        {
            res += pow(2,long_bin.size()-1-i);
        }
    }
    if(long_bin.at(0) == '1')
    {
        res -= pow(2,long_bin.size()-1);
    }
    return res;
    }
string int_to_hex(long n,int len){
    string hex = "";
    //keep dividing by 16,get the remainder, convert to hex then append to the end
    long x = n;
    int y = 0;
    //cout << "n = " << x << endl;
    if(n < 0){
        x += pow(2,len-1); 
    }
    //cout << "x = " << x << endl;
    while(x!= 0){
        y = x%16; 
        if(y == 0) hex = "0" + hex;
        if(y == 1) hex = "1"+ hex;
        if(y == 2) hex = "2"+ hex;
        if(y == 3) hex = "3"+ hex;
        if(y == 4) hex = "4"+ hex;
        if(y == 5) hex = "5"+ hex;
        if(y == 6) hex = "6"+ hex;
        if(y == 7) hex = "7"+ hex;
        if(y == 8) hex = "8"+ hex;
        if(y == 9) hex = "9"+ hex;
        if(y == 10) hex = "a"+ hex;
        if(y == 11) hex = "b"+ hex;
        if(y == 12) hex = "c"+ hex;
        if(y == 13) hex = "d"+ hex;
        if(y == 14) hex = "e"+ hex;
        if(y == 15) hex = "f"+ hex;
        x = x/16;
    }
    //cout << "hex now = " << hex << endl;
    if(n < 0){
        if(hex.at(0) == '0'){hex.insert(1,"8");}
        else if(hex.at(0) == '1'){hex.insert(1,"9");}
        else if(hex.at(0) == '2'){hex.insert(1,"a");}
        else if(hex.at(0) == '3'){hex.insert(1,"b");}
        else if(hex.at(0) == '4'){hex.insert(1,"c");}
        else if(hex.at(0) == '5'){hex.insert(1,"d");}
        else if(hex.at(0) == '6'){hex.insert(1,"e");}
        else if(hex.at(0) == '7'){hex.insert(1,"f");}
        else{hex = "1"+ hex;}
        hex = hex.substr(1,hex.size()-1);
    }
    return hex;
}
//by default the output is hex input is hex as well

int main()
{
    map<string, long> regs;
    while (cin){
        string hex_instr, bin_instr, op, rs, rt;
        cin >> hex_instr;
        if (hex_instr == "") break;
        //generate biniary from hex
        bin_instr.append(hex_to_bin(hex_instr));
        //cout << bin_instr << endl;

        assert(bin_instr.size() == 32);
        op = bin_instr.substr(0, 6);
        rs = bin_instr.substr(6, 5);
        rt = bin_instr.substr(11, 5);
        //cout << "op " << op << endl;
        //cout << "rs " << rs << endl;
        //cout << "rt " << rt << endl;
        if (op == "000000"){
            string func = bin_instr.substr(26, 6);
            string rd = bin_instr.substr(16,5);
            if (func == "100001"){//addu
                //cout << "addu" << endl;
                long val_rs = 0;
                if(regs.find(rs)!= regs.end())
                    val_rs = regs.find(rs)->second;
                long val_rt = 0;
                if(regs.find(rt)!= regs.end())
                    val_rt = regs.find(rt)->second;
                long sum = val_rs+val_rt;
                //cout << "sum" << sum << endl;

                if(sum > 2147483647) sum -= pow(2,32);
                if(sum < -214783648) sum += pow(2,32);
                //puting value in regs
                if(regs.find(rd)!= regs.end()){
                    regs.at(rd) = sum;
                }else{
                    regs.insert(pair<string, long>(rd,sum));
                }
            }
            if (func == "100011"){//subu
                //cout << "subu" << endl;
                long val_rs = 0;
                if(regs.find(rs)!= regs.end())
                    val_rs = regs.find(rs)->second;
                long val_rt = 0;
                if(regs.find(rt)!= regs.end())
                    val_rt = regs.find(rt)->second;
                long dif = val_rs - val_rt;
                //cout << "dif" << dif << endl;

                if(dif > 2147483647) dif -= pow(2,32);
                if(dif < -214783648) dif += pow(2,32);
                //puting value in regs
                if(regs.find(rd)!= regs.end()){
                    regs.at(rd) = dif;
                }else{
                    regs.insert(pair<string, long>(rd,dif));
                }
            }
            if (func == "100100"){//and
                //cout << "and" << endl;
                string val_rs = "";
                if(regs.find(rs)!= regs.end())
                    val_rs = hex_to_bin(int_to_hex(regs.find(rs)->second,32));
                //extend to 32 bit in case
                while(val_rs.size()<32){
                    val_rs = "0" + val_rs;
                }
                string val_rt = "";
                if(regs.find(rt)!= regs.end())
                    val_rt = hex_to_bin(int_to_hex(regs.find(rt)->second,32));
                //extend to 32 bit in case
                while(val_rt.size()<32){
                    val_rt = "0" + val_rt;
                }

                assert(val_rs.size()==32 && val_rt.size()==32);
                string res = "";
                for(int i = 0; i<32;i++){
                    if(val_rs.at(i)=='1'&& val_rt.at(i)=='1'){
                        res = res + "1";
                    }else{
                        res = res + "0";
                    }
                }
                //puting value in regs
                if(regs.find(rd)!= regs.end()){
                    regs.at(rd) = bin_to_int(res);
                }else{
                    regs.insert(pair<string, long>(rd,bin_to_int(res)));
                }
            }
            if (func == "100101"){//or
                //cout << "or" << endl;
                string val_rs = "";
                if(regs.find(rs)!= regs.end())
                    val_rs = hex_to_bin(int_to_hex(regs.find(rs)->second,32));
                //extend to 32 bit in case
                while(val_rs.size()<32){
                    val_rs = "0" + val_rs;
                }
                string val_rt = "";
                if(regs.find(rt)!= regs.end())
                    val_rt = hex_to_bin(int_to_hex(regs.find(rt)->second,32));
                //extend to 32 bit in case
                while(val_rt.size()<32){
                    val_rt = "0" + val_rt;
                }
                
                assert(val_rs.size()==32 && val_rt.size()==32);
                string res = "";
                for(int i = 0; i<32;i++){
                    if(val_rs.at(i)=='0'&& val_rt.at(i)=='0'){
                        res = res + "0";
                    }else{
                        res = res + "1";
                    }
                }
                //puting value in regs
                if(regs.find(rd)!= regs.end()){
                    regs.at(rd) = bin_to_int(res);
                }else{
                    regs.insert(pair<string, long>(rd,bin_to_int(res)));
                }
            }
            if (func == "100110"){//xor
                //cout << "xor" << endl;
                string val_rs = "";
                if(regs.find(rs)!= regs.end())
                    val_rs = hex_to_bin(int_to_hex(regs.find(rs)->second,32));
                //extend to 32 bit in case
                while(val_rs.size()<32){
                    val_rs = "0" + val_rs;
                }
                string val_rt = "";
                if(regs.find(rt)!= regs.end())
                    val_rt = hex_to_bin(int_to_hex(regs.find(rt)->second,32));
                //extend to 32 bit in case
                while(val_rt.size()<32){
                    val_rt = "0" + val_rt;
                }
                
                assert(val_rs.size()==32 && val_rt.size()==32);
                string res = "";
                for(int i = 0; i<32;i++){
                    if(val_rs.at(i)=='0'&& val_rt.at(i)=='0'){
                        res = res + "0";
                    }else{
                        res = res + "1";
                    }
                }
                //puting value in regs
                if(regs.find(rd)!= regs.end()){
                    regs.at(rd) = bin_to_int(res);
                }else{
                    regs.insert(pair<string, long>(rd,bin_to_int(res)));
                }

            }
            if (func == "010010"){//mflo
                //cout << "mflo" << endl;
                long data = 0;
                if (regs.find("lo") != regs.end()){
                    data = regs.find("lo")->second;
                }
                //puting value in regs
                if(regs.find(rd)!= regs.end()){
                    regs.at(rd) = data;
                }else{
                    regs.insert(pair<string, long>(rd,data));
                }
            }
            if (func == "010000"){//mfhi
                //cout << "mfhi" << endl;
                long data = 0;
                if (regs.find("hi") != regs.end()){
                    data = regs.find("hi")->second;
                }
                //puting value in regs
                if(regs.find(rd)!= regs.end()){
                    regs.at(rd) = data;
                }else{
                    regs.insert(pair<string, long>(rd,data));
                }
            }
            if (func == "011010"){//div
                //cout << "div" << endl;
                long val_rs = 0;
                if(regs.find(rs)!= regs.end())
                    val_rs = regs.find(rs)->second;
                long val_rt = 0;
                if(regs.find(rt)!= regs.end())
                    val_rt = regs.find(rt)->second;
                
                //puting value in regs
                if(regs.find("hi")!= regs.end()){
                    regs.at("hi") = val_rs%val_rt;
                }else{
                    regs.insert(pair<string, long>("hi",val_rs%val_rt));
                }
                if(regs.find("lo")!= regs.end()){
                    regs.at("lo") = val_rs/val_rt;
                }else{
                    regs.insert(pair<string, long>("lo",val_rs/val_rt));
                }
            }
            if (func == "011011"){//divu
                //cout << "divu" << endl;
                long k = pow(2,32);
                long val_rs = 0;
                if(regs.find(rs)!= regs.end())
                    val_rs = regs.find(rs)->second;
                if(val_rs < 0) val_rs += k;
                long val_rt = 0;
                if(regs.find(rt)!= regs.end())
                    val_rt = regs.find(rt)->second;
                if(val_rt < 0) val_rt += k;

                long rem = val_rs%val_rt;
                if(rem > 2147483647) rem -= pow(2,32);
                long div_val = val_rs/val_rt;
                if(div_val > 2147483647) div_val -= pow(2,32);
                
                //cout << "rem = " << rem << endl;
                //cout << "div_val = " << div_val << endl;
                
                //puting value in regs
                if(regs.find("hi")!= regs.end()){
                    regs.at("hi") = rem;
                }else{
                    regs.insert(pair<string, long>("hi",rem));
                }
                if(regs.find("lo")!= regs.end()){
                    regs.at("lo") = div_val;
                }else{
                    regs.insert(pair<string, long>("lo",div_val));
                }
            }
            if (func == "001000"){//jr $0 which will be the end
                if(rs == "00000"){
                    //OUTPUT
                    if (regs.find("00010") != regs.end()){
                        string out = int_to_hex(regs.find("00010")->second,32);
                        while(out.size()<8){
                            out = "0" + out;
                        }
                        cout << out << endl;
                    }else{
                        cout /*<< "default value" */<< "00000000" << endl;
                    }
                break;
                }
            }
            if (func == "011000"){//mult
                //cout << "mult" << endl;
                long val_rs = 0;
                if(regs.find(rs)!= regs.end())
                    val_rs = regs.find(rs)->second;
                long val_rt = 0;
                if(regs.find(rt)!= regs.end())
                    val_rt = regs.find(rt)->second;
                long pro = val_rs*val_rt;

                string hex = int_to_hex(pro,64);
                string hi = hex.substr(0,8);
                string lo = hex.substr(8,8);
                long hi_val = bin_to_int(hex_to_bin(hi));
                long lo_val = bin_to_int(hex_to_bin(lo));

                //puting value in regs
                if(regs.find("hi")!= regs.end()){
                    regs.at("hi") = hi_val;
                }else{
                    regs.insert(pair<string, long>("hi",hi_val));
                }
                if(regs.find("lo")!= regs.end()){
                    regs.at("lo") = lo_val;
                }else{
                    regs.insert(pair<string, long>("lo",lo_val));
                }
            }
        }
        else{
            string im = bin_instr.substr(16, 16);
            if (op == "001111"){//lui
                //cout << "lui" << endl;
                im = im + "0000000000000000";
                //cout <<"im = " << im << endl;
                //cout <<"im = " << bin_to_hex(im) << endl;
                //cout << bin_to_int(im) << endl;
                if(regs.find(rt)!= regs.end()){
                    //cout << "find rt" << endl;
                    regs.at(rt) = bin_to_int(im);
                }else{
                    //cout << "not find rt" << endl;
                    regs.insert(pair<string, long>(rt, bin_to_int(im)));
                }
            }
            if(op == "001001"){//addiu
                //cout << "addiu" << endl;
                string im = bin_instr.substr(16, 16);
                if(im.at(0)== '1'){
                    im = "1111111111111111"+im;
                }else{
                    im = "0000000000000000"+im;
                }
                //cout <<"im = " << im << endl;
                
                //looking for value in rs
                long val_rs = 0;
                if(regs.find(rs)!= regs.end())
                    val_rs = regs.find(rs)->second;

                //checking if rt already exist in map
                if(regs.find(rt)!= regs.end()){
                    regs.at(rt) = bin_to_int(im)+val_rs;
                }else{
                    regs.insert(pair<string, long>(rt, bin_to_int(im)+val_rs));
                }
            }
            if(op == "001100"){//andi
            //cout << "andi" << endl;
                im = "0000000000000000" + im;
                //looking for val in rs
                string val_rs = "00000000000000000000000000000000";
                if(regs.find(rs)!= regs.end())
                    val_rs = hex_to_bin(int_to_hex(regs.find(rs)->second,32));
                //cout << "val_rs = " << val_rs << endl;
                //extend it to 32 bits incase
                while(val_rs.size()<32){
                    val_rs = "0" + val_rs;
                }
                //cout << "im = " << im << endl;
                string ands = "";  
                for(int i = 0; i < 32;i++){
                    if(val_rs.at(i)=='1' && im.at(i)=='1'){
                        ands = ands + "1"; 
                    }else{
                        ands = ands + "0";
                    }
                }
                //cout << "and = " << ands << endl;
                //puting value in regs
                if(regs.find(rt)!= regs.end()){
                    regs.at(rt) = bin_to_int(ands);
                }else{
                    regs.insert(pair<string, long>(rt, bin_to_int(ands)));
                }
            }
            if(op == "001101"){//ori
                im = "0000000000000000" + im;
                //looking for val in rs
                string val_rs = "00000000000000000000000000000000";
                if(regs.find(rs)!= regs.end())
                    val_rs = hex_to_bin(int_to_hex(regs.find(rs)->second,32));
                //cout << "val_rs = " << val_rs << endl;
                //extend to 32 bit in case
                while(val_rs.size()<32){
                    val_rs = "0" + val_rs;
                }
                string ori = "";  
                for(int i = 0; i < 32;i++){
                    if(val_rs.at(i)=='0' && im.at(i)=='0'){
                        ori = ori + "0"; 
                    }else{
                        ori = ori + "1";
                    }
                }
                //cout << "ori = " << ands << endl;
                //puting value in regs
                if(regs.find(rt)!= regs.end()){
                    regs.at(rt) = bin_to_int(ori);
                }else{
                    regs.insert(pair<string, long>(rt, bin_to_int(ori)));
                }

            } 
            if(op == "001110"){//xori
                im = "0000000000000000" + im;
                //looking for val in rs
                string val_rs = "00000000000000000000000000000000";
                if(regs.find(rs)!= regs.end())
                    val_rs = hex_to_bin(int_to_hex(regs.find(rs)->second,32));
                //cout << "val_rs = " << val_rs << endl;
                //extend to 32 bit in case
                while(val_rs.size()<32){
                    val_rs = "0" + val_rs;
                }
                string xori = "";  
                for(int i = 0; i < 32;i++){
                    if((val_rs.at(i)=='0' && im.at(i)=='0')||(val_rs.at(i)=='1' && im.at(i)=='1')){
                        xori = xori + "0"; 
                    }else{
                        xori = xori + "1";
                    }
                }
                //cout << "xori = " << ands << endl;
                //puting value in regs
                if(regs.find(rt)!= regs.end()){
                    regs.at(rt) = bin_to_int(xori);
                }else{
                    regs.insert(pair<string, long>(rt, bin_to_int(xori)));
                }
            }
        }
    }
}