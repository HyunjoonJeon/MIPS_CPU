#include "mips.hpp"

#include <utility>
#include <map>
#include <iostream>
#include <cassert>
#include <iomanip> 

int main(){
    vector<<string, string, string, string>> instruction_set;
    map<string, int> labels;

//Collecting the instructions from the .txt file
    string head;
    while(cin >> head){
        if(mips_is_label_decl(head)){
            head.pop_back();
            assert(labels.find(head)==labels.end());
            labels[head]=instru.size();

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
            }else if(head == "jalr")){
                string rd;
                string rs;
                cin >> rd;
                cin >> rs;
                assert(!cin.fail());
                instruction_set.push_back({head, rd, rs, '0'});
            }else if(head == "jr"){
                string rs;
                cin >> rs;
                assert(!cin.fail());
                instruction_set.push_back({head, rs, '0', '0'});
            }else if(head == "lui"){
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
    cout << hex;    
    cout << setw(8); 
    cout << setfill('0'); 

    for(int i = 0; i < instruction_set.size(); i++){
        if(mu0_is_instruction(instruction_set[i][0])){
            string opname = instruction_set[i][0];
            uint16_t opcode = mips_opname_to_opcode(opname);
            if(mips_instruction_is_function(opname)){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i][1], 1) + mips_regname_to_regcode(instruction_set[i][2], 2) + mips_regname_to_regcode(instruction_set[i][3], 3)) << endl;
            }else if(mips_instruction_is_function_immediate(opname)){
                string temp1 = to_hex8(opcode + mips_regname_to_regcode(instruction_set[i][1], 1) + mips_regname_to_regcode(instruction_set[i][2], 2));
                string temp2 = instruction_set[i][3];
                cout << temp1.substr(0, 15) + temp2.substr(2) << endl;
            }else if(mips_instruction_is_branch(opname)){
                //TO-DO Incorporate Labels
            }else if(mips_instruction_is_branch_comparison(opname)){
                //TO-DO Incorporate Labels
            }else if(mips_instruction_is_jump(opname)){
                //TO-DO Incorporate Labels
            }else if(mips_instruction_is_memory_using_offset(opname)){
                //TO-DO Incorporate memory offsets
            }else if(mips_instruction_is_HiLo(opname){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i][1], 1)) << endl;
            }else if(mips_instruction_is_MulDiv(opname)){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i][1], 1) + mips_regname_to_regcode(instruction_set[i][2], 2)) << endl;
            }else if(mips_instruction_is_shift(opname)){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i][1], 2) + mips_regname_to_regcode(instruction_set[i][2], 3) + stoi(instruction_set[i][3])) << endl;
            }else if(mips_instruction_is_shift_variable(opname)){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i][1], 1) + mips_regname_to_regcode(instruction_set[i][2], 2) + mips_regname_to_regcode(instruction_set[i][3], 3)) << endl;
            }else if(opname == "jalr")){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i][1], 1) + mips_regname_to_regcode(instruction_set[i][2], 3)) << endl;
            }else if(opname == 'jr'){
                cout << to_hex8(opcode + mips_regname_to_regcode(instruction_set[i][1], 1)) << endl;
            }else if(opname == 'lui'){
                string temp1 = to_hex8(opcode + mips_regname_to_regcode(instruction_set[i][1], 2));
                string temp2 = instruction_set[i][2];
                cout << temp1.substr(0, 15) + temp2.substr(2) << endl;
            }

    }
}
}
