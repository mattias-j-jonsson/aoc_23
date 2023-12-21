import 'dart:collection';
import 'dart:io';

class EdgeC {
  EdgeC(this.x, this.y, this.direction);
  
  int x;
  int y;
  String direction;

  @override
  String toString() {
    return '${x}, ${y}, ${direction}';
  }
}


void main(List<String> args) {
  var file = File('inputs/18_input');
  List<String> inputList = file.readAsLinesSync();

  List<List<String>> digOrder = [];
  List<String> colorCodes = [];
  
  for (var string in inputList) {
    List temp = string.split(' ');
    digOrder.add([temp[0], temp[1]]); // index 0 == direction, index 1 = no of steps
    colorCodes.add(temp[2]);
  }

  List<EdgeC> digPath = getDigPath(digOrder);

  int result = calcDigArea(digPath);

  print('Result part 1: $result');

  // List<EdgeC> digPathP2 = colorDigPath(colorCodes);

  // int resultP2 = calcDigArea(digPathP2);

  // print('Result part 2: $resultP2'); 
}


List<EdgeC> getDigPath(List digOrder) {
  int maxRight = 0;
  int maxDown = 0;
  int minRight = 0;
  int minDown = 0;

  List<EdgeC> output = [];

  var currentC = [0,0];
  output.add(EdgeC(currentC[0], currentC[1], 'start'));

  var Func = (List<int> h) {};
  EdgeC currentEdge = EdgeC(0, 0, 'null');
  for (var i = 0; i < digOrder.length; i++) {
    switch (digOrder[i][0]) {
      case 'L':
        Func = (List<int> cooordinate) {cooordinate[0]--; return;};
        break;
      case 'R':
        Func = (List<int> cooordinate) {cooordinate[0]++; return;};
        break;
      case 'U':
        Func = (List<int> cooordinate) {cooordinate[1]--; return;};
        break;
      case 'D':
        Func = (List<int> cooordinate) {cooordinate[1]++; return;};
        break;
    }
    for(var j = 0; j < int.parse(digOrder[i][1]); j++) {
      Func(currentC);
      currentEdge = EdgeC(currentC[0], currentC[1], digOrder[i][0]);
      output.add(currentEdge);
    }
    maxRight = currentC[0] > maxRight ? currentC[0] : maxRight;
    maxDown = currentC[1] > maxDown ? currentC[1] : maxDown;
    minRight = currentC[0] < minRight ? currentC[0] : minRight;
    minDown = currentC[1] < minDown ? currentC[1] : minDown;
    if(i < digOrder.length-1) {
      output.last.direction = '${output.last.direction}${digOrder[i+1][0]}';
    }
  }

  output[0].direction = '${output.last.direction}${output[1].direction}';


  output.add(EdgeC(minRight, minDown, 'min'));
  output.add(EdgeC(maxRight, maxDown, 'max'));

  return output;
}


// same as getDigPath, but for part 2
List<EdgeC> colorDigPath(List<String> colorCodes) {
  List<List<String>> digOrder = [];
  for (var code in colorCodes) {
    String direction = directionColorCode(code[code.length-2]);
    String steps = '${decNumberFromHex(code.substring(2, code.length-2))}';
    digOrder.add([direction, steps]);
  }

  print('digOrder:');
  printList(digOrder);
  return getDigPath(digOrder);
}


EdgeC isEdge(int x, int y, HashMap<String, EdgeC> edges) {
  String key = '$x,$y';
  return edges.putIfAbsent(key, () => EdgeC(-1, -1, 'null'));
}


HashMap<String, EdgeC> createMapFromPath(List<EdgeC> list) {
  HashMap<String, EdgeC> map = HashMap();

  for (var edge in list) {
    map.addAll({'${edge.x},${edge.y}': edge});
  }

  return map;
}


int calcDigArea(List<EdgeC> digPath) {
  int maxRight = digPath.last.x;
  int maxDown = digPath.last.y;
  int minRight = digPath[digPath.length-2].x;
  int minDown = digPath[digPath.length-2].y;

  HashMap<String, EdgeC> digPathMap = createMapFromPath(digPath);

  int interiorPoints = 0;
  for (var i = minDown; i < maxDown; i++) {
    String halfWall = '';
    int wallFound = 0;
    for (var j = minRight; j < maxRight; j++) {
      EdgeC current = isEdge(j,i,digPathMap);
      if(current.direction != 'null') {
        switch (current.direction) {
          case 'U':
            wallFound++;
            break;
          case 'LU':
            halfWall = 'LU';
            break;
          case 'UL':
            if(halfWall == 'LU') {
              halfWall = '';
              wallFound++;                    //
            }                                 // Not L or R 
            break;                            // U - just wall++
          case 'UR':                          // D - just wall++
            halfWall = 'UR';                  // UL - cannot be outer wall
            break;                            // LU - can be outer wall
          case 'RU':                          // UR
            if(halfWall == 'UR') {            // RU
              halfWall = '';                  // DL
              wallFound++;                    // LD
            }                                 // DR
            break;                            // RD
          case 'D':
            wallFound++;
            break;
          case 'LD':
            halfWall = 'LD';
            break;
          case 'DL':
            if(halfWall == 'LD') {
              halfWall = '';
              wallFound++;
            }
            break;
          case 'DR':
            halfWall = 'DR';
            break;
          case 'RD':
            if(halfWall == 'DR') {
              halfWall = '';
              wallFound++;
            }
            break;
          default:
        }
      } else {
        if(wallFound % 2 == 1) {
          interiorPoints++;
        }
      }
    }
  }

  return interiorPoints + digPath.length-3;
}


int decDigitFromHex(String input) {
  if(input == 'f' || input == 'F')
    return 15;
  else if(input == 'e' || input == 'e')
    return 14;
  else if(input == 'd' || input == 'D')
    return 13;
  else if(input == 'c' || input == 'C')
    return 12;
  else if(input == 'b' || input == 'B')
    return 11;
  else if(input == 'a' || input == 'A')
    return 10;
  
  return int.parse(input);
}


int decNumberFromHex(String input) {
  int powerOf16 = 1;
  int decNumber = 0;
  for (var i = input.length-1; i >= 0; i--) {
    decNumber += decDigitFromHex(input[i]) * powerOf16;
    powerOf16 *= 16;
  }

  return decNumber;
}


String directionColorCode(String input) {
  switch (input) {
    case '0':
      return 'R';
    case '1':
      return 'D';
    case '2':
      return 'L';
    case '3':
      return 'U';
    default:
      return 'null';
  }
}


void printList(List input) {
  for (var element in input) {
    print(element);
  }
}