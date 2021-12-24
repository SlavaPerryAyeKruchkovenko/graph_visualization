import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/models/node_state.dart';
import 'package:graph_logic/graph_logic.dart';

// ignore: must_be_immutable
class NodeWidget extends ImplicitlyAnimatedWidget {
  final Function()? callback;
  final Node<num> node;
  final Graph<num> graph;
  final Function(Node<num>, Node<num>) addEdge;
  NodeWidget({
    Key? key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
    required this.graph,
    required this.node,
    required this.addEdge,
    this.callback,
  }) : super(
            key: key,
            duration: swapAnimationDuration,
            curve: swapAnimationCurve);

  var _state = NodeState.basic;
  NodeState get state => _state;
  @override
  _NodeWidget createState() => _NodeWidget();
}

class _NodeWidget extends AnimatedWidgetBaseState<NodeWidget> {
  static Node<num>? _selectedNode;

  void _deleteNode(Node<num> node) => {
        setState(() {
          widget.graph.removeNode(node);
          if (widget.callback != null) {
            widget.callback!.call();
          }
        })
      };

  _selectNode(Node<num> node) => {
        setState(() {
          if (widget._state == NodeState.basic) {
            if (_selectedNode != null) {
              widget.addEdge.call(_selectedNode!, node);
              _selectedNode = null;
              if (widget.callback != null) {
                widget.callback!.call();
              }
            } else {
              widget._state = NodeState.select;
              _selectedNode = node;
            }
          } else {
            widget._state = NodeState.basic;
            _selectedNode = null;
          }
        })
      };
  _moveNode(BuildContext context, DragUpdateDetails details) => {
        setState(() {
          final Offset local = details.globalPosition;
          widget.node.location = Point(local.dx, local.dy);
          if (widget.callback != null) {
            widget.callback!.call();
          }
        })
      };
  Color _getColor() {
    switch (widget._state) {
      case NodeState.basic:
        return Colors.purple;
      case NodeState.select:
        return Colors.grey;
      case NodeState.passed:
        return Colors.pink;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.node.location.y - 20,
        left: widget.node.location.x - 20,
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
