import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/widgets/node_widget.dart';
import 'package:graph_logic/graph_logic.dart';

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

  void onTapDown(BuildContext context, TapDownDetails details) {
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

  void addEdge(Node<num> node1, Node<num> node2) {
    setState(() {
      for (var element in graph.nodes) {
        element.isSelected = false;
      }
      graph.connect(node1, node2, 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTapDown: (TapDownDetails details) => onTapDown(context, details),
          child: const Scaffold(
            backgroundColor: Colors.blue,
          ),
        ),
        ...List.generate(
            graph.lenght,
            (i) => NodeWidget(
                  node: graph[i],
                  graph: graph,
                  callback: callback,
                )),
        ...List.generate(
            graph.edgeLenght,
            (i) => EdgeWidget(
                  edge: graph.edges.toList()[i],
                  graph: graph,
                  callback: callback,
                )),
      ],
    );
  }
}
