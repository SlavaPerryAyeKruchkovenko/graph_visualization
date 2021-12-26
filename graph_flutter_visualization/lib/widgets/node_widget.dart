import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/models/node_state.dart';
import 'package:graph_logic/graph_logic.dart';

// ignore: must_be_immutable
class NodeWidget extends ImplicitlyAnimatedWidget {
  final Function(dynamic)? callback;
  final Function(Node<num>, Point)? changeLoc;
  final Node<num> node;
  final Graph<num> graph;
  final Function(Node<num>, Node<num>) addEdge;
  Point location;
  NodeWidget(
    this.location, {
    Key? key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
    required this.graph,
    required this.node,
    required this.addEdge,
    this.changeLoc,
    this.callback,
  }) : super(
            key: key,
            duration: swapAnimationDuration,
            curve: swapAnimationCurve);
  var stateNow = _NodeWidget();
  var state = ObjectState.basic;
  @override
  // ignore: no_logic_in_create_state
  _NodeWidget createState() => stateNow;
}

class _NodeWidget extends AnimatedWidgetBaseState<NodeWidget> {
  static Node<num>? _selectedNode;

  _deleteNode(Node<num> node) => {
        setState(() {
          if (widget.callback != null) {
            widget.callback!.call(widget.node);
          }
          widget.graph.removeNode(node);
        })
      };

  _selectNode(Node<num> node) => {
        setState(() {
          if (widget.state == ObjectState.basic) {
            if (_selectedNode != null) {
              widget.addEdge.call(_selectedNode!, widget.node);
              _selectedNode = null;
            } else {
              widget.state = ObjectState.select;
              _selectedNode = node;
            }
          } else {
            widget.state = ObjectState.basic;
            _selectedNode = null;
          }
        })
      };
  _moveNode(BuildContext context, DragUpdateDetails details) => {
        setState(() {
          final Offset local = details.globalPosition;
          widget.location = Point(local.dx, local.dy);
          if (widget.changeLoc != null) {
            widget.changeLoc!.call(widget.node, Point(local.dx, local.dy));
          }
          if (widget.callback != null) {
            widget.callback!.call(null);
          }
        })
      };
  Color _getColor() {
    switch (widget.state) {
      case ObjectState.basic:
        return Colors.purple;
      case ObjectState.select:
        return Colors.grey;
      case ObjectState.passed:
        return Colors.pink;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.location.y - 20,
        left: widget.location.x - 20,
        width: 40,
        height: 40,
        child: GestureDetector(
          onPanUpdate: (details) => _moveNode(context, details),
          onTap: () => _selectNode(widget.node),
          onDoubleTap: () => _deleteNode(widget.node),
          child: Container(
            child: Center(
                child: Text(
              widget.node.id.toString(),
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
        ));
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {}
}
