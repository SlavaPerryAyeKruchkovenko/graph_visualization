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
  static final List<Node<num>> selectedNodes = [];
  @override
  // ignore: no_logic_in_create_state
  _NodeWidget createState() => stateNow;
}

class _NodeWidget extends AnimatedWidgetBaseState<NodeWidget> {
  get state => _state;
  var _state = ObjectState.basic;
  _deleteNode(Node<num> node) => {
        setState(() {
          if (widget.callback != null) {
            widget.callback!.call(widget.node);
          }
          widget.graph.removeNode(node);
        })
      };
  changeState(ObjectState state) {
    setState(() {
      _state = state;
    });
  }

  _selectNode(Node<num> node) => {
        setState(() {
          if (_state == ObjectState.basic) {
            if (NodeWidget.selectedNodes.isNotEmpty) {
              widget.addEdge.call(NodeWidget.selectedNodes.first, widget.node);
              NodeWidget.selectedNodes.clear();
              _state = ObjectState.basic;
            } else {
              _state = ObjectState.select;
              NodeWidget.selectedNodes.add(node);
            }
          } else {
            _state = ObjectState.basic;
            NodeWidget.selectedNodes.clear();
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
        })
      };
  Color _getColor() {
    switch (_state) {
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
