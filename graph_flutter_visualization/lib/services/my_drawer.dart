import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_logic/graph_logic.dart';

class MyDrawer extends CustomPainter {
  final Edge<num> edge;
  MyDrawer({required this.edge});
  @override
  void paint(Canvas canvas, Size size) {
    Offset p1 = Offset(edge.to.location.x, edge.to.location.y);
    Offset p2 = Offset(edge.from.location.x, edge.from.location.y);
    var paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 5;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
