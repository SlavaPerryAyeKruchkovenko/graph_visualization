import 'dart:math';

class Graph<num> {
  final bool isOriented;
  List<Node<num>> _nodes = [];
  Graph(int nodesCount, this.isOriented) {
    _nodes = Iterable.generate(nodesCount).map((e) => Node<num>(e)).toList();
  }
  Graph.def(this.isOriented);
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

  void connect(Node<num> node1, Node<num> node2, num edgeValue) {
    var eadges = Node.connect<num>(node1, node2, this, edgeValue);
    if (isOriented) {
      node1._edges.add(eadges.item1);
    } else {
      node1._edges.add(eadges.item1);
      node2._edges.add(eadges.item2);
    }
  }

  void disconect(Edge<num> edge) {
    Node.disconect(edge);
  }

  Node<num> operator [](int index) {
    return _nodes[index];
  }

  static Graph<num> makeGraph<num>(
      List<Tuple<Node<num>, Node<num>>> incidentNodes, List<num> values,
      {bool isOriented = false}) {
    if (incidentNodes.length == values.length) {
      var graph = Graph<num>.def(isOriented);
      int i = 0;
      for (var element in incidentNodes) {
        if (!graph.nodes.contains(element.item1)) {
          graph.addNode(element.item1);
        }
        if (!graph.nodes.contains(element.item2)) {
          graph.addNode(element.item2);
        }
        graph.connect(element.item1, element.item2, values[i]);
        i++;
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
  static Tuple<Edge<num>, Edge<num>> connect<num>(
      Node<num> node1, Node<num> node2, Graph<num> graph, num value) {
    if (!graph.nodes.contains(node1) || !graph.nodes.contains(node2)) {
      throw FormatException("incorect node");
    }
    var edge1 = Edge<num>(node1, node2, value);
    var edge2 = Edge(node2, node1, value);
    return Tuple(edge1, edge2);
  }

  static void disconect(Edge edge) {
    edge.from._edges.remove(edge);
    edge.to._edges.remove(edge);
  }

  @override
  bool operator ==(other) {
    return other is Node<num> && _id == other.id;
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

class Tuple<T1, T2> {
  Tuple(this.item1, this.item2);
  T1 item1;
  T2 item2;
}
