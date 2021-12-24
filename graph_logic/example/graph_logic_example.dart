import 'dart:convert';
import 'dart:io';
import 'package:graph_logic/graph_logic.dart';

void main() {
  example4();
}

void example1() {
  var list = [0, 1, 2, 3, 4];
  var nodes = list.map((e) => Node(e)).toList();
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

void example4() {
  var list = [0, 1, 2, 3];
  var nodes = list.map((e) => Node(e)).toList();
  List<Tuple<Node<int>, Node<int>>> incedentNodes = [
    Tuple(nodes[0], nodes[1]),
    Tuple(nodes[1], nodes[2]),
    Tuple(nodes[2], nodes[3]),
    Tuple(nodes[3], nodes[0]),
  ];
  var values = [19, 20, 12, 9];
  var graph = Graph.makeGraph<int>(incedentNodes, values, isOriented: false);
  graph.removeNode(nodes[0]);
  var path =
      "D:\\repoditory\\graph_visualization\\graph_logic\\example\\example.json";
  var file = File(path);
  var text = json.encode(nodes);
  file.writeAsString(text);

  printTable(graph);
}

void example5() {
  var path =
      "D:\\repoditory\\graph_visualization\\graph_logic\\example\\example.json";
  var file = File(path);
  Graph<num> graph = Graph.fromJson(json.decode(file.readAsStringSync()));
  var a = graph.toString();
  print(a);
  //printTable(graph);
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
