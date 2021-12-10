import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/services/my_drawer.dart';
import 'package:graph_logic/graph_logic.dart';

Graph<num>? myGraph;

class GraphWidget extends StatefulWidget {
  const GraphWidget({Key? key, required this.graph}) : super(key: key);
  final Graph<num> graph;
  @override
  State<GraphWidget> createState() => _GraphWidget();
}

class _GraphWidget extends State<GraphWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Graph'),
          backgroundColor: Colors.orange,
        ),
        body: GestureDetector(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constrains) {
              return CustomPaint(
                  painter: MyDrawer(graph: graph),
                  size: Size(constrains.maxWidth, constrains.maxHeight));
            },
          ),
        ),
        drawerScrimColor: Colors.blue);
  }
}
