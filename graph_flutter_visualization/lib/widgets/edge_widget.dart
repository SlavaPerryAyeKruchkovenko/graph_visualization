import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/models/node_state.dart';
import 'package:graph_flutter_visualization/services/my_drawer.dart';
import 'package:graph_logic/graph_logic.dart';

// ignore: must_be_immutable
class EdgeWidget extends StatefulWidget {
  final Function(dynamic)? callback;
  Edge<num> edge;
  Graph<num> graph;
  Point to;
  Point from;
  EdgeWidget({
    Key? key,
    required this.edge,
    required this.graph,
    this.callback,
    required this.to,
    required this.from,
  }) : super(key: key);
  final _state = ObjectState.basic;
  @override
  State<EdgeWidget> createState() => _EdgeWidget();
}

class _EdgeWidget extends State<EdgeWidget> {
  _deleteEdge() {
    setState(() {
      widget.graph.disconect(widget.edge);
      if (widget.callback != null) {
        widget.callback!.call(widget.edge);
      }
    });
  }

  Color _getColor() {
    switch (widget._state) {
      case ObjectState.basic:
        return Colors.red;
      case ObjectState.select:
        return Colors.yellow;
      case ObjectState.passed:
        return Colors.pink;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        width: 20,
        height: 20,
        top: (widget.to.y + (widget.from.y - widget.to.y) / 2) - 20,
        left: widget.to.x + (widget.from.x - widget.to.x) / 2 - 20,
        child: Stack(
          children: [
            GestureDetector(
              onDoubleTap: _deleteEdge,
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
                  color: _getColor(),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            CustomPaint(
              painter: Drawhorizontalline(
                  Point(-(widget.from.x - widget.to.x) / 2 + 20,
                      -(widget.from.y - widget.to.y) / 2 + 20),
                  Point((widget.from.x - widget.to.x) / 2 + 20,
                      (widget.from.y - widget.to.y) / 2 + 20)),
            )
          ],
        ));
  }
}
