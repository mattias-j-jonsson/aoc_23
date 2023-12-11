/* 
  -
  |
  F S-E
  7 S-W
  L N-E
  J N-W
 */

import 'dart:io';

class Node {
  Node(this.value, this.direction);
  
  int value;
  String direction;
  
  @override
  String toString() {
    return value.toString();
    // if(direction != null)
    //   return direction!;
    // else
    //   return 'null';
  }
}


void main(List<String> args) {
  var file = File('inputs/10_test_4');
  List<String> input = file.readAsLinesSync();
  
  int loopLength = calculate(input);

  print(loopLength); // answer part 1 == looplength/2

  calculatePart2(input);
}

int calculate(List<String> input) {
  int rowMAX = input[0].length; // -1?
  int colMAX = input.length; // -1?
  int sCol = -1;
  int sRow = -1;
  for (var i = 0; i < input.length; i++) {
    sCol = input[i].indexOf('S');
    if(sCol != -1) {
      sRow = i;
      break;
    }
  }

  String direction = '';
  if (sRow > 0 && isLegalSymbol(input[sRow-1][sCol], 'N')) {
    direction = 'N';
  } else if (sCol < colMAX && isLegalSymbol(input[sRow][sCol+1], 'E')) {
    direction = 'E';
  } else if (sRow < rowMAX && isLegalSymbol(input[sRow+1][sCol], 'S')) {
    direction = 'S';
  } else if (sCol > 0 && isLegalSymbol(input[sRow][sCol-1], 'W')) {
    direction = 'W';
  } else {
    return -1;
  }
  
  String currentSymbol = 'S';
  int currRow = sRow;
  int currCol = sCol;
  int steps = 0;
  do {
    steps++;
    if(direction == 'N') {
      currRow--;
    } else if (direction == 'E') {
      currCol++;
    } else if (direction == 'S') {
      currRow++;
    } else if (direction == 'W') {
      currCol--;
    }
      currentSymbol = input[currRow][currCol];
      direction = newDirection(currentSymbol, direction);
  } while (currentSymbol != 'S');

  // Map directions = <String, bool>{'N': false, 'E': false, 'S': false, 'W': false};

  return steps;
}

int calculatePart2(List<String> input) {
  int rowMAX = input[0].length; // -1?
  int colMAX = input.length; // -1?
  int sCol = -1;
  int sRow = -1;
  for (var i = 0; i < input.length; i++) {
    sCol = input[i].indexOf('S');
    if(sCol != -1) {
      sRow = i;
      break;
    }
  }

  String direction = '';
  if (sRow > 0 && isLegalSymbol(input[sRow-1][sCol], 'N')) {
    direction = 'N';
  } else if (sCol < colMAX && isLegalSymbol(input[sRow][sCol+1], 'E')) {
    direction = 'E';
  } else if (sRow < rowMAX && isLegalSymbol(input[sRow+1][sCol], 'S')) {
    direction = 'S';
  } else if (sCol > 0 && isLegalSymbol(input[sRow][sCol-1], 'W')) {
    direction = 'W';
  } else {
    return -1;
  }
  
  // Part 2 shenagigans
  // List<List<int>> tileStatus = List.generate(colMAX, (index) => List.generate(rowMAX, (index) => 0));
  List<List<Node>> tileStatus = List.generate(colMAX, (index) => List.generate(rowMAX, (index) => Node(0, 'null')));


  
  String currentSymbol = 'S';
  int currRow = sRow;
  int currCol = sCol;
  int steps = 0;
  do {
    steps++;
    tileStatus[currRow][currCol].value = 2;
    tileStatus[currRow][currCol].direction = direction;
    if(direction == 'N') {
      currRow--;
    } else if (direction == 'E') {
      currCol++;
    } else if (direction == 'S') {
      currRow++;
    } else if (direction == 'W') {
      currCol--;
    }
      currentSymbol = input[currRow][currCol];
      direction = newDirection(currentSymbol, direction);
  } while (currentSymbol != 'S');

  for (var element in tileStatus) {
    print(element);
  }

  print('');

  for (var row in tileStatus) {
    bool foundTwo = false;
    int index = 0;
    String currentDirection = '';
    for (var i = 0; i < rowMAX; i++) {
      if(row[i].value == 2) {
        if(!foundTwo) {
          index = i;
          foundTwo = true;
          currentDirection = row[i].direction;
        }
        if ((i-index) > 1) {
          row.fillRange(index + 1, i, Node(1, 'null'));
          index = i;
          // foundTwo = false;
        } else {
          index = i;  
        }
      }
    }
  }


  for (var element in tileStatus) {
    print(element);
    print('');
  }

  int ones = 0;

  for (var row in tileStatus) {
    row.forEach((element) {if(element.value == 1) ones++;});
  }

  print('Number of 1\'s: $ones');

  return 0;
}

String insideDirection(String startDir, String currentDir) {
  int a = 1;
  String insideDir = '';

  switch (a) {
    case 1:
      insideDir = 'N';
      break;
    case 2:
      insideDir = 'E';
      break;
    case 3:
      insideDir = 'S';
      break;
    case 4:
      insideDir = 'W';
      break;
    default:
  }
}

/* 
  -
  |
  F S-E
  7 S-W
  L N-E
  J N-W
 */

bool isLegalSymbol(String char, String direction) {
  String validNorth = '|F7';
  String validEast = '-7J';
  String validSouth = '|LJ';
  String validWest = '-FL';

  bool isLegal = false;
  switch (direction) {
    case 'N':
      isLegal = validNorth.contains(char);
      break;
    case 'E':
      isLegal = validEast.contains(char);
      break;
    case 'S':
      isLegal = validSouth.contains(char);
      break;
    case 'W':
      isLegal = validWest.contains(char);
      break;
    default:
  }
  return isLegal;
}

String newDirection(String symbol, String direction) {
  String newDirection = '';
  switch (symbol) {
    case '-':
    case '|':
      newDirection = direction;
      break;
    case 'F':
      if(direction == 'N')
        newDirection = 'E';
      else
        newDirection = 'S';
      break;
    case '7':
      if(direction == 'N')
        newDirection = 'W';
      else
        newDirection = 'S';
    case 'L':
      if(direction == 'S')
        newDirection = 'E';
      else
        newDirection = 'N';
      break;
    case 'J':
      if(direction == 'S')
        newDirection = 'W';
      else
        newDirection = 'N';
      break;
    default:
  }
  return newDirection;
}