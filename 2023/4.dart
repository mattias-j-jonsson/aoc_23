import 'dart:io';
import 'dart:math';

void main(List<String> args) async {
  var input = File('inputs/4_input');

  List<String> output = await input.readAsLines();


  List<String> mainSplit;
  List<String> winningSplit;
  List<int?> winningList;
  List<int?> lotteryList;

  List<int> totalMatches = List<int>.filled(output.length, 0);
  List<int> totalTickets = List<int>.filled(output.length, 1);

  int numberOfMatches = 0;
  int result = 0;

  for(var i = 0; i < output.length; i++) {
    String card = output[i];
    mainSplit = card.split('|');
    
    winningSplit = mainSplit[0].split(':')[1].split(' ');
    winningList = winningSplit.map((e) {
      try {
        return int.parse(e);
      } catch (err) {
        // do nothing
      }
    },).toList();
    winningList.removeWhere((element) => element == null);

    lotteryList = mainSplit[1].split(' ').map((e) {
      try {
        return int.parse(e);
      } catch (err) {
        // do nothing
      }
    },).toList();
    lotteryList.removeWhere((element) => element == null);


    for(final element in winningList) {
      if(lotteryList.contains(element))
        numberOfMatches++;
    }

    totalMatches[i] = numberOfMatches;

    result += pow(2, numberOfMatches-1).toInt();
    numberOfMatches = 0;
  }
  print('Result part 1: $result');


  for (var i = 0; i < output.length; i++) {
    for (var j = 0; j < totalTickets[i]; j++) {
      for (var k = 0; k < totalMatches[i]; k++) {
        totalTickets[i+k+1]++;
      }
    }
  }
  
  int result2 = 0;
  for (var element in totalTickets) {
    result2 += element;
  }

  print('Result part 2: $result2');
}