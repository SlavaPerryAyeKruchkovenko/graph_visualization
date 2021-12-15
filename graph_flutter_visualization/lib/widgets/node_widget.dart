import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_logic/graph_logic.dart';

import 'edge_widget.dart';

class NodeWidget extends ImplicitlyAnimatedWidget {
  final Function(Node<num>)? removeNode;
  final Function(Node<num>, Node<num>)? addEdge;
  final Function()? callback;
  final Node<num> node;
  const NodeWidget({
    Key? key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
    required this.node,
    this.removeNode,
    this.addEdge,
    this.callback,
  }) : super(
            key: key,
            duration: swapAnimationDuration,
            curve: swapAnimationCurve);

  @override
  _NodeWidget createState() => _NodeWidget();
}

class _NodeWidget extends AnimatedWidgetBaseState<NodeWidget> {
  static Node<num>? _selectedNode;
  void deleteNode(Node<num> node) => {
        setState(() {
          if (widget.removeNode != null) {
            widget.removeNode!.call(node);
          }
        })
      };
  void selectNode(Node<num> node) => {
        setState(() {
          if (!node.isSelected) {
            if (_selectedNode == null) {
              node.isSelected = true;
              _selectedNode = node;
            } else {
              if (widget.addEdge != null) {
                widget.addEdge!.call(_selectedNode!, node);
                _selectedNode = null;
              }
            }
          } else {
            node.isSelected = false;
            _selectedNode = null;
          }
        })
      };
  void moveNode(BuildContext context, DragUpdateDetails details) => {
        setState(() {
          final Offset local = details.globalPosition;
          widget.node.location = Point(local.dx, local.dy);
          if (widget.callback != null) {
            widget.callback!.call();
          }
        })
      };

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.node.location.y - 20,
        left: widget.node.location.x - 20,
        width: 40,
        height: 40,
        child: GestureDetector(
            onPanUpdate: (details) => moveNode(context, details),
            onTap: () => selectNode(widget.node),
            onDoubleTap: () => deleteNode(widget.node),
            child: Stack(
              children: [
                Container(
                  child: Center(
                      child: Text(
                    widget.node.id.toString(),
                    textAlign: TextAlign.center,
                  )),
                  decoration: BoxDecoration(
                    color: widget.node.isSelected ? Colors.grey : Colors.purple,
                    shape: BoxShape.circle,
                  ),
                ),
                ...List.generate(
                  widget.node.incidentEdges.length,
                  (i) => EdgeWidget(widget.node.incidentEdges.toList()[i]),
                )
              ],
            )));
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {}
}
