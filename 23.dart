import 'dart:collection';
import 'dart:io';


class Coordinate {
  Coordinate(this.x, this.y, this.value);
  int x;
  int y;
  String value;

  @override
  bool operator==(Object other){
    other = other as Coordinate;
    return x == 
    other.x && y == other.y;
  }

  @override
  int get hashCode => x.hashCode + y.hashCode + value.hashCode;
}

class Path {
  Path(this.prevC, this.nextC, this.stepsTaken);

  Coordinate prevC;
  Coordinate nextC;
  int stepsTaken;

  @override
  bool operator==(Object other) {
    other = other as Path;
    return prevC == other.prevC && nextC == other.nextC && stepsTaken == other.stepsTaken;
  }

  @override
  int get hashCode => prevC.hashCode + nextC.hashCode + stepsTaken.hashCode;
}

class MemoryPath{
  MemoryPath(this.path, this.visited);

  Path path;
  List<List<bool>> visited;
}


void main(List<String> args) {
  var file = File('inputs/23_test');
  List<List<String>> input = file.readAsLinesSync().map((e) => e.split('')).toList();

  int result = findMaxPath(input);

  print('Result part 1: $result');
}


int findMaxPath(List<List<String>> input) {
  int currentMax = 0;

  // code to determine start and end position
  int indexOfStart = 0;
  int indexOfEnd = 0;
  for (var i = 0; i < input[0].length; i++) {
    if(input[0][i] != '#') {
      indexOfStart = i;
      break;
    }
  }
  for (var i = 0; i < input[input.length-1].length; i++) {
    if (input[input.length-1][i] != '#') {
      indexOfEnd = i;
      break;
    }
  }

  Coordinate endC = Coordinate(indexOfEnd, input.length-1, '.');
  // the stack of path's that has been discovered but not traversed. Adds the path beginning in startingposition
  List<MemoryPath> pathStack = [];
  Path firstPath = Path(Coordinate(indexOfStart,0, '.'), Coordinate(indexOfStart,0, '.'), 0);
  pathStack.add(MemoryPath(firstPath, []));

  // a stack with paths already poppeed from pathStack, to make the program not get stuck, hopefully
  HashMap<Path, bool> doneStack = HashMap();


  // newPathLength is the value of traversed path in findPath
  int newPathLength = 0;
  MemoryPath currentPath;
  Path copyPath;

  while (pathStack.isNotEmpty) {
    currentPath = pathStack.removeLast();
    copyPath = Path(currentPath.path.prevC, currentPath.path.nextC, currentPath.path.stepsTaken);

    if (doneStack.containsKey(currentPath)) {
      if (doneStack[currentPath] == true) {
        continue;
      }
    } else {
      doneStack.addAll({copyPath: false});
    }

    newPathLength = findPath(currentPath, pathStack, doneStack, input, endC);
    doneStack[copyPath] = true;

    currentMax = newPathLength > currentMax ? newPathLength : currentMax;
    print('latest result: $newPathLength');
  }

  return currentMax;
}


int findPath(MemoryPath path, List<MemoryPath> pathStack, HashMap<Path, bool> doneStack, List<List<String>> grid, Coordinate endC) {
  if (path.visited.isEmpty) {
    path.visited = List.generate(grid[0].length, (index) => List.generate(grid.length, (i)=>false));
    path.visited[path.path.prevC.x][path.path.prevC.y] = true;
    
  }

  if (path.path.prevC == path.path.nextC) { // true for first path: the one from starting position
    path.path.nextC = findNextPosNoSlip(path, pathStack, doneStack, grid, endC);
  }

  path.visited[path.path.nextC.x][path.path.nextC.y] = true;
  
  Coordinate nextPos = path.path.nextC;
  Coordinate falsePos = Coordinate(-1, -1, 'null');

  while (path.path.prevC != path.path.nextC) {
    nextPos = findNextPosNoSlip(path, pathStack, doneStack, grid, endC);
    if (nextPos == falsePos) {
      return -1;
    }
    path.visited[nextPos.x][nextPos.y] = true;
    path.path.stepsTaken++;
    path.path.prevC = path.path.nextC;
    path.path.nextC = nextPos;
  }

  return path.path.stepsTaken;
}


