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
      child: CustomPaint(
          painter: Drawhorizontalline(
              const Point(20, 20),
              widget.edge.to.location -
                  widget.edge.from.location +
                  const Point(20, 20))),
    );
  }
}
/*Container(
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
