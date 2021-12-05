import 'package:graph_logic/graph_logic.dart';

void main() {
  Map<Node<num>, Node<num>> incedentNodes = {
    Node(0): Node(1),
    Node(0): Node(2),
    Node(1): Node(3),
    Node(1): Node(4),
    Node(2): Node(3),
    Node(3): Node(4),
  };
  var values = [1, 2, 3, 4, 5, 6];
  Graph.makeGraph(incedentNodes, values);
}
