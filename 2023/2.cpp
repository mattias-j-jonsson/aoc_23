#include <fstream>
#include <iostream>
#include <string>


bool is_legal(std::string str, int red_max = 12, int green_max = 13, int blue_max = 14)
{
    std::string colours[3] = {"red", "green", "blue"};
    int colours_max[3] = {red_max, green_max, blue_max};

    int temp_pos;
    for (size_t i = 0; i < 3; i++)
    {
        temp_pos = str.find(colours[i]);
        if(temp_pos == std::string::npos)
            continue;
        
        switch (temp_pos - 3)
        {
        case ' ':
            break;
        case -1:
            break;
        default:
            if(std::stoi(str.substr(temp_pos-3, 2)) > colours_max[i])
            {
                return false;
            }
            break;
        }
    }
    
    return true;
}

int game_score(std::string& game_str) 
{
    int temp_old = game_str.find_first_of(':');
    if(game_str.length() == 0 || temp_old == std::string::npos)
    {
        return 0;
    }

    int game_nr = std::stoi(game_str.substr(5, temp_old-5));
    int temp_new;
    std::string temp_str;

    do
    {
        temp_new = game_str.find_first_of(';', temp_old+1);
        temp_str = game_str.substr(temp_old+2, temp_new-temp_old-2);
        temp_old = temp_new;

        if(is_legal(temp_str) == false)
        {
            return 0;
        }
    }while (temp_new != std::string::npos);
    
    
    return game_nr;
}

void update_needed_balls(std::string& str, int* neededRGB)
{
    std::string colours[3] = {"red", "green", "blue"};
    
    int temp_pos, num_of_balls;
    for (size_t i = 0; i < 3; i++)
    {
        temp_pos = str.find(colours[i]);
        if(temp_pos == std::string::npos)
            continue;
        
        switch (temp_pos-3)
        {
        case ' ':
            num_of_balls = std::stoi(str.substr(temp_pos-2, 1));
            break;
        case -1:
            num_of_balls = std::stoi(str.substr(temp_pos-2, 1));
            break;
        default:
            num_of_balls = std::stoi(str.substr(temp_pos-3, 2));
            break;
        }
        if (num_of_balls > neededRGB[i])
        {
            neededRGB[i] = num_of_balls;
        }
    }   
}

int game_score_power(std::string& game_str)
{
    int temp_old = game_str.find_first_of(':');
    if(game_str.length() == 0 || temp_old == std::string::npos)
    {
        return 0;
    }

    int temp_new;
    std::string temp_str;
    int needed_balls[3] = {0,0,0};

    do
    {
        temp_new = game_str.find_first_of(';', temp_old+1);
        temp_str = game_str.substr(temp_old+2, temp_new-temp_old-2);
        temp_old = temp_new;

        update_needed_balls(temp_str, needed_balls);
    }while (temp_new != std::string::npos);
    
    
    return needed_balls[0]*needed_balls[1]*needed_balls[2];
}

int main(int argc, char const *argv[])
{
    std::fstream input_stream;
    const std::string filename = "inputs/2_input";
    input_stream.open(filename, std::ios::in);

    if(!input_stream.is_open())
    {
        std::cout << "failed to open input stream." << std::endl;
        return 1;
    }

    std::string temp;
    int result = 0;
    int result_power = 0;
    while (input_stream.eof() == false)
    {
        std::getline(input_stream, temp);
        result += game_score(temp);
        result_power += game_score_power(temp);
    }

    std::cout << "result: " << result << std::endl;
    std::cout << "result_power: " << result_power << std::endl;

    return 0;
}
