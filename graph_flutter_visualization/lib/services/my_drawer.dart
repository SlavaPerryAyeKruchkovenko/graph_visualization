import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Drawhorizontalline extends CustomPainter {
  final Point<double> startPoint;
  final Point<double> finishPoint;
  Drawhorizontalline(this.startPoint, this.finishPoint);
  final Paint _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(startPoint.x, startPoint.y),
        Offset(finishPoint.x, finishPoint.y), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
