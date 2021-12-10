import 'package:flutter/cupertino.dart';
import 'package:graph_logic/graph_logic.dart';

class MyDrawer extends CustomPainter {
  final Graph<num> graph;
  MyDrawer({required this.graph});
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
