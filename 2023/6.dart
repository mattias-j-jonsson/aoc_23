import 'dart:math';
import 'dart:io';

int getValue(int T, int R) {
  double a = T/2;
  double b = sqrt(T*T-4*R)/2;
  double x1 = a-b;
  double x2 = a+b;

  int min = (x1+1).floor();
  int max = (x2-1).ceil();

  return max-min+1;
}

void main(List<String> args) async {
  var inputFile = File('inputs/6_input');
  List<String> input = await inputFile.readAsLines();
  
  List<String> timeLine = input[0].split(':')[1].split(' ');
  List<String> distanceLine = input[1].split(':')[1].split(' ');
  timeLine.removeWhere((element) => element == '');
  distanceLine.removeWhere((element) => element == '');

  List<int> raceTime = timeLine.map((e) => int.parse(e)).toList();
  List<int> raceDistance = distanceLine.map((e) => int.parse(e)).toList();


  int result = 1;
  for (var i = 0; i < raceDistance.length; i++) {
    result *= getValue(raceTime[i], raceDistance[i]);
  }

  print('Result part 1: $result');

  input[0] = input[0].split(':')[1];
  input[1] = input[1].split(':')[1];
  
  input[0] = input[0].replaceAll(' ', '');
  input[1] = input[1].replaceAll(' ', '');
  int time = int.parse(input[0]);
  int distance = int.parse(input[1]);

  int result2 = getValue(time, distance);
  print('Result part 2: $result2');
}