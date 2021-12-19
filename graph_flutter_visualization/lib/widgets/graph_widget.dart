import 'dart:collection';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/widgets/menu_setting.dart';
import 'package:graph_flutter_visualization/widgets/node_widget.dart';
import 'package:graph_logic/graph_logic.dart';
import 'package:stack/stack.dart' as col;
import 'edge_widget.dart';

class GraphWidget extends StatefulWidget {
  const GraphWidget({Key? key}) : super(key: key);
  @override
  State<GraphWidget> createState() => _GraphWidget();
}

class _GraphWidget extends State<GraphWidget> {
  var graph = Graph<num>.def(false);
  double posx = 0;
  double posy = 0;
  List<Widget> edges = [];
  List<Widget> nodes = [];
  bool _isRun = false;
  void _onTapDown(BuildContext context, TapDownDetails details) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    final Offset localOffset = box!.globalToLocal(details.globalPosition);
    var node = Node<num>(0);
    posx = localOffset.dx;
    posy = localOffset.dy;
    setState(() {
      node.location = Point(posx, posy);
      graph.addNode(node);
    });
  }

  void callback() {
    setState(() {
      deactivate();
    });
  }

  void _showSettingsPanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Menu(
            depthSearch: () => _graphBypass(_depthSearch),
            breadthSearch: () => _graphBypass(_breadthSearch),
          );
        });
  }

  void _graphBypass(Function(Node<num>) action) {
    if (graph.nodes.any((node) => node.isSelected) && !_isRun) {
      action.call(graph.nodes.where((node) => node.isSelected).first);
    }
  }

  void _depthSearch(Node<num> startNode) async {
    setState(() {
      _isRun = true;
    });
    var visited = HashSet<Node<num>>();
    col.Stack<Node<num>> stack = col.Stack();
    stack.push(startNode);
    while (stack.isNotEmpty) {
      var node = stack.pop();
      if (!visited.contains(node)) {
        setState(() {
          node.isSelected = true;
        });
        await Future.delayed(const Duration(milliseconds: 1000));
        visited.add(node);
        setState(() {
          node.isSelected = false;
        });
        for (var incidentNode in node.incidentNodes) {
          stack.push(incidentNode);
        }
      }
    }
    debugPrint('finish');
    setState(() {
      for (var node in graph.nodes) {
        node.isSelected = false;
      }
      _isRun = false;
    });
  }

  void _breadthSearch(Node<num> startNode) async {
    setState(() {
      _isRun = true;
    });
    var visited = HashSet<Node<num>>();
    var queue = Queue<Node<num>>();
    queue.add(startNode);
    while (queue.isNotEmpty) {
      var node = queue.first;
      queue.removeFirst();
      if (!visited.contains(node)) {
        setState(() {
          node.isSelected = true;
        });
        await Future.delayed(const Duration(milliseconds: 1000));
        visited.add(node);
        setState(() {
          node.isSelected = false;
        });
        for (var incidentNode in node.incidentNodes) {
          queue.add(incidentNode);
        }
      }
    }
    debugPrint('finish');
    setState(() {
      for (var node in graph.nodes) {
        node.isSelected = false;
      }
      _isRun = false;
    });
  }

  void _addEdge(Node<num> node1, Node<num> node2) async {
    if (graph.isOriented
        ? !graph.edges.any((node) => node.from == node1 && node.to == node2)
        : !graph.edges.any((node) =>
            (node.from == node1 || node.from == node2) &&
            (node.to == node2 || node.to == node1))) {
      /*final value = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DialogForm(),
        ));*/

      setState(() {
        for (var element in graph.nodes) {
          element.isSelected = false;
        }
        graph.connect(node1, node2, 2 //value
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTapDown: (TapDownDetails details) => _onTapDown(context, details),
          child: const Scaffold(
            backgroundColor: Colors.blue,
          ),
        ),
        ...List.generate(
            graph.lenght,
            (i) => NodeWidget(
                  node: graph[i],
                  graph: graph,
                  addEdge: _addEdge,
                  callback: callback,
                )),
        ...List.generate(
            graph.edgeLenght,
            (i) => EdgeWidget(
                  edge: graph.edges.toList()[i],
                  graph: graph,
                  callback: callback,
                )),
        Positioned(
          child: TextButton(
              onPressed: _showSettingsPanel,
              child: const Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )),
          bottom: 0,
        )
      ],
    );
  }
}
