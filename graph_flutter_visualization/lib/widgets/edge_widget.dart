import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/services/my_drawer.dart';
import 'package:graph_logic/graph_logic.dart';

// ignore: must_be_immutable
class EdgeWidget extends StatefulWidget {
  Edge<num> edge;
  EdgeWidget(this.edge, {Key? key}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<EdgeWidget> createState() => _EdgeWidget();
}

class _EdgeWidget extends State<EdgeWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        width: 20,
        height: 20,
        top: widget.edge.to.location.y +
            (widget.edge.from.location.y - widget.edge.to.location.y) / 2 -
            20,
        left: widget.edge.to.location.x +
            (widget.edge.from.location.x - widget.edge.to.location.x) / 2,
        child: Stack(
          children: [
            Container(
              child: Center(
                  child: Text(
                widget.edge.value.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
              decoration: BoxDecoration(
                color: widget.edge.isSelected ? Colors.yellow : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            CustomPaint(
              painter: Drawhorizontalline(
                  Point(
                      -(widget.edge.from.location.x -
                              widget.edge.to.location.x) /
                          2,
                      -(widget.edge.from.location.y -
                                  widget.edge.to.location.y) /
                              2 +
                          20),
                  Point(
                      (widget.edge.from.location.x -
                              widget.edge.to.location.x) /
                          2,
                      (widget.edge.from.location.y -
                                  widget.edge.to.location.y) /
                              2 +
                          20)),
            )
          ],
        ));
  }
}
/*child: Stack(
          children: [
            CustomPaint(
                painter: Drawhorizontalline(const Point(0, 0),
                    widget.edge.to.location - widget.edge.from.location)),
Container(
            child: Center(
                child: Text(
              widget.edge.value.toString(),
              textAlign: TextAlign.center,
            )),
            decoration: BoxDecoration(
              color: widget.edge.isSelected ? Colors.grey : Colors.black,
              shape: BoxShape.rectangle,
            ),
          )*/
