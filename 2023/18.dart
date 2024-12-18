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

class Edge implements Comparable{
  Edge(this.column, this.direction);
  int column;
  String direction;
  
  @override
  String toString() {
    return '${column}, ${direction}';
  }

  @override
  int compareTo(other) {
    return column - other.column as int;
  }
}


void main(List<String> args) async {
  var file = File('inputs/18_test');
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


  // List<List<String>> digOrderP2 = colorDigOrder(colorCodes);

  List<HashMap> temp = getWallPositions(digOrder);

  print(temp[0].putIfAbsent('maxDown', ()=>-777));

  int resultP2 = resultFromWallPostions(temp);
  print('result part 2: $resultP2');

  // List<EdgeC> digPathP2 = getDigPath(digOrderP2);

  // int resultP2 = await calcDigArea(digPathP2);

  // print('Result part 2: $resultP2'); 
}


List<EdgeC> getDigPath(List digOrder) {
  print('Entering getDigPath.');
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

  print('minRight: $minRight, maxRight: $maxRight, minDown: $minDown, maxDown: $maxDown');
  print('Exiting getDigPath.');
  return output;
}


// same as getDigPath, but for part 2
List<List<String>> colorDigOrder(List<String> colorCodes) {
  List<List<String>> digOrder = [];
  for (var code in colorCodes) {
    String direction = directionColorCode(code[code.length-2]);
    String steps = '${decNumberFromHex(code.substring(2, code.length-2))}';
    digOrder.add([direction, steps]);
  }

  return digOrder;
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

  final maxRight = digPath.last.x;
  final maxDown = digPath.last.y;
  final minRight = digPath[digPath.length-2].x;
  final minDown = digPath[digPath.length-2].y;
  // double onepercent = maxDown/100; // DEBUG

  HashMap<String, EdgeC> digPathMap = createMapFromPath(digPath);

  print('created HM');
  int interiorPoints = 0;
  for (var i = minDown; i < maxDown; i++) {
    interiorPoints += calcDigAreaRow(minRight, maxRight, i, digPathMap);
    // print('${(i/onepercent).toStringAsFixed(3)}% DONE'); // DEBUG
  }


  return interiorPoints + digPath.length-3;
}


int decDigitFromHex(String input) {
  if(input == 'f' || input == 'F')
    return 15;
  else if(input == 'e' || input == 'E')
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


int calcDigAreaRow(int minRight, int maxRight, int i, HashMap<String, EdgeC> digPathMap) {
  String halfWall = '';
  int wallFound = 0;
  int interiorPoints = 0;
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
  return interiorPoints;
}


List<HashMap> getWallPositions(List digOrder) {
  int maxRight = 0;
  int maxDown = 0;
  int minRight = 0;
  int minDown = 0;


  String currentDirection = digOrder[digOrder.length-1][0];
  HashMap<int, List<Edge>> wallPositions = HashMap();
  wallPositions.addAll({0: [Edge(0, '$currentDirection${digOrder[0][0]}')]});
  var currentC = [0,0];
  var Func = (List<int> h) {};
  List<Edge> tempList = [];
  Edge tempEdge = Edge(-1, 'null');

  double onepercent = digOrder.length/100;
  for (var i = 0; i < digOrder.length; i++) {
    print('${(i/onepercent).toStringAsFixed(3)}%');
    currentDirection = digOrder[i][0];
    switch (currentDirection) {
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
      tempList = wallPositions.putIfAbsent(currentC[1], () => []);
      if(tempList.isEmpty)
        wallPositions.addAll({currentC[1]: [Edge(currentC[0], currentDirection)]});
      else
        tempList.add(Edge(currentC[0], currentDirection));
    }

    maxRight = currentC[0] > maxRight ? currentC[0] : maxRight;
    maxDown = currentC[1] > maxDown ? currentC[1] : maxDown;
    minRight = currentC[0] < minRight ? currentC[0] : minRight;
    minDown = currentC[1] < minDown ? currentC[1] : minDown;

    if(i < digOrder.length-1) {
      tempEdge = wallPositions.putIfAbsent(currentC[1], () => []).last;
      tempEdge.direction = '${tempEdge.direction}${digOrder[i+1][0]}';
    }
  }

  wallPositions.forEach((key, value) {value.sort();});
  HashMap<String, int> limitsOfPath = HashMap();
  limitsOfPath.addAll({'minRight':minRight, 'minDown':minDown, 'maxRight':maxRight, 'maxDown':maxDown});



  print('minRight: $minRight, maxRight: $maxRight, minDown: $minDown, maxDown: $maxDown');
  print('Exiting getDigPath.');
  return [limitsOfPath, wallPositions];
}

int resultFromWallPostions(List<HashMap> input) {
  HashMap minMax = input[0];
  HashMap wallPositions = input[1];

  int minDown = minMax.putIfAbsent('minDown', () => 0);
  int maxDown = minMax.putIfAbsent('maxDown', () => 0);
  print('$minDown, $maxDown');

  String halfWall = '';
  int wallFound = 0;
  int totalInteriorPoints = 0;
  int columnWithin = 0;
  bool interiorFound = false;
  Edge currentEdge;
  List tempList;
  for (var i = minDown; i <= maxDown; i++) {
    tempList = wallPositions.putIfAbsent(i, () => <Edge>[]);
    if (tempList.isEmpty) {
      continue;
    } else {
      for (var j = 0; j < tempList.length; j++) {
        currentEdge = tempList[j];
        switch (currentEdge.direction) {
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
        if(wallFound % 2 == 1) {
          columnWithin = currentEdge.column;
          interiorFound = true;
        } else {
          if (interiorFound) {
            totalInteriorPoints += currentEdge.column-columnWithin-1;
            interiorFound = false;
          }
        }
      }
    }
  }
  int wallPosLength = 0;
  wallPositions.forEach((key, value) {wallPosLength += value.length as int;});
  return totalInteriorPoints+wallPosLength;
}