import 'dart:collection';
import 'dart:io';

class Connection {
  Connection(this.a, this.b, {this.distance = 0});
  
  String a;
  String b;

  int distance;

  @override
  String toString() {
    return '$a <--> $b, $distance';
  }

  @override
  bool operator==(Object other) {
    other = other as Connection;
    return (a == other.a && b == other.b) || (a == other.b && b == other.a);
  }

  @override
  int get hashCode => a.codeUnits.fold(1, (previousValue, element) => previousValue*element) + b.codeUnits.fold(1, (previousValue, element) => previousValue*element);
}

class NodeDistance implements Comparable<NodeDistance>{
  NodeDistance(this.node, this.aDistance);
  String node;
  double aDistance;  

  @override
  int compareTo(NodeDistance other) {
    return ((aDistance - other.aDistance)*100).toInt();
  }

  @override
  String toString() {
    return '$node, $aDistance';
  }
}




// MAIN
// FUNCTION
void main(List<String> args) {
  print('reading input...');
  File file = File('inputs/25_test');
  List<String> inputList = file.readAsLinesSync();
  
  print('converting input to map...');
  HashMap<String, List<String>> inputMap = convertInputToMap(inputList);

  print('processing connections...');
  Set<Connection> connections = makeConnections(inputMap);

  print('calculating average distance...');
  List<NodeDistance> nodeByAverageDistance = calcAverageDistance(inputMap.keys, connections);

  print('creating initial groups...');
  List<String> groupA, groupB;
  [groupA, groupB] = createInitialGroups(nodeByAverageDistance);

  int currentResult = nodesBetweenGroups(connections, groupA, groupB);

  print('currentResult: $currentResult');

  // for (var element in nodeByAverageDistance) {
  //   print(element);
  // }
}




int nodesBetweenGroups(Set<Connection> connections, List<String> groupA, List<String> groupB) {
  int result = 0;

  Set<Connection> neighbours = connections.where((element) => element.distance == 1).toSet();


  for (var connection in neighbours) {
    if ((groupA.contains(connection.a) && groupB.contains(connection.b)) || (groupA.contains(connection.b) && groupB.contains(connection.a))) {
      result++;
    }
  }

  return result;
}


List<List<String>> createInitialGroups(List<NodeDistance> nodeByAverageDistance) {
  List<String> groupA = [], groupB = [];

  nodeByAverageDistance.sort(); // if it hasn't been done

  for (var i = 0; i < nodeByAverageDistance.length; i++) {
    if(i%2 == 0)
      groupA.add(nodeByAverageDistance[i].node);
    else
      groupB.add(nodeByAverageDistance[i].node);
  }
  
  return [groupA, groupB];
}


List<NodeDistance> calcAverageDistance(Iterable<String> nodes, Set<Connection> connections) {
  List<NodeDistance> output = [];

  for (var currentNode in nodes) {
    double totalDistance = 0;
    for (var connection in connections) {
      if (currentNode == connection.a || currentNode == connection.b) {
        totalDistance += connection.distance;
      }
    }
    output.add(NodeDistance(currentNode, totalDistance/(nodes.length-1)));
  }

  return output;
}


Set<Connection> makeConnections(HashMap<String, List<String>> map) {
  Set<Connection> output = {};

  var keys = map.keys.toList();

  for (var i = 0; i < keys.length-1; i++) {
    for (var j = i+1; j < keys.length; j++) {
      print('\tprocessing ($i,$j)'); 
      output.add(Connection(keys[i], keys[j], distance: distanceBetweenNodes(map, keys[i], keys[j])));
    }
  }
  
  return output;
}


int distanceBetweenNodes(HashMap<String, List<String>> map, String a, String b) {
  List<String> valueA = map.putIfAbsent(a, () => []);
  List<String> valueB = map.putIfAbsent(b, () => []);

  if (valueA.contains(b) || valueB.contains(a)) {
    return 1;
  } else {
    // make search
    Set<String> searchedKeys = {a, b};
    List<List<String>> nextPathToSearch = [valueA];
    String valueToFind = b;
    int distance = 1;
    while (true) {
      distance++;
      int tempLength = nextPathToSearch.length;
      for (var i = 0; i < tempLength; i++) {
        for (var j = 0; j < nextPathToSearch[i].length; j++) {
          if (searchedKeys.contains(nextPathToSearch[i][j])) {
            continue;
          }
          var pathToSearch = map.putIfAbsent(nextPathToSearch[i][j], () => []);
          searchedKeys.add(nextPathToSearch[i][j]);
          if (pathToSearch.contains(valueToFind)) {
            return distance;
          } else {
            nextPathToSearch.add(pathToSearch);
          }
        }
        
      }
    }
  }
  
  // return 0;
}


HashMap<String, List<String>> convertInputToMap(List<String> input) {
  HashMap<String, List<String>> output = HashMap();

  for (var element in input) {
    String key;
    String value;
    [key, value] = element.split(':');
    List<String> values = value.split(' ');
    values.removeWhere((element) => element == '');
    output.addAll({key: values});
  }

  Set<String> otherKeys = {};
  
  for (var entry in output.entries) {
    for (var element in entry.value) {
      if (output.containsKey(element) == false) {
        otherKeys.add(element);
      }
    }
  }

  output.addAll(Map.fromIterables(otherKeys, List.generate(otherKeys.length, (index) => <String>[])));

  for (var entry in output.entries) {
    for (var element in entry.value) {
      var valueToExpand = output.putIfAbsent(element, () => []);
      if (valueToExpand.contains(entry.key) == false) {
        valueToExpand.add(entry.key);
      }
    }
  }

  return output;
}