// function that determines and returns next coordinate on path. Also has responsibility to add any diverging paths that is NOT taken to the pathStack.
Coordinate findNextPos(Path path, List<Path> pathStack, List<List<String>> grid, Coordinate endC) {

  Coordinate currentPos = path.nextC;
  if(path.prevC == path.nextC) { // hardcoded that first move is down
    return Coordinate(currentPos.x, currentPos.y+1, grid[currentPos.y+1][currentPos.x]);
  }
  if (currentPos == endC) {
    return currentPos;
  }
  Coordinate? leftPos, rightPos, upPos, downPos;

  if ('^v><'.contains(currentPos.value)) {
    switch (currentPos.value) {
      case '^':
        return Coordinate(currentPos.x, currentPos.y-1, grid[currentPos.y-1][currentPos.x]);
      case 'v':
        return Coordinate(currentPos.x, currentPos.y+1, grid[currentPos.y+1][currentPos.x]);
      case '>':
        return Coordinate(currentPos.x+1, currentPos.y, grid[currentPos.y][currentPos.x+1]);
      case '<':
        return Coordinate(currentPos.x-1, currentPos.y, grid[currentPos.y][currentPos.x-1]);
      default:
    }
  } else {
    Coordinate falsePos = Coordinate(-1, -1, 'null');
    leftPos = currentPos.x > 0 ? Coordinate(currentPos.x-1, currentPos.y, grid[currentPos.y][currentPos.x-1]) : falsePos;
    rightPos = currentPos.x < grid[0].length-1 ? Coordinate(currentPos.x+1, currentPos.y, grid[currentPos.y][currentPos.x+1]) : falsePos;
    upPos = currentPos.y > 0 ? Coordinate(currentPos.x, currentPos.y-1, grid[currentPos.y-1][currentPos.x]) : falsePos;
    downPos = currentPos.y < grid.length-1 ? Coordinate(currentPos.x, currentPos.y+1, grid[currentPos.y+1][currentPos.x]) : falsePos;
  }

  List possibilities = [leftPos, rightPos, upPos, downPos];
  Coordinate? nextPos = (leftPos == path.prevC || leftPos!.value == '#' || isInvalidSlope(leftPos, path) ? (rightPos == path.prevC || rightPos!.value == '#' || isInvalidSlope(rightPos, path) ? (upPos == path.prevC || upPos!.value == '#' || isInvalidSlope(upPos, path) ? downPos : upPos) : rightPos) : leftPos);

  for (var i = 0; i < possibilities.length; i++) {
    if(possibilities[i] != nextPos && possibilities[i] != path.prevC && 'null#'.contains(possibilities[i].value) == false && !isInvalidSlope(possibilities[i], path)) {
      pathStack.add(Path(path.nextC, possibilities[i], path.stepsTaken+1)); // stepsTaken+1 was important
    }
  }

  return nextPos!;
}


Coordinate findNextPosNoSlip(MemoryPath path, List<MemoryPath> pathStack, HashMap<Path, bool> doneStack, List<List<String>> grid, Coordinate endC) {
  Coordinate currentPos = path.path.nextC;
  if (currentPos == endC) {
    return currentPos;
  }
  if(path.path.prevC == path.path.nextC) { // hardcoded that first move is down
    return Coordinate(currentPos.x, currentPos.y+1, grid[currentPos.y+1][currentPos.x]);
  }
  Coordinate? leftPos, rightPos, upPos, downPos;

  Coordinate falsePos = Coordinate(-1, -1, 'null');
  leftPos = currentPos.x > 0 ? Coordinate(currentPos.x-1, currentPos.y, grid[currentPos.y][currentPos.x-1]) : falsePos;
  rightPos = currentPos.x < grid[0].length-1 ? Coordinate(currentPos.x+1, currentPos.y, grid[currentPos.y][currentPos.x+1]) : falsePos;
  upPos = currentPos.y > 0 ? Coordinate(currentPos.x, currentPos.y-1, grid[currentPos.y-1][currentPos.x]) : falsePos;
  downPos = currentPos.y < grid.length-1 ? Coordinate(currentPos.x, currentPos.y+1, grid[currentPos.y+1][currentPos.x]) : falsePos;

  List possibilities = [leftPos, rightPos, upPos, downPos];
  Coordinate? nextPos = (leftPos == falsePos || path.visited[leftPos.x][leftPos.y]|| leftPos.value == '#' ? (rightPos == falsePos || path.visited[rightPos.x][rightPos.y] || rightPos.value == '#'? (upPos == falsePos || path.visited[upPos.x][upPos.y] || upPos.value == '#' ? downPos : upPos) : rightPos) : leftPos);

  if(nextPos == falsePos)
    return falsePos;

  for (var i = 0; i < possibilities.length; i++) {
    if(possibilities[i] != nextPos && possibilities[i] != path.path.prevC && 'null#'.contains(possibilities[i].value) == false && path.visited[possibilities[i].x][possibilities[i].y] == false) {
      Path newPath = Path(path.path.nextC, possibilities[i], path.path.stepsTaken+1);
      Path newDonePath = Path(path.path.nextC, possibilities[i], path.path.stepsTaken+1);
      if (doneStack.containsKey(newPath) == false) {        
        pathStack.add(MemoryPath(newPath, visitedCopy(path.visited))); // stepsTaken+1 was important
        doneStack.addAll({newDonePath: false});
      }
      
    }
  }

  if (path.visited[nextPos.x][nextPos.y]) {
    return falsePos;
  }

  return nextPos;
}


List<List<bool>> visitedCopy (List<List<bool>> toCopy) {
  List<List<bool>> output = [];
  for (var element in toCopy) {
    output.add(List.from(element));
  }
  return output;
}

void printList(List list) {
  for (var element in list) {
    print(element);
  }
}

bool isInvalidSlope(Coordinate c, Path p) {
  if(c.value == '^' && c.y - p.nextC.y == 1) {
    return true;
  } else if (c.value == 'v' && c.y-p.nextC.y == -1) {
    return true;
  } else if (c.value == '<' && c.x-p.nextC.x == 1) {
    return true;
  } else if (c.value == '>' && c.x-p.nextC.x == -1) {
    return true;
  }
  return false;
}