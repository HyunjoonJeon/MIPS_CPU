#include "mips.hpp"

#include <utility>
#include <map>
#include <iostream>
#include <cassert>
#include <iomanip> 

int main(){
    vector<pair<string, string, string, string>> instruction_set;
    map<string, int> labels;

//Collecting the instructions from the .txt file
    string head;
    while(cin >> head){
        if(mips_is_label_decl(head)){
            head.pop_back();
            assert(labels.find(head)==labels.end());
            labels[head]=data_and_instr.size();

        }else if(mips_is_instruction(head)){
            if(mips_instruction_is_function(head)){
                string rd;
                string rt;
                string rs;
                cin >> rd;
                cin >> rs;
                cin >> rt;
                assert(!cin.fail());
                instruction_set.push_back({head, rs, rt, rd});
            }else if(mips_instruction_is_function_immediate(head)){
                string rt;
                string rs;
                string im;
                cin >> rt;
                cin >> rs;
                cin >> im;
                assert(!cin.fail());
                instruction_set.push_back({head, rs, rt, im});
            }else if(mips_instruction_is_branch(head)){
                string rs;
                string rt;
                string la;
                cin >> rs;
                cin >> rt;
                cin >> la;
                assert(!cin.fail());
                instruction_set.push_back({head, rs, rt, la});
            }else if(mips_instruction_is_branch_comparison(head)){
                string rs;
                string la;
                cin >> rs;
                cin >> la;
                assert(!cin.fail());
                instruction_set.push_back({head, rs, la, '0'});
            }else if(mips_instruction_is_jump(head)){
                string la;
                cin >> la;
                assert(!cin.fail());
                instruction_set.push_back({head, la, '0', '0'});
            }else if(mips_instruction_is_memory_using_offset(head)){
                string rt;
                string of;
                string ba;
                cin >> rt;
                cin >> of;
                cin >> ba;
                assert(!cin.fail());
                instruction_set.push_back({head, ba, rt, of});
            }else if(mips_instruction_is_HiLo(head)){
                string rs;
                cin >> rs;
                assert(!cin.fail());
                instruction_set.push_back({head, rs, '0', '0'});
            }else if(mips_instruction_is_MulDiv(head)){
                string rs;
                string rt;
                cin >> rs;
                cin >> rt;
                assert(!cin.fail());
                instruction_set.push_back({head, rs, rt, '0'});
                
            }else if(mips_instruction_is_shift(head)){
                string rd;
                string rt;
                string sa;
                cin >> rd;
                cin >> rt;
                cin >> sa;
                assert(!cin.fail());
                instruction_set.push_back({head, rt, rd, sa});
            }else if(mips_instruction_is_shift_variable(head)){
                string rd;
                string rt;
                string rs;
                cin >> rd;
                cin >> rt;
                cin >> rs;
                assert(!cin.fail());
                instruction_set.push_back({head, rs, rt, rd});
            }else if("jalr" == head)){
                string rd;
                string rs;
                cin >> rd;
                cin >> rs;
                assert(!cin.fail());
                instruction_set.push_back({head, rd, rs, '0'});
            }else if("jr" == head){
                string rs;
                cin >> rs;
                assert(!cin.fail());
                instruction_set.push_back({head, rs, '0', '0'});
            }else if("lui" == head){
                string rt;
                string im;
                cin >> rt;
                cin >> im;
                assert(!cin.fail());
                instruction_set.push_back({head, rt, im, '0'});
            }
        }else{
            cerr<<"Couldn't parse '"<<head<<"'\n";
            exit(1)
        }
}
//Working with the data
}
