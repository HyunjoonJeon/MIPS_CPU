#include "mips.hpp"

#include <utility>
#include <map>
#include <iostream>
#include <cassert>
#include <iomanip> 

struct instruction{
    string s0;
    string s1;
    string s2;
    string s3;
};

int main(){
    vector<instruction> instruction_set;
    map<string, int> labels;
    string tmp;

//Collecting the instructions from the .txt file
    string head;
    while(cin >> head){
        if(mips_is_label_decl(head)){
            head.pop_back();
            assert(labels.find(head)==labels.end());
            labels[head]=instruction_set.size();

        }else if(head.at(0)=='#'){
            //when the read in line is a comment, ignore it
	    getline(cin,tmp);
            continue;

        }else if(mips_is_instruction(head)){
            if(mips_instruction_is_function(head)){
                string rd;
                string rt;
                string rs;
                cin >> rd;
                cin >> rs;
                cin >> rt;
                assert(!cin.fail());
                instruction temp = {head,rs, rt, rd};
                instruction_set.push_back(temp);
            }else if(mips_instruction_is_function_immediate(head)){
                string rt;
                string rs;
                string im;
                cin >> rt;
                cin >> rs;
                cin >> im;
                assert(!cin.fail());
                instruction temp = {head, rs, rt, im};
                instruction_set.push_back(temp);
            }else if(mips_instruction_is_branch_comparison(head)){
                string rs;
                string rt;
                string la;
                cin >> rs;
                cin >> rt;
                cin >> la;
                assert(!cin.fail());
                instruction temp = {head, rs, rt, la};
                instruction_set.push_back(temp);
            }else if(mips_instruction_is_branch(head)){
                string rs;
                string la;
                cin >> rs;
                cin >> la;
                assert(!cin.fail());
                instruction temp = {head, rs, la, "0"};
                instruction_set.push_back(temp);
            }else if(mips_instruction_is_jump(head)){
                string la;
                cin >> la;
                assert(!cin.fail());
                instruction temp = {head, la, "0", "0"};
                instruction_set.push_back(temp);
            }else if(mips_instruction_is_memory_using_offset(head)){
                string rt;
                string operand;
                cin >> rt;
                cin >> operand;
                int pos = operand.find("(");
                string of = operand.substr(0, pos);
                string ba = operand.substr(pos + 1, operand.length()-of.length()-2);
                assert(!cin.fail());
                instruction temp = {head, ba, rt, of};
                instruction_set.push_back(temp);
            }else if(mips_instruction_is_HiLo_mt(head)){
                string rs;
                cin >> rs;
                assert(!cin.fail());
                instruction temp = {head, rs, "0", "0"};
                instruction_set.push_back(temp);
            }else if(mips_instruction_is_HiLo_mf(head)){
                string rd;
                cin >> rd;
                assert(!cin.fail());
                instruction temp = {head, rd, "0", "0"};
                instruction_set.push_back(temp);
            }else if(mips_instruction_is_MulDiv(head)){
                string rs;
                string rt;
                cin >> rs;
                cin >> rt;
                assert(!cin.fail());
                instruction temp = {head, rs, rt, "0"};
                instruction_set.push_back(temp);
            }else if(mips_instruction_is_shift(head)){
                string rd;
                string rt;
                string sa;
                cin >> rd;
                cin >> rt;
                cin >> sa;
                assert(!cin.fail());
                instruction temp = {head, rt, rd, sa};
                instruction_set.push_back(temp);
            }else if(mips_instruction_is_shift_variable(head)){
                string rd;
                string rt;
                string rs;
                cin >> rd;
                cin >> rt;
                cin >> rs;
                assert(!cin.fail());
                instruction temp = {head, rs, rt, rd};
                instruction_set.push_back(temp);
            }else if(head == "jalr"){
                string rd;
                string rs;
                cin >> rd;
                cin >> rs;
                assert(!cin.fail());
                instruction temp = {head, rs, rd, "0"};
                instruction_set.push_back(temp);
            }else if(head == "jr"){
                string rs;
                cin >> rs;
                assert(!cin.fail());
                instruction temp = {head, rs, "0", "0"};
                instruction_set.push_back(temp);
            }else if(head == "lui"){
                string rt;
                string im;
                cin >> rt;
                cin >> im;
                assert(!cin.fail());
                instruction temp = {head, rt, im, "0"};
                instruction_set.push_back(temp);
            }
        }else{
            cerr<<"Couldn't parse '"<<head<<"'\n";
            exit(1);
        }
}
//Working with the data
    cout << hex;    
    cout << setw(8); 
    cout << setfill('0'); 

    for(int i = 0; i < instruction_set.size(); i++){
        if(mips_is_instruction(instruction_set[i].s0)){
            string opname = instruction_set[i].s0;
            uint32_t opcode = mips_opname_to_opcode(opname);
            if(mips_instruction_is_function(opname)){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 1) + mips_regname_to_regcode(instruction_set[i].s2, 2) + mips_regname_to_regcode(instruction_set[i].s3, 3)) << endl;
            }else if(mips_instruction_is_function_immediate(opname)){
                string temp1 = to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 1) + mips_regname_to_regcode(instruction_set[i].s2, 2));
                string temp2 = instruction_set[i].s3;
                if(temp2[0] == '0' && temp2[1] == 'x'){
                    string hexim = temp2.substr(2);
                    while (hexim.length() != 4){
                        hexim = '0' + hexim;    
                    }
                    cout << temp1.substr(0, 4) + hexim << endl;
                }else{
                    cout << temp1.substr(0, 4) + to_hex8(stoi(temp2.substr(0))).substr(4, 4) << endl;
                }
            }else if(mips_instruction_is_branch_comparison(opname)){
                assert(labels.find(instruction_set[i].s3)!=labels.end());
                uint32_t address=labels[instruction_set[i].s3]-i-1;
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 1) + mips_regname_to_regcode(instruction_set[i].s2, 2) + address) << endl;
            }else if(mips_instruction_is_branch(opname)){
                assert(labels.find(instruction_set[i].s2)!=labels.end());
                uint32_t address=labels[instruction_set[i].s2]-i-1;
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 1) + address) << endl;
            }else if(mips_instruction_is_jump(opname)){
                assert(labels.find(instruction_set[i].s1)!=labels.end());
                uint32_t address=labels[instruction_set[i].s1]+ 66060288;
                cout << to_hex8(opcode + address) << endl;
            }else if(mips_instruction_is_memory_using_offset(opname)){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 1) + mips_regname_to_regcode(instruction_set[i].s2, 2)).substr(0,4) + to_hex8(stoi(instruction_set[i].s3)).substr(4,4) << endl;
            }else if(mips_instruction_is_HiLo_mt(opname)){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 1)) << endl;
            }else if(mips_instruction_is_HiLo_mf(opname)){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 3)) << endl;
            }else if(mips_instruction_is_MulDiv(opname)){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 1) + mips_regname_to_regcode(instruction_set[i].s2, 2)) << endl;
            }else if(mips_instruction_is_shift(opname)){
                uint32_t temp = stoi(instruction_set[i].s3);
                uint32_t sa = temp << 6;
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 2) + mips_regname_to_regcode(instruction_set[i].s2, 3) + sa) << endl;
            }else if(mips_instruction_is_shift_variable(opname)){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 1) + mips_regname_to_regcode(instruction_set[i].s2, 2) + mips_regname_to_regcode(instruction_set[i].s3, 3)) << endl;
            }else if(opname == "jalr"){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 1) + mips_regname_to_regcode(instruction_set[i].s2, 3)) << endl;
            }else if(opname == "jr"){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 1)) << endl;
            }else if(opname == "lui"){
                string temp1 = to_hex8(opcode + mips_regname_to_regcode(instruction_set[i].s1, 2));
                string temp2 = instruction_set[i].s2;
                if(temp2[0] == '0' && temp2[1] == 'x'){
                    string hexim = temp2.substr(2);
                    while (hexim.length() != 4){
                        hexim = '0' + hexim;    
                    }
                    cout << temp1.substr(0, 4) + hexim << endl;

                }else{
                    cout << temp1.substr(0, 4) + to_hex8(stoi(temp2.substr(0))).substr(4, 4) << endl;
                }
            }

    }
}
}
