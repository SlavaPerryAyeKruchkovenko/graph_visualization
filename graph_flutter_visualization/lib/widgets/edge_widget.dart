import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/services/my_drawer.dart';
import 'package:graph_logic/graph_logic.dart';

// ignore: must_be_immutable
class EdgeWidget extends StatefulWidget {
  final Function()? callback;
  Edge<num> edge;
  Graph<num> graph;
  EdgeWidget({
    Key? key,
    required this.edge,
    required this.graph,
    this.callback,
  }) : super(key: key);
  @override
  State<EdgeWidget> createState() => _EdgeWidget();
}

class _EdgeWidget extends State<EdgeWidget> {
  void deleteEdge() {
    setState(() {
      widget.graph.disconect(widget.edge);
      if (widget.callback != null) {
        widget.callback!.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        width: 20,
        height: 20,
        top: (widget.edge.to.location.y +
                (widget.edge.from.location.y - widget.edge.to.location.y) / 2) -
            20,
        left: widget.edge.to.location.x +
            (widget.edge.from.location.x - widget.edge.to.location.x) / 2 -
            20,
        child: Stack(
          children: [
            GestureDetector(
              onDoubleTap: deleteEdge,
              child: Container(
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
            ),
            CustomPaint(
              painter: Drawhorizontalline(
                  Point(
                      -(widget.edge.from.location.x -
                                  widget.edge.to.location.x) /
                              2 +
                          20,
                      -(widget.edge.from.location.y -
                                  widget.edge.to.location.y) /
                              2 +
                          20),
                  Point(
                      (widget.edge.from.location.x -
                                  widget.edge.to.location.x) /
                              2 +
                          20,
                      (widget.edge.from.location.y -
                                  widget.edge.to.location.y) /
                              2 +
                          20)),
            )
          ],
        ));
  }
}
