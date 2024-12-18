import 'dart:io';


void main(List<String> args) {
  var file  = File('inputs/12_test');
  List<String> input = file.readAsLinesSync();

  findPossibilities(input[0]);
}

int findPossibilities(String input) {
  var returnList = splitInput(input);
  String string = returnList[0] as String;
  List<int> answer = returnList[1] as List<int>;
  List<int> questionMarks = getQuestionIndex(string);
  int length = questionMarks.length;
  var computeStructure = List.generate(length, (index) => List.generate(length-index, (i) => false));
  print(computeStructure);
  return 0;
}


bool isPossiblyLegal(String input, List<int> answer) {
  
  
  return false;
}

List<int> getQuestionIndex(String input) {
  List<int> output = [];

  for (var i = 0; i < input.length; i++) {
    if(input[i] == '?')
      output.add(i);
  }

  return output;
}

List<Object> splitInput(String input) {
  List<String> inputSplit = input.split(' ');
  List<int> intList = inputSplit[1].split(',').map((e) => int.parse(e)).toList();

  return [inputSplit[0], intList];
}
