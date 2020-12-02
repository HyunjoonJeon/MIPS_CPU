#include "mips.hpp"

#include <utility>
#include <map>
#include <iostream>
#include <cassert>
#include <iomanip> 

int main()
{
    vector<pair<string, string, string, string, string, string>> instruction_set;
    map<string, int> labels;

    string head;
    while(cin >> head){}
        if(mips_is_label_decl(head)){
            head.pop_back();
            assert(labels.find(head)==labels.end());
            labels[head]=data_and_instr.size();

        }else if(mips_is_instruction(head)){
            string address;
            if((head)){
                cin >> address;
                assert(!cin.fail());
            }
        }
}
