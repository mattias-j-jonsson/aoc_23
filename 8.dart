import 'dart:collection';
import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  var file = File('inputs/8_input');
  List<String> input = file.readAsLinesSync();

  List<String> instructions = input.removeAt(0).split('');
  input.removeAt(0);

  Map<String, List<String>> travelMap = LinkedHashMap();
  


  for (var string in input) {
    String key = string.split('=')[0].trimRight();
    List<String> value = string.split('=')[1].trimLeft().split(',');
    value[0] = value[0].replaceAll('(', '');
    value[1] = value[1].replaceAll(')', '').trimLeft();
    travelMap.addAll(<String, List<String>>{key: value}); 
  }


  

  // int result = aaaTozzz(instructions, travelMap);

  // print(result);

  int resultPart2 = atoz(instructions, travelMap);
  
  print(resultPart2);
}


int aaaTozzz(List<String> instructions, Map<String, List<String>> tMap) {
  bool destFound = false;
  int steps = 0;
  String currentKey = 'AAA';
  while(!destFound) {
    for (var next in instructions) {
      steps++;
      if (next == 'L') {
        currentKey = tMap.putIfAbsent(currentKey, () => <String>[])[0];

      } else {
        currentKey = tMap.putIfAbsent(currentKey, () => <String>[])[1];
      }
      if (currentKey == 'ZZZ') {
        destFound = true;
        break;
      }
    }
  }
  
  return steps;
}

int atoz(List<String> instructions, Map<String, List<String>> tMap) {
  List<String> currentKeys = <String>[];
  List<String> keys = tMap.keys.toList();

  for (var i = 0; i < keys.length; i++) {
    if (keys[i].endsWith('A')) {
      currentKeys.add(keys[i]);
    }
  }

  print(currentKeys.length);

  List<int> resultList = <int>[];

  for (var key in currentKeys) {
    resultList.add(aTozHelper(instructions, tMap, key));
  }

  double currentLCM = resultList[0] + 0.0;

  for (var i = 0; i < resultList.length-1; i++) {
    int a = currentLCM.floor();
    int b = resultList[i+1];
    currentLCM = a*b/a.gcd(b);
  }

  print(currentLCM);
  return 0;
  // bool destsFound = false;
  // int steps = 0;
  // int foundZ = 0; //debug
  // int notFoundZ = 0; // debug
  
  // while(!destsFound) {
  //   for (var next in instructions) {
  //     steps++;
  //     for (var i = 0; i < currentKeys.length; i++) {
  //       if(next == 'L') {
  //         currentKeys[i] = tMap.putIfAbsent(currentKeys[i], () => <String>[])[0];
  //       } else {
  //         currentKeys[i] = tMap.putIfAbsent(currentKeys[i], () => <String>[])[1];
  //       }
  //     }
  //     destsFound = true;
  //     if(currentKeys[0].endsWith('Z') && currentKeys[1].endsWith('Z') && currentKeys[2].endsWith('Z'))
  //       print('object');
  //     for (var key in currentKeys) {
  //       if (!key.endsWith('Z')) {
  //         destsFound = false;
  //         notFoundZ++;
  //         break;
  //       } else {
  //         foundZ++;
  //       }
  //     }
  //     print('found = $foundZ');
  //     print('notfound = $notFoundZ');
  //     foundZ = 0;
  //     notFoundZ = 0;
  //     if(destsFound)
  //       break;
  //   }
    
  // }

  // print(currentKeys);

  // return steps;
}

int aTozHelper(List<String> instructions, Map<String, List<String>> tMap, String currentKey) {
  bool destFound = false;
  int steps = 0;
  while(!destFound) {
    for (var next in instructions) {
      steps++;
      if (next == 'L') {
        currentKey = tMap.putIfAbsent(currentKey, () => <String>[])[0];

      } else {
        currentKey = tMap.putIfAbsent(currentKey, () => <String>[])[1];
      }
      if (currentKey.endsWith('Z')) {
        destFound = true;
        break;
      }
    }
  }
  
  return steps;
}