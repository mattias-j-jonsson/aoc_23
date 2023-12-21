import 'dart:io';

void main(List<String> args) async {
  var file = File('inputs/15_input');
  String input = await file.readAsString();
  input = input.replaceAll('\n', '');
  List<String> inputList = input.split(',');
  int result = calcHash(inputList);


  print('Result part 1: $result');


  Map<int, List<List<String>>> map = createMap(input);
  print(map);

  int resultP2 = focusingPower(map);

  print('Result part 2: $resultP2');
}

Map<int, List<List<String>>> createMap(String input) {
  Map output = <int, List<List<String>>>{};
  int prevIndex = 0;
  int operationIndex = -1;
  String operation = '';
  String label = '';
  String focality = '';
  int key = -1;
  do {
    operationIndex = input.indexOf(RegExp('-|='), prevIndex);
    operation = input[operationIndex];
    label = input.substring(prevIndex, operationIndex);
    focality = input[operationIndex+1];
    key = calcHashSingle(label);
    
    if(operation == '=') {
      prevIndex = operationIndex + 3;
      if(output.containsKey(key)) {
        bool labelExist = false;
        for (List<String> value in output.putIfAbsent(key, () => <List<String>>[])){
          if (value[0] == label) {
            value[1] = focality;
            labelExist = true;
          }
        }
        if(!labelExist) {
          List<List<String>> value = output.putIfAbsent(key, () => <List<String>>[]);
          value.add(<String>[label, focality]);
        }
      } else {
        output.addAll(<int, List<List<String>>>{key: [<String>[label, focality]]});
      }
    } else {
      prevIndex = operationIndex + 2;
      if (output.containsKey(key)) {
        List<List<String>> values = output.putIfAbsent(key, () => <List<String>>[]);
        for (int i = 0; i < values.length; i++) {
          if (values[i][0] == label) {
            values.removeAt(i);
            break;
          }
        }
      } else {
        continue;
      }
    }
  } while (prevIndex < input.length);

  return output as Map<int, List<List<String>>>;
}

int focusingPower(Map<int, List<List<String>>> input) {
  print(input.length);
  int result = 0;

  input.forEach((key, value) {
    if (!value.isEmpty) {
      int temp = 0;
      for (var i = 0; i < value.length; i++) {
        temp += (i+1)*int.parse(value[i][1]);
      }
      result += (key+1)*temp;
    }
  });

  return result;
}

int calcHash(List<String> input) {
  int result = 0;
  for (var string in input) {
    List<int> temp = string.codeUnits;  
    int tempResult = 0;
    for (var element in temp) {
      tempResult += element;
      tempResult *= 17;
      tempResult %= 256;
    }
    result += tempResult;
    
  }

  return result;
}

int calcHashSingle(String input) {
  List<int> codes = input.codeUnits;
  int result = 0;
  for (var code in codes) {
    result+=code;
    result*=17;
    result%=256;
  }
  return result;
}