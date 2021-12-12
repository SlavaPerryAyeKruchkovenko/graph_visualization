import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_logic/graph_logic.dart';

class NodeWidget extends StatefulWidget {
  const NodeWidget(this.graph, this.node, {Key? key}) : super(key: key);
  final Node<num> node;
  final Graph<num> graph;
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _NodeElement(graph, node);
}

class _NodeElement extends State<NodeWidget> {
  final Node<num> node;
  final Graph<num> graph;
  _NodeElement(this.graph, this.node);
  void deleteNode(Node<num> node) => {
        setState(() {
          graph.removeNode(node);
        })
      };
  void selectNode() => {
        setState(() {
          node.isSelected = true;
        })
      };
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: node.location.y - 20,
        left: node.location.x - 20,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: selectNode,
          onDoubleTap: () => deleteNode(node),
          child: Container(
            child: Center(
                child: Text(
              node.id.toString(),
              textAlign: TextAlign.center,
            )),
            decoration: BoxDecoration(
              color: node.isSelected ? Colors.grey : Colors.purple,
              shape: BoxShape.circle,
            ),
          ),
        ));
  }
}
