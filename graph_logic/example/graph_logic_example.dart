import 'package:graph_logic/graph_logic.dart';
import 'package:graph_logic/src/exstansions.dart';

void main() {
  var list = [0, 1, 2, 3, 4];
  var nodes = list.map((e) => Node(e)).toList();
  List<Tuple<Node<int>, Node<int>>> incedentNodes = [
    Tuple(nodes[0], nodes[1]),
    Tuple(nodes[0], nodes[2]),
    Tuple(nodes[1], nodes[3]),
    Tuple(nodes[1], nodes[4]),
    Tuple(nodes[2], nodes[3]),
    Tuple(nodes[3], nodes[4]),
  ];
  var values = [11, 2, 3, 4, 5, 6];
  var graph = Graph.makeGraph<int>(incedentNodes, values, false);
  var table = graph.linkTable;
  var i = 0;
  for (var item in table) {
    print(i.toString() + ": ");
    String text = "";
    for (var item2 in item) {
      text += item2.value.toString() + " ";
    }
    print(text);
    i++;
  }
}
