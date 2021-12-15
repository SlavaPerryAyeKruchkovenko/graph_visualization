import 'dart:convert';
import 'dart:io';
import 'package:graph_logic/graph_logic.dart';
import 'package:graph_logic/src/exstansions.dart';

void main() {
  example1();
  var path =
      "D:\\repoditory\\graph_visualization\\graph_logic\\example\\example.json";
  var file = File(path);
  List list = json.decode(file.readAsStringSync());
  for (var el in list.map((e) => Edge.fromJson(e))) {
    print(el.toString());
  }
}

void example1() {
  var list = [0, 1, 2, 3, 4];
  var nodes = list.map((e) => Node(e)).toList();
  nodes[0].location = Tuple(20, 20);
  nodes[1].location = Tuple(50, 30);
  nodes[2].location = Tuple(80, 50);
  nodes[3].location = Tuple(40, 70);
  nodes[4].location = Tuple(100, 10);
  List<Tuple<Node<int>, Node<int>>> incedentNodes = [
    Tuple(nodes[0], nodes[1]),
    Tuple(nodes[1], nodes[2]),
    Tuple(nodes[2], nodes[3]),
    Tuple(nodes[3], nodes[4]),
    Tuple(nodes[4], nodes[1]),
    Tuple(nodes[4], nodes[0]),
  ];
  var values = [11, 4, 12, 9, 5, 2];
  var graph = Graph.makeGraph<int>(incedentNodes, values, isOriented: false);
  var text = json.encode(graph.edges.toList());
  var path =
      "D:\\repoditory\\graph_visualization\\graph_logic\\example\\example.json";
  var file = File(path);
  file.writeAsString(text);
  printTable(graph);
}

void example2() {
  var list = List.generate(4, (index) => List.generate(4, (index) => 0));
  list[0][1] = 1;
  list[1][2] = 2;
  list[2][3] = 3;
  list[3][0] = 4;
  var graph = list.getGraph(isOriented: true);
  printTable(graph);
}

void example3() {
  var node1 = Node<int>(1);
  var node2 = Node<int>(2);
  var edge1 = Edge(node1, node2, 3);
  var edge2 = Edge(node2, node1, 3);
  print(edge1 == edge2);
}

void printTable(Graph<num> graph) {
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
