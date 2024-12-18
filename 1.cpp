#include <fstream>
#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>

int main(int argc, char const *argv[])
{
    std::fstream input_stream;
    input_stream.open("inputs/1.in", std::ios::in);

    std::vector<int> left, right;

    std::string temp;
    while (input_stream >> temp)
    {
        left.push_back(std::stoi(temp));
        input_stream >> temp;
        right.push_back(std::stoi(temp));
    }

    std::sort(left.begin(), left.end());
    std::sort(right.begin(), right.end());

    int result = 0;
    for (unsigned int i = 0; i < left.size(); i++)
    {
        result += std::abs(right[i] - left[i]);
    }
    
    std::cout << "result part 1: " << result << "\n";

    unsigned int i = 0, j = 0;
    result = 0;
    while (i < left.size() && j < right.size())
    {
        if (left[i] < right[j])
        {
            i++;
            j = 0;
        } else if (left[i] > right[j])
        {
            j++;
        } else
        {
            result += left[i];
            j++;
        }
    }

    std::cout << "result part 2: " << result << "\n";


    return 0;
}
