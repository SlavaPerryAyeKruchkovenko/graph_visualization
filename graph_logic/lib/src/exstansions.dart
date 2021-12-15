import 'dart:math';

import 'package:graph_logic/graph_logic.dart';

extension GraphExtension on Graph<num> {
  List<List<Edge<num>>> get linkTable {
    List<List<Edge<num>>> result = [];
    int i = 0;
    for (var item in nodes) {
      Edge<num> getEdge(int j) {
        var edge =
            item.incidentEdges.where((x) => x.from == item && x.to == this[j]);
        return i == j
            ? Edge(Node(0), Node(0), 0)
            : edge.isEmpty
                ? Edge(Node(0), Node(0), Edge.maxValue)
                : edge.first;
      }

      var list = List.generate(lenght, (j) => getEdge(j), growable: false);
      result.add(list);
      i++;
    }
    return result;
  }
}

extension ListExtension on List<List<num>> {
  Graph<num> getGraph({bool isOriented = false}) {
    if (isEmpty || this[0].length != length) {
      return Graph<num>.def(isOriented);
    } else {
      var graph = Graph<num>(length, isOriented);
      for (var j = 0; j < length; j++) {
        for (var i = 0; i < length; i++) {
          var num = this[j][i];
          if (num != 0) {
            graph.connect(graph[j], graph[i], num);
          }
        }
      }
      return graph;
    }
  }
}

extension PointExtension on Point<double> {
  Map<String, dynamic> get toJson => {
        'x': x,
        'y': y,
      };
}
