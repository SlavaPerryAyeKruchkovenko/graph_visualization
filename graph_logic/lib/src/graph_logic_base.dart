import 'dart:html';

import 'dart:math';

class Graph<num> {
  List<Node<num>> _nodes = [];
  Graph(int nodesCount) {
    _nodes = Iterable.generate(nodesCount).map((e) => Node<num>(e)).toList();
  }
  int get lenght => _nodes.length;
  Iterable<Node<num>> get nodes => _nodes;
  Iterable<Edge<num>> get edges => [
        ...{
          ..._nodes
              .map((x) => x.incidentEdges)
              .reduce((x, element) => x.toList() + element.toList())
        }
      ];

  void addNode(value) {
    if (value is num) {
      _nodes.add(Node(value));
    }
    if (value is Node<num>) {
      _nodes.add(value);
    } else {
      throw FormatException("incorrect params");
    }
  }

  void connect(index1, index2, edgeValue) {
    var eadge =
        Node.connect<num>(_nodes[index1], _nodes[index2], this, edgeValue);
    _nodes[index1]._edges.add(eadge);
    _nodes[index2]._edges.add(eadge);
  }

  void disconect(Edge<num> edge) {
    Node.disconect(edge);
  }

  static Graph makeGraph<num>(
      Map<Node<num>, Node<num>> incidentNodes, List<num> values) {
    if (incidentNodes.length == values.length) {
      var graph = Graph(incidentNodes.length);
      int i = 0;
      int counter = 0;
      for (var element in incidentNodes.entries) {
        i++;
        counter++;
        graph.addNode(element.key);
        graph.addNode(element.value);
        graph.connect(counter, counter + 1, values[i]);
      }
      return graph;
    } else {
      throw Exception("incorrect parameters");
    }
  }
}

class Node<num> {
  final List<Edge<num>> _edges = [];
  final num _number;
  bool isSelected = false;
  Point location = Point(0, 0);
  int _id = 0;
  Node(this._number) {
    _id = _counter;
    _counter++;
  }
  num get number => _number;
  int get id => _id;
  Iterable<Node<num>> get incidentNodes => _edges.map((e) => e.otherNode(this));
  Iterable<Edge<num>> get incidentEdges => _edges.map((e) => e);
  num? getValueLinkNode(Node<num> node) {
    var edge = incidentEdges.where((x) => x.isIncident(node));
    if (edge.isNotEmpty) {
      return edge.first.value;
    } else {
      return null;
    }
  }

  static int _counter = 1;
  static Edge<num> connect<num>(
      Node<num> node1, Node<num> node2, Graph<num> graph, num value) {
    if (!graph.nodes.contains(node1) || !graph.nodes.contains(node2)) {
      throw FormatException("incorect node");
    }
    var edge = Edge<num>(node1, node2, value);
    node1._edges.add(edge);
    node2._edges.add(edge);
    return edge;
  }

  static void disconect(Edge edge) {
    edge.from._edges.remove(edge);
    edge.to._edges.remove(edge);
  }

  @override
  bool operator ==(other) {
    if (other is Node<num>) {
      var node = other;
      return _id == node.id;
    }
    return false;
  }

  @override
  int get hashCode => _id;
}

class Edge<num> {
  bool isSelected = false;
  Point startLoc = Point(0, 0);
  Point finishLoc = Point(0, 0);
  final Node<num> from;
  final Node<num> to;
  final num value;
  Edge(this.from, this.to, this.value);
  bool isIncident(Node<num> node) {
    return from == node || to == node;
  }

  Node<num> otherNode(Node<num> node) {
    if (isIncident(node) && value != null) {
      if (from == node) {
        return to;
      } else {
        return from;
      }
    } else {
      throw FormatException("incorect value");
    }
  }
}
