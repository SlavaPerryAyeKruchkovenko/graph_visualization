import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_logic/graph_logic.dart';

class MyDrawer extends CustomPainter {
  final Graph<num> graph;
  MyDrawer({required this.graph});
  @override
  void paint(Canvas canvas, Size size) {
    for (var node in graph.nodes) {
      Offset offset =
          Offset(node.location.x as double, node.location.y as double);
      var paint = Paint()..color = Colors.purple;
      canvas.drawCircle(offset, 10, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
