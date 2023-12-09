#include <iostream>
#include <fstream>
#include <vector>
#include <string>

void parse_input_str(std::string& input_str, std::vector<int>& output)
{
    size_t index_number;
    size_t index_space;
    index_number = input_str.find_first_not_of(' ');
    index_space = input_str.find_first_of(' ');
    while (index_number != std::string::npos)
    {
        output.push_back(std::stoi(input_str.substr(index_number, index_space-index_number)));
        index_number = input_str.find_first_not_of(' ', index_space);
        index_space = input_str.find_first_of(' ', index_number);
    }
}

int recursive_calc(std::vector<int>& input)
{
    std::vector<int> new_input;
    bool finished = true;
    int new_value;
    for (size_t i = 0; i < input.size()-1; i++)
    {
        new_value = input[i+1]-input[i];
        new_input.push_back(new_value);
        if (input[i] != 0 || input[i+1] != 0)
        {
            finished = false;
        }
    }
    if (!finished)
    {
        return input.back() + recursive_calc(new_input);
    } else
    {
        return 0;
    }
}

int calculate_next(std::string& input_str)
{
    std::vector<int> input;
    parse_input_str(input_str, input);
    int result = recursive_calc(input);
    return result;
}

int recursive_calc_prev(std::vector<int>& input)
{
    std::vector<int> new_input;
    bool finished = true;
    int new_value;
    for (size_t i = 0; i < input.size()-1; i++)
    {
        new_value = input[i+1]-input[i];
        new_input.push_back(new_value);
        if (input[i] != 0 || input[i+1] != 0)
        {
            finished = false;
        }
    }
    if (!finished)
    {
        return input.front() - recursive_calc_prev(new_input);
    } else
    {
        return 0;
    }
}

int calculate_prev(std::string& input_str)
{
    std::vector<int> input;
    parse_input_str(input_str, input);
    int result = recursive_calc_prev(input);
    return result;
}


int main(int argc, char const *argv[])
{
    std::ifstream input_stream;
    input_stream.open("inputs/9_input");
    if(input_stream.is_open() == false) {
        std::cout << "failed to open file. Exiting.\n";
        return -1;
    }

    int result = 0;
    std::string temp;
    while (!input_stream.eof())
    {
        std::getline(input_stream, temp);
        if (temp.empty() == false)
        {
            result += calculate_prev(temp);
        }
    }
    
    std::cout << "Result: " << result << "\n";
    return 0;
}
