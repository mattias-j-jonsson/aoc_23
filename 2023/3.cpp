#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <math.h>



bool has_adjacent_symbol(int row, int column, std::vector<std::vector<bool>>& has_symbol)
{
    int row_l = row-1, row_h = row+1, column_l = column-1, column_h = column+1;
    if(row == 0)
        row_l = row;
    if(row == has_symbol.size()-1)
        row_h = row;
    if(column == 0)
        column_l = column;
    if(column == has_symbol[0].size()-1)
        column_h = column;
    
    return has_symbol[row_l][column_l] || has_symbol[row_l][column] || has_symbol[row_l][column_h] || has_symbol[row][column_l] || has_symbol[row][column_h] || has_symbol[row_h][column_l] || has_symbol[row_h][column] || has_symbol[row_h][column_h];
}

bool is_digit(char c)
{
    return c >= 48 && c <=57;
}

int main(int argc, char const *argv[])
{
    std::fstream input_stream;
    input_stream.open("inputs/3_input", std::ios::in);
    if(input_stream.is_open() == false)
    {
        std::cout << "could not open file" << std::endl;
        return 0;
    }

    int r_counter = 0, c_counter = 0;
    char c;

    while (input_stream.peek() != -1)
    {
        c = input_stream.get();
        if((int) c == 10) {
            r_counter++;
        }
        if(r_counter == 0) {
            c_counter++;
        }
    }

    input_stream.unget();
    if(input_stream.peek() != 10) {
        r_counter++;
    }


    std::cout << "Rows: " << r_counter << std::endl << "Columns: " << c_counter << std::endl;

    std::vector<std::vector<bool>> has_symbol(r_counter, std::vector<bool>(c_counter));
    std::vector<std::vector<bool>> has_number(r_counter, std::vector<bool>(c_counter));

    for(int i = 0; i < r_counter; i++)
    {
        for (int j = 0; j < c_counter; j++)
        {
            has_symbol[i][j] = false;
            has_number[i][j] = false;
        }        
    }


    input_stream.clear();
    input_stream.seekg(0, std::ios::beg);
    

    r_counter = 0;
    c_counter = 0;

    while (input_stream.peek() != -1)
    {
        c = input_stream.get();
        if(c != 46 && c != 10 && (c < 48 || c > 57))
        {
            has_symbol[r_counter][c_counter] = true;
        }
        c_counter++;
        if(c == 10)
        {
            r_counter++;
            c_counter = 0;
        }
    }


    input_stream.clear();
    input_stream.seekg(0, std::ios::beg);

    int num_count = 0;
    r_counter = 0;
    c_counter = 0;

    long int result = 0;
    int to_be_added = 0;
    bool included_in_result = false;

    while (input_stream.peek() != -1)
    {
        c = input_stream.get();
        
        while(is_digit(c))
        {
            num_count++;
            if(!included_in_result && has_adjacent_symbol(r_counter, c_counter, has_symbol))
            {
                included_in_result = true;
            }
            c = input_stream.get();
            c_counter++;
        }
        if(included_in_result)
        {   
            input_stream.seekg(-(num_count+1), std::ios::cur);

            for(int i = 0; i < num_count; i++)
            {
                c = input_stream.get();
                to_be_added += std::pow(10.0, num_count-i-1) * (c % 48);
            }
            result += to_be_added;
            to_be_added = 0;
            // c_counter += num_count-1;
            included_in_result = false;
            c = input_stream.get();
        }

        num_count = 0;
        c_counter++;
        if(c == 10)
        {
            r_counter++;
            c_counter = 0;
        }
    }
    

    std::cout << "result: " << result << std::endl;


    

    return 0;
}
