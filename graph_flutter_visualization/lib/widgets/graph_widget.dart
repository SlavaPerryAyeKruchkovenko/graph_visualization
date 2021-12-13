import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/widgets/edge_widget.dart';
import 'package:graph_logic/graph_logic.dart';

// ignore: must_be_immutable
class GraphWidget extends StatefulWidget {
  Graph<num>? graph;
  GraphWidget(bool isOriented, {Key? key}) : super(key: key) {
    graph = Graph<num>.def(isOriented);
  }
  @override
  // ignore: no_logic_in_create_state
  State<GraphWidget> createState() => _GraphWidget(graph as Graph<num>);
}

class _GraphWidget extends State<GraphWidget> {
  final Graph<num> graph;

  _GraphWidget(this.graph);
  double posx = 0;
  double posy = 0;
  List<Widget> edges = [];
  Node<num>? selectedNode;

  void connectNodes(Node<num> node1, Node<num> node2, num value) {
    var edge = graph.connect(node1, node2, value);

    setState(() {
      edges.add(EdgeWidget(edge));
      for (var element in graph.nodes) {
        element.isSelected = false;
      }
      selectedNode = null;
    });
  }

  void deleteNode(Node<num> node) => {
        setState(() {
          graph.removeNode(node);
        })
      };
  void selectNode(Node<num> node) => {
        setState(() {
          if (!node.isSelected) {
            node.isSelected = true;
            if (selectedNode != null) {
              connectNodes(selectedNode as Node<num>, node, 2);
            } else {
              selectedNode = node;
            }
          } else {
            node.isSelected = false;
            selectedNode = null;
          }
        })
      };
  void onTapDown(BuildContext context, TapDownDetails details) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    final Offset localOffset = box!.globalToLocal(details.globalPosition);

    var node = Node<num>(0);
    posx = localOffset.dx;
    posy = localOffset.dy;
    setState(() {
      node.location = Point(posx, posy);
      graph.addNode(node);
    });
  }

  Color greyColor = Colors.grey;
  List<int> selectedSpots = [];
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTapDown: (TapDownDetails details) => onTapDown(context, details),
          child: const Scaffold(
            backgroundColor: Colors.blue,
          ),
        ),
        ...List.generate(
            graph.lenght,
            (i) => Positioned(
                top: graph[i].location.y - 20,
                left: graph[i].location.x - 20,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => selectNode(graph[i]),
                  onDoubleTap: () => deleteNode(graph[i]),
                  child: Container(
                    child: Center(
                        child: Text(
                      graph[i].id.toString(),
                      textAlign: TextAlign.center,
                    )),
                    decoration: BoxDecoration(
                      color: graph[i].isSelected ? Colors.grey : Colors.purple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ))),
      ],
    );
  }
}
