import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/services/my_drawer.dart';
import 'package:graph_logic/graph_logic.dart';

// ignore: must_be_immutable
class GraphWidget extends StatefulWidget {
  Graph<num>? graph;
  GraphWidget(bool isOriented, {Key? key}) : super(key: key) {
    graph = Graph<num>.def(isOriented);
  }
  @override
  // ignore: no_logic_in_create_state
  State<GraphWidget> createState() => _GraphWidget(graph as Graph<num>);
}

class _GraphWidget extends State<GraphWidget> {
  final Graph<num> graph;
  _GraphWidget(this.graph);
  double posx = 0;
  double posy = 0;

  void onTapDown(BuildContext context, TapDownDetails details) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    final Offset localOffset = box!.globalToLocal(details.globalPosition);
    var node = Node<num>(0);
    setState(() {
      posx = localOffset.dx;
      posy = localOffset.dy;
      node.location = Point(posx, posy);
      graph.addNode(node);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) => onTapDown(context, details),
      child: Scaffold(
          backgroundColor: Colors.blue,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constrains) {
              return CustomPaint(
                  painter: MyDrawer(graph: graph),
                  size: Size(constrains.maxWidth, constrains.maxHeight));
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // upload graph
            },
            label: const Text('Upload Graph'),
            icon: const Icon(Icons.thumb_up),
            backgroundColor: Colors.pink,
          )),
    );
  }
}
