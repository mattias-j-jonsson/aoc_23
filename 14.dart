import 'dart:io';


void main(List<String> args) {
  var file = File('inputs/14_input');
  var inputString = file.readAsStringSync();
  List<List<String>> inputList = inputString.split('\n').map((e) => e.split('')).toList();
  inputList.removeLast();

  var xc = <(int, int)>[];

  List<List<int>> roundIndex;
  List<List<int>> squareIndex;
  [roundIndex, squareIndex] = retrieveRoundAndSquareIndex(inputList);

  var tiltedList = roundIndexIfTilted(roundIndex, squareIndex);
  int result = calculateWeight(tiltedList, inputList[0].length);

  print('Result part 1: $result');


  // PART 2

  List<List<int>> roundTiltedIndex = [];
  List<List<String>> modInput = recreateInput(inputList.length, inputList[0].length, roundIndex, squareIndex);
  int turns = 4;
  int completeRotations = 118;
  int rotations = completeRotations*turns;
  for(var i = 0; i < 3; i++){
    modInput = inputRotated(modInput);
  }

  // to shorten time
  List<int> indexForCycle = [];
  List<List<String>> storedInput = [];
  int startOfCyclicBehaviour = 446;

  for (var i = 0; i < rotations; i++) {
    if(i == startOfCyclicBehaviour) {
      storedInput = inputRotated(modInput);
      print('STORING');
    }
    modInput = inputRotated(modInput);
    if (compareInput(modInput, storedInput)) {
      indexForCycle.add(i);
    } else {
    }
    [roundIndex, squareIndex] = retrieveRoundAndSquareIndex(modInput);
    roundTiltedIndex = roundIndexIfTilted(roundIndex, squareIndex);
    modInput = recreateInput(modInput.length, modInput[0].length, roundTiltedIndex, squareIndex);
  }

  modInput = inputRotated(modInput);
  [roundIndex, squareIndex] = retrieveRoundAndSquareIndex(modInput);

  int sizeOfCycle = 1;
  if(indexForCycle.length > 1) { // Relates to index i; turns, not complete rotations
    sizeOfCycle = indexForCycle[1]-indexForCycle[0];
  }
  int turnsForTruth = (4*1000000000 - startOfCyclicBehaviour) % sizeOfCycle;
  print('Preliminary number of complete turns needed: ${(startOfCyclicBehaviour+turnsForTruth) / 4}');

  int resultP2 = calculateWeight(roundIndex, modInput[0].length);

  print('Result part 2: $resultP2');
  
}

List<List<List<int>>> retrieveRoundAndSquareIndex(List<List<String>> input) {
  List<List<int>> roundIndex = List.generate(input[0].length, (index) => <int>[]);
  List<List<int>> squareIndex = List.generate(input[0].length, (index) => <int>[]);

  for (var i = 0; i < input.length; i++) {
    for (var j = 0; j < input[i].length; j++) {
      if (input[i][j] == '.') {
        continue;
      } else if(input[i][j] == 'O') {
        roundIndex[j].add(i);
      } else {
        squareIndex[j].add(i);
      }
    }
  }
  return [roundIndex, squareIndex];
}

List<List<int>> roundIndexIfTilted(List<List<int>> roundIndex, List<List<int>> squareIndex) {
  List<List<int>> tiltedList = List.generate(roundIndex.length, (index) => <int>[]);
  for (var i = 0; i < roundIndex.length; i++) {
    if(roundIndex[i].isEmpty) {
      continue;
    } else if(squareIndex[i].isEmpty) {
      for(int j = 0; j < roundIndex[i].length; j++) {
        tiltedList[i].add(j);
      }
      continue;
    }
    int currentTop = 0;
    int rCounter = 0;
    for(int k = 0; k < squareIndex[i].length; k++) {
      if(rCounter == roundIndex[i].length) {
        break;
      }

      while(roundIndex[i][rCounter] < squareIndex[i][k]) {
        tiltedList[i].add(currentTop);
        currentTop++;
        rCounter++;
        if(rCounter == roundIndex[i].length) {
          break;
        }
      }
      currentTop = squareIndex[i][k]+1;
    }
    for(int k = rCounter; k < roundIndex[i].length; k++) {
      tiltedList[i].add(currentTop);
      currentTop++;
    }
  }

  return tiltedList;
}

int calculateWeight(List<List<int>> input, int rows) {
  int result = 0;
  for (var i = 0; i < input.length; i++) {
    for (var j = 0; j < input[i].length; j++) {
      result += rows-input[i][j];
    }
  }
  
  return result;
}

List<List<String>> recreateInput(int rows, int columns, List<List<int>> roundIndex, List<List<int>> squareIndex) {
  List<List<String>> newInput = List.generate(rows, (index) => List.generate(columns, (i) => '.'));

  for(int i = 0; i < roundIndex.length; i++) {
    for(int j = 0; j < roundIndex[i].length; j++) {
      newInput[roundIndex[i][j]][i] = 'O';
    }
    for(int j = 0; j < squareIndex[i].length; j++) {
      newInput[squareIndex[i][j]][i] = '#';
    }
  }
  
  return newInput;
}

List<List<String>> inputRotated(List<List<String>> input) {
  List<List<String>> output = List.generate(input[0].length, (index) => []);

  for (var i = input[0].length-1; i >= 0; i--) {
    for(var j = input.length-1; j >= 0; j--) {
      output[i].add(input[j][i]);
    }
  }

  return output;
}

bool compareInput(List<List<String>> currentInput, List<List<String>> storedInput) {
  if(storedInput.isEmpty) {
    return false;
  }

  bool result = true;
  result = true;
  for (var i = 0; i < currentInput.length; i++) {
    for (var j = 0; j < currentInput[i].length; j++) {
      if (currentInput[i][j] != storedInput[i][j]) {
        result = false;
        break;
      }
    }
    if(!result)
      break;
  }

  return result;
}

void printList(var input) {
  for (var element in input) {
    print(element);
  }
}

int size(var list) {
  return list.fold(0, (previousValue, element) => previousValue+element.length);
}
