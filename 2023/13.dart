import 'dart:io';

void main(List<String> args) {
  var file = File('inputs/13_input');
  List<String> input =  file.readAsLinesSync();
  
  int result = 0;
  var unit = <String>[];
  List<List<List<String>>> inputP2 = [];
  Map<int, List<Object>> metaData = {};
  int inputCounter = 0;
  for(var i = 0; i < input.length; i++) {
    if (!input[i].isEmpty) {
      unit.add(input[i]);
    } 
    if (input[i].isEmpty || i == input.length-1) {
      List<List<String>> unitList = unit.map((e) => e.split('')).toList();
      var resultList = calcSymmetryPoint(unitList);
      result += resultList[0] as int;
      inputP2.add(unitList);
      metaData.addAll({inputCounter: resultList[1] as List<Object>});
      inputCounter++;
      unit.clear();
    }
  }
  print('Result part 1: $result');

  print('');
  // print(metaData);
  int resultPart2 = 0;
  inputCounter = 0;
  bool newSymmetryFound = false;
  for (var input in inputP2) {
    var oldValue = metaData.putIfAbsent(inputCounter, () => []);
    for (var i = 0; i < input.length; i++) {
      for (var j = 0; j < input[i].length; j++) {
        String oldChar = '';
        if(input[i][j] == '.'){
          input[i][j] = '#';
          oldChar = '.';
        } else {
          input[i][j] = '.';
          oldChar = '#';
        }
        var resultList = calcSymmetryPoint(input, oldValues: oldValue);
        var newValue = resultList[1] as List<Object>;
        if((oldValue[0] != newValue[0] || oldValue[1] != newValue[1]) && newValue[1] != -1) {
          resultPart2 += resultList[0] as int;
          newSymmetryFound = true;
          break;
        } else {
          input[i][j] = oldChar;
        }
      }
      if (newSymmetryFound) {
        break;
      }
    }
    if(!newSymmetryFound) {
      resultPart2 += oldValue[2] as int;
    }
    inputCounter++;
    newSymmetryFound = false;
  }

  print('Result part 2: $resultPart2');

}

List<Object> calcSymmetryPoint(List<List<String>> input, {List<Object>? oldValues}) {
  var resultList = isSymmetricList(input, oldData: oldValues);
  bool symmetryFound = resultList[0] as bool;
  int result = (resultList[1] as int) * 100;
  String status = 'row';
  
  List<List<String>> columnsToRow = List.generate(input[0].length, (index) => []);
  for (var i = 0; i < input.length; i++) {
    for (var j = 0; j < columnsToRow.length; j++) {
      columnsToRow[j].add(input[i][j]);
    }
  }

  if(!symmetryFound) {
    resultList = isSymmetricList(columnsToRow, rows: false, oldData: oldValues);
    symmetryFound = resultList[0] as bool;
    result = resultList[1] as int;
    status = 'column';
  }

  List<Object> metaInfo = [status, resultList[2], result];

  return [result, metaInfo];
}

List<Object> isSymmetric(List<String> input) {
  bool symmetryFound = false;
  int result = 0;
  for (var i = 0; i < input.length-1; i++) {
    if (input[i] == input[i+1]) {
      symmetryFound = checkSymmetry(input, i);
    }
    if (symmetryFound) {
      result = 1+i;
      break;
    }
  }
  
  return [symmetryFound, result];
}

bool checkSymmetry(List<String> input, int index) {
  int limit = index < input.length-index-2 ? index : input.length-index-2;

  for (var i = 0; i < limit; i++) {
    if(input[index-i-1] != input[index+i+2])
      return false;
  }

  return true;
}

List<Object> isSymmetricList(List<List<String>> input, {bool rows = true, List<Object>? oldData}) {
  bool symmetryFound = false;
  int result = 0;
  for (var i = 0; i < input.length-1; i++) {
    bool rowsEqual = true;
    for (var j = 0; j < input[i].length; j++) {
      if(input[i][j] != input[i+1][j]) {
        rowsEqual = false;
        break;
      }
    }
    if(oldData != null && oldData[0] == (rows ? 'row':'column') && oldData[1] == i)
      continue;
    if (rowsEqual) {
      symmetryFound = checkSymmetryList(input, i);
    }
    if (symmetryFound) {
      result = 1+i;
      break;
    }
  }
  
  return [symmetryFound, result, result-1];
}

bool checkSymmetryList(List<List<String>> input, int index) {
  int limit = index < input.length-index-2 ? index : input.length-index-2;

  for (var i = 0; i < limit; i++) {
    for (var j = 0; j < input[0].length; j++) {
      if(input[index-i-1][j] != input[index+i+2][j])
        return false;
    }
  }

  
  return true;
}

void printInput(List<List<String>> input) {
  var toPrint = input.map((e) => e.join()).toList();
  print('');
  for (var element in toPrint) {
    print(element);
  }
  print('');
}