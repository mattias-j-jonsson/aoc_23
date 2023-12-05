import 'dart:io';

class Range implements Comparable<Range> {
  Range(int this.start, int this.end, int this.conversion) : length = start-end +1 {}
  int start;
  int end;
  int conversion;
  int length;

  bool isInRange(int input) {
    return input >= start && input <= end;
  }

  int convertInput(int input) {
    return input+conversion;
  }

  @override
  int compareTo(Range other) {
    return start - other.start;
  }
}

Range createRange(String input, {topToBottom = true}) {
  List<int> inputList = input.split(' ').map((e) => int.parse(e)).toList();
  int start, end, conversion;
  if (topToBottom) {
    start = inputList[1];
    end = inputList[1] - 1 + inputList[2];
    conversion = inputList[0] - inputList[1];
    return Range(start, end, conversion);
  } else {
    start = inputList[0];
    end = inputList[0]-1 + inputList[2];
    conversion = inputList[1] - inputList[0];
    return Range(start, end, conversion);
  }
}

int findNextStep(int input, List<Range> ranges) {
  for(final range in ranges) {
    if(range.isInRange(input)){
      return range.convertInput(input);
    }
  }
  return input;
}




void main(List<String> args) async {
  var inputFile = File('inputs/5_input');
  List<String> input = await inputFile.readAsLines(); 
  
  
  List<String> seedString = input[0].split(':')[1].split(' ');
  List<int?> seeds = seedString.map((e) {try{return int.parse(e);}catch(err) {}}).toList();
  seeds.removeWhere((element) => element == null);


  input.removeAt(0);

  Iterator<String> iter = input.iterator;

  List<Range> seedToSoilMap = <Range>[];
  List<Range> soilToFertilizerMap = <Range>[];
  List<Range> fertilizerToWaterMap = <Range>[];
  List<Range> waterToLightMap = <Range>[];
  List<Range> lightToTempMap = <Range>[];
  List<Range> tempToHumidityMap = <Range>[];
  List<Range> humidityToLocationMap = <Range>[];

  List<Range> soilToSeedMap = <Range>[];
  List<Range> fertilizerToSoilMap = <Range>[];
  List<Range> waterToFertilizerMap = <Range>[];
  List<Range> lightToWaterMap = <Range>[];
  List<Range> tempToLightMap = <Range>[];
  List<Range> humidityToTempMap = <Range>[];
  List<Range> locationToHumidityMap = <Range>[];

  while(iter.moveNext()) {
    if(iter.current.isEmpty)
      iter.moveNext();
    
    if(iter.current.contains('seed-to')) {
      iter.moveNext();
      while (!iter.current.isEmpty) {
        seedToSoilMap.add(createRange(iter.current));
        soilToSeedMap.add(createRange(iter.current, topToBottom: false));
        iter.moveNext();
      }
    }
    if(iter.current.contains('soil-to')) {
      iter.moveNext();
      while (!iter.current.isEmpty) {
        soilToFertilizerMap.add(createRange(iter.current));
        fertilizerToSoilMap.add(createRange(iter.current, topToBottom: false));
        iter.moveNext();
      }
    }
    if(iter.current.contains('fertilizer-to')) {
      iter.moveNext();
      while (!iter.current.isEmpty) {
        fertilizerToWaterMap.add(createRange(iter.current));
        waterToFertilizerMap.add(createRange(iter.current, topToBottom: false));
        iter.moveNext();
      }
    }
    if(iter.current.contains('water-to')) {
      iter.moveNext();
      while (!iter.current.isEmpty) {
        waterToLightMap.add(createRange(iter.current));
        lightToWaterMap.add(createRange(iter.current, topToBottom: false));
        iter.moveNext();
      }
    }
    if(iter.current.contains('light-to')) {
      iter.moveNext();
      while (!iter.current.isEmpty) {
        lightToTempMap.add(createRange(iter.current));
        tempToLightMap.add(createRange(iter.current, topToBottom: false));
        iter.moveNext();
      }
    }
    if(iter.current.contains('temperature-to')) {
      iter.moveNext();
      while (!iter.current.isEmpty) {
        tempToHumidityMap.add(createRange(iter.current));
        humidityToTempMap.add(createRange(iter.current, topToBottom: false));
        iter.moveNext();
      }
    }
    if(iter.current.contains('humidity-to')) {
      while (iter.moveNext()) {
        humidityToLocationMap.add(createRange(iter.current));
        locationToHumidityMap.add(createRange(iter.current, topToBottom: false));
      }
    }
  }

  int minimumLocation = 0;

  for (var i = 0; i < seeds.length; i++) {
    int seed = seeds[i]!;
    seed = findNextStep(seed, seedToSoilMap);
    seed = findNextStep(seed, soilToFertilizerMap);
    seed = findNextStep(seed, fertilizerToWaterMap);
    seed = findNextStep(seed, waterToLightMap);
    seed = findNextStep(seed, lightToTempMap);
    seed = findNextStep(seed, tempToHumidityMap);
    seed = findNextStep(seed, humidityToLocationMap);

    if(i == 0) {
      minimumLocation = seed;
      continue;
    }
    
    minimumLocation = seed < minimumLocation ? seed : minimumLocation;
  }

  print('Result: $minimumLocation');

  // --------------Part2--------------
  List<Range> seedRanges = <Range>[];

  for(var i = 0; i < seeds.length; i+=2) {
    seedRanges.add(Range(seeds[i]!, seeds[i]!+seeds[i+1]!-1, 0));
  }

  locationToHumidityMap.sort(); // no use
  print('');

  int location;
  bool foundValidSeed = false;
  int minimumLocationPart2 = 0;

  for (var i = 0; i < 1000000000; i++) {
    if(foundValidSeed) {
      break;
    }
      
    location = i;
    location = findNextStep(location, locationToHumidityMap);
    location = findNextStep(location, humidityToTempMap);
    location = findNextStep(location, tempToLightMap);
    location = findNextStep(location, lightToWaterMap);
    location = findNextStep(location, waterToFertilizerMap);
    location = findNextStep(location, fertilizerToSoilMap);
    location = findNextStep(location, soilToSeedMap);
      
    for(final element in seedRanges) {
      if (element.isInRange(location)) {
        minimumLocationPart2 = i;
        foundValidSeed = true;
        break;
      }
    }
    
  }

  print('Result part 2: ${minimumLocationPart2}');

}