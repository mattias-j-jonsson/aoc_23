import 'dart:io';


void main(List<String> args) {
  var file = File('inputs/11_input');
  List<String> input = file.readAsLinesSync();
  List<String> inputP2 = file.readAsLinesSync();


  expandInput(input);
  List<List<int>> galaxyCords = findGalaxyCoordinates(input);

  int result = calculateSumDistance(galaxyCords);

  print('Result part 1: $result');

  
  expandInputMega(inputP2);
  galaxyCords = findGalaxyCoordinatesMega(inputP2);

  result = calculateSumDistance(galaxyCords);

  print('Result part 2: $result');

}

void expandInput(List<String> input) {
  List<int> rowsToExpand = [];
  List<int> columnsToExpand = [];
  [rowsToExpand, columnsToExpand] = findExpandable(input);

  // for(var string in input) {
  //   print(string);
  // }
  // print('');
  int rowLength = input[0].length;
  for (var i = rowsToExpand.length-1; i >= 0; i--) {
    String newRow = '.'*rowLength;
    input.insert(rowsToExpand[i], newRow);
  }

  // for(var string in input) {
  //   print(string);
  // }
  // print('');

  for (var i = columnsToExpand.length-1; i >= 0; i--) {
    for (var j = 0; j < input.length; j++) {
      List<String> newRow = input[j].split('');
      newRow.insert(columnsToExpand[i], '.');
      input[j] = newRow.join();
    }
  }

  // for(var string in input) {
  //   print(string);
  // }
}

void expandInputMega(List<String> input) {
  List<int> rowsToExpand = [];
  List<int> columnsToExpand = [];
  [rowsToExpand, columnsToExpand] = findExpandable(input);

  for (var i = rowsToExpand.length-1; i >= 0; i--) {
    input[rowsToExpand[i]] = 'MEGAEXPANSION';
  }

  for (var i = columnsToExpand.length-1; i >= 0; i--) {
    for (var j = 0; j < input.length; j++) {
      if (input[j] != 'MEGAEXPANSION') {
        List<String> newRow = input[j].split('');
        newRow.replaceRange(columnsToExpand[i], columnsToExpand[i]+1, ['M']);
        input[j] = newRow.join();
      }
    }
  }

}

List<List<int>> findExpandable(List<String> input) {
  List<int> rowsToExpand = [];
  for (var i = 0; i < input.length; i++) {
    if(input[i].contains('#') == false) {
      rowsToExpand.add(i);
    }
  }

  int rowLength = input[0].length;
  List<int> columnsToExpand = List.generate(rowLength, (index) => index);
  for (var row in input) {
    int column = row.indexOf('#');
    while (column != -1) {
      columnsToExpand.remove(column);
      column = row.indexOf('#', column+1);
    }
  }
  return [rowsToExpand, columnsToExpand];
}

List<List<int>> findGalaxyCoordinates(List<String> input) {
  List<List<int>> output = [];
  for (var i = 0; i < input.length; i++) {
    for (var j = 0; j < input[i].length; j++) {
      if (input[i][j] == '#') {
        output.add([i, j]);
      }
    }
  }
  return output;
}

findGalaxyCoordinatesMega(List<String> input) {
  final M = 1000000;
  int megaRow = 0, megaCol = 0;

  List<List<int>> output = [];
  for (var i = 0; i < input.length; i++) {
    if(input[i] == 'MEGAEXPANSION') {
      megaRow++;
      continue;
    }
    for (var j = 0; j < input[i].length; j++) {
      if(input[i][j] == 'M') {
        megaCol++;
      } else if (input[i][j] == '#') {
        int xCord = (megaRow > 0 ? i+(M-1)*megaRow : i);
        int yCord = (megaCol > 0 ? j+(M-1)*megaCol: j);
        output.add([xCord, yCord]);
      }
    }
    megaCol = 0;
  }

  return output;
}

int calculateDistance(List<int> a, List<int> b) {
  int steps = 0;
  steps += (b[0] - a[0]).abs();
  steps += (b[1] - a[1]).abs();
  return steps;
}

int calculateSumDistance(List<List<int>> galaxyCords) {
  int result = 0;
  for (var i = 0; i < galaxyCords.length-1; i++) {
    for (var j = i+1; j < galaxyCords.length; j++) {
      result += calculateDistance(galaxyCords[i], galaxyCords[j]);
    }
  }
  return result;
}