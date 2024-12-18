#include <iostream>
#include <fstream>
#include <string>

bool is_digit(char c)
{
    return c >= 48 && c <=57;
}

struct IndexedNumber
{
    size_t start, end;
    std::string num_str;
    int num;

    IndexedNumber() : num_str(std::string("")), start(0), end(0) {}

    IndexedNumber(std::string str, size_t start, size_t end) : num_str(str), start(start), end(end) {
        num = std::stoi(num_str);
    }

    bool in_range(size_t pos)
    {
        return (end <= pos+1 && end >= pos-1) || (start >= pos-1 && start <= pos+1);
    }

    int length()
    {
        return end-start+1;
    }

    bool is_empty()
    {
        return start == end;
    }
};


int find_adjacent_numbers(std::string row, size_t pos, IndexedNumber** result)
{
    std::string num_str = std::string("");
    const std::string numbers = "0123456789";
    
    size_t start_pos, end_pos;
    IndexedNumber* temp;
    int numbers_found = 0;

    start_pos = row.find_first_of(numbers, 0);
    while (start_pos != std::string::npos)
    {
        end_pos = row.find_first_not_of(numbers, start_pos);
        if(end_pos == std::string::npos)
        {
            temp = new IndexedNumber(row.substr(start_pos, row.length()-start_pos), start_pos, row.length()-1);
        } else
        {
            temp = new IndexedNumber(row.substr(start_pos, end_pos-start_pos), start_pos, end_pos-1);
        }
        
        if(temp->in_range(pos)) {
            if(result[0] == nullptr)
            {
                result[0] = temp;
                numbers_found++;
            } else
            {
                result[1] = temp;
                numbers_found++;
            }
        } else
        {
            delete(temp);
        }
        start_pos = row.find_first_of(numbers, end_pos);
    }
    return numbers_found;
}

int some_func(std::string first, std::string second, std::string third, int row_with_star, int star_pos)
{
    bool num_1 = false, num_2 = false;
    int numbers_found = 0;
    IndexedNumber* valid_numbers[2] = {nullptr, nullptr};
    if(!first.empty())
    {
        // code for most cases
        numbers_found += find_adjacent_numbers(first, star_pos, valid_numbers);
        numbers_found += find_adjacent_numbers(second, star_pos, valid_numbers);
        numbers_found += find_adjacent_numbers(third, star_pos, valid_numbers);

    } else
    {
        if(row_with_star == 2)
        {
            // code for rows 0 and 1, first iteration of for-loop in main
            numbers_found += find_adjacent_numbers(second, star_pos, valid_numbers);
            numbers_found += find_adjacent_numbers(third, star_pos, valid_numbers);
        } else
        {
            // code for last two rows of file
            numbers_found += find_adjacent_numbers(second, star_pos, valid_numbers);
            numbers_found += find_adjacent_numbers(third, star_pos, valid_numbers);
        }
    }


    int result = 0;
    if(numbers_found != 2)
    {
        return 0;
    } else
    {
        result = valid_numbers[0]->num * valid_numbers[1]->num;
        delete(valid_numbers[0]);
        delete(valid_numbers[1]);
        return result;
    }
}

int main(int argc, char const *argv[])
{
    std::ifstream input_stream;
    input_stream.open("inputs/3_input");
    if(input_stream.is_open() == false)
    {
        std::cout << "could not open file." << std::endl;
        return 1;
    }

    int rows = 0;
    std::string temp;
    while (!input_stream.eof())
    {
        std::getline(input_stream, temp);
        rows++;
    }
    if(temp.empty())
        rows--;


    input_stream.clear();
    input_stream.seekg(0, std::ios::beg);

    std::string first = std::string(""), second = std::string(""), third = std::string("");


    int result = 0;
    std::getline(input_stream, second);
    std::getline(input_stream, third);
    size_t star_pos;
    for(int i = 0; i < rows; i++)
    {
        if(i == rows-1)
        {
            star_pos = third.find_first_of('*');
            if(star_pos != std::string::npos)
            {
                while (star_pos != std::string::npos)
                {
                    result += some_func(std::string(""), second, third, 3, star_pos);
                    star_pos = third.find_first_of('*', star_pos+1);
                }
            }
        } else
        {
            star_pos = second.find_first_of('*', 0);
            if(star_pos != std::string::npos)
            {
                if(i == 0)
                {
                    while (star_pos != std::string::npos)
                    {
                        result += some_func(std::string(""), second, third, 2, star_pos);
                        star_pos = second.find_first_of('*', star_pos+1);
                    }
                } else
                {
                    while (star_pos != std::string::npos)
                    {
                        result += some_func(first, second, third, 2, star_pos);
                        star_pos = second.find_first_of('*', star_pos+1);
                    }
                    
                }
            }
        }
        if(i < rows-2)
        {
            first = second;
            second = third;
            std::getline(input_stream, third);
        }
    }

    std::cout << "Result: " << result << std::endl;

    return 0;
}
