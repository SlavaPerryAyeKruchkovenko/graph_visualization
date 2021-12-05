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
                ? Edge(Node(0), Node(0), 100000)
                : edge.first;
      }

      var list = List.generate(lenght, (j) => getEdge(j), growable: false);
      result.add(list);
      i++;
    }
    return result;
  }
}
