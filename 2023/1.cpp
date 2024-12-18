#include <string>
#include <fstream>
#include <iostream>

int get_line_value(std::string input_line) {
    int first_number;
    int last_number;
    int temp;
    bool first_found = false;
    
    for (int i = 0; i < input_line.size(); i++)
    {
        temp = (int) input_line[i];
        if(temp >= 48 && temp <= 57) {
            temp %= 48;
            if(!first_found){
                first_number = temp;
                last_number = temp;
                first_found = true;
            } else {
                last_number = temp;
            }
        }
    }
    return 10*first_number + last_number;
}

int get_line_value_letters(std::string input_line) {
    int first_pos = input_line.size(), last_pos = -1, first_number, last_number;
    int temp_pos;

    std::string numbers[20] = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};

    for(int i = 0; i < 20; i++) {
        temp_pos = input_line.find(numbers[i]);
        while (temp_pos != std::string::npos) 
        {
            if(temp_pos < first_pos) {
                first_pos = temp_pos;
                first_number = i % 10;
            }
            if(temp_pos > last_pos) {
                last_pos = temp_pos;
                last_number = i % 10;
            }
            temp_pos = input_line.find(numbers[i], temp_pos+1);
        }
        
    }

    return 10*first_number + last_number;
}

int main(int argc, char const *argv[])
{
    const std::string filename = "inputs/1_input";
    std::fstream input_stream;
    std::string input_string;
    int acc_values = 0;
    int temp;

    input_stream.open(filename, std::ios::in);
    while (input_stream.eof() == false) 
    {
        input_stream >> input_string;
        temp = get_line_value_letters(input_string);
        acc_values += temp;
    }
    acc_values -= temp;

    std::cout << "acc_values: " << acc_values << std::endl;
    // std:: cout << get_line_value_letters("1jdrpjpvkmmseven") << std::endl;

    return 0;
}
