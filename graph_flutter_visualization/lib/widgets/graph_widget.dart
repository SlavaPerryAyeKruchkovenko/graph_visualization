import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graph_flutter_visualization/models/node_state.dart';
import 'package:graph_flutter_visualization/services/converter.dart';
import 'package:graph_flutter_visualization/widgets/dialog_ui.dart';
import 'package:graph_flutter_visualization/widgets/menu_setting.dart';
import 'package:graph_flutter_visualization/widgets/node_widget.dart';
import 'package:graph_logic/graph_logic.dart';
import 'edge_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'message_box.dart';

class GraphWidget extends StatefulWidget {
  const GraphWidget({Key? key}) : super(key: key);
  @override
  State<GraphWidget> createState() => _GraphWidget();
}

class _GraphWidget extends State<GraphWidget> {
  var graph = Graph<num>.def(false);
  double posx = 0;
  double posy = 0;
  String debugText = "";
  final List<NodeWidget> _nodes = [];
  List<EdgeWidget> _edges = [];
  bool _isRun = false;
  bool _needSubtitles = false;
  Map<Node<num>, Point> map = {};

  _onTapDown(BuildContext context, TapDownDetails details) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    final Offset localOffset = box!.globalToLocal(details.globalPosition);
    var node = Node<num>(0);
    posx = localOffset.dx;
    posy = localOffset.dy;
    var point = Point(posx, posy);
    setState(() {
      map[node] = point;
      graph.addNode(node);
      _nodes.add(NodeWidget(
        map[node]!,
        node: node,
        graph: graph,
        addEdge: _addEdge,
        callback: callback,
        changeLoc: _changeLoc,
      ));
    });
  }

  callback(changeObj) {
    setState(() {
      if (changeObj is Node<num>) {
        _edges = _edges
            .where((x) => !changeObj.incidentEdges.contains(x.edge))
            .toList();
        _nodes.remove(_nodes.where((widget) => widget.node == changeObj).first);
        map.remove(changeObj);
      } else if (changeObj is Edge<num>) {
        _edges.remove(_edges.where((widget) => widget.edge == changeObj).first);
      } else {
        deactivate();
      }
    });
  }

  _changeLoc(Node<num> node, loc) {
    map[node] = loc;
    setState(() {
      _edges = _edges
          .where((x) => x.edge.to != node && x.edge.from != node)
          .toList();

      for (var edge in node.incidentEdges) {
        _edges.add(EdgeWidget(
            edge: edge,
            graph: graph,
            callback: callback,
            to: map[edge.to]!,
            from: map[edge.from]!));
      }
    });
  }

  _showAlertDialog(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessangeBox(text: text);
        });
  }

  _showSettingsPanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Menu(
            depthSearch: () => _graphBypass(_depthSearch),
            breadthSearch: () => _graphBypass(_breadthSearch),
            openSubtitles: () => _openSubtitles(),
            saveFile: () => _saveFile(),
            uploadFile: () => _uploadFile(),
          );
        });
  }

  _openSubtitles() {
    setState(() {
      _needSubtitles = !_needSubtitles;
    });
  }

  _saveFile() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'output-file.pdf',
    );
    if (outputFile == null) {
      // User canceled the picker
    }
  }

  _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (kIsWeb) {
      if (result != null) {
        try {
          var fileBytes = result.files.first.bytes;
          var text = utf8.decode(fileBytes!);
          debugPrint(text);
          setState(() {
            graph = text.convertToGraph(false);
          });
        } finally {}
      }
    } else {
      if (result != null) {
        try {
          File file = File(result.files.single.path!);
          if (file.path.contains(".txt") || file.path.contains(".docx")) {
            var text = await file.readAsString();
            setState(() {
              graph = text.convertToGraph(false);
            });
          } else if (file.path.contains(".json")) {
            //more
          }
        } finally {}
      }
    }
  }

  _graphBypass(Function(Node<num>) action) {
    if (_nodes.any((node) => node.state == ObjectState.select) && !_isRun) {
      action.call(
          _nodes.where((node) => node.state == ObjectState.select).first.node);
    } else {
      _showAlertDialog(context, "You don't select node.");
    }
  }

  _printText(text, {Function()? anotherFucntion}) {
    debugPrint(text);
    setState(() {
      if (anotherFucntion != null) {
        anotherFucntion.call();
      }
      debugText += text;
    });
  }

  String _toString(Iterable nodes) {
    var text = "";
    for (var node in nodes.map((x) => x.id.toString())) {
      text += " $node";
    }
    return text;
  }

  _depthSearch(Node<num> startNode) async {
    List<Node<num>> path = [];
    setState(() {
      _isRun = true;
    });
    var visited = HashSet<Node<num>>();
    ListQueue<Node<num>> stack = ListQueue();
    stack.addLast(startNode);
    while (stack.isNotEmpty) {
      var node = stack.removeLast();
      _printText("\n Выбираем вершину ${node.id}");
      if (!visited.contains(node)) {
        visited.add(node);
        path.add(node);
        _printText("\n Посешаем вершину ${node.id}",
            anotherFucntion: () => _nodes
                .where((node2) => node2.node.id == node.id)
                .first
                .state = ObjectState.select);
        await Future.delayed(const Duration(milliseconds: 1000));
        _printText(
            "\n\n находим вершины ${_toString(node.incidentNodes)} добаляем их в stack",
            anotherFucntion: () => _nodes
                .where((node2) => node2.node.id == node.id)
                .first
                .state = ObjectState.passed);

        await Future.delayed(const Duration(milliseconds: 1000));
        for (var incidentNode in node.incidentNodes) {
          stack.addLast(incidentNode);
        }
        _printText("\n\n stack сейчас имеет вершины: ${_toString(stack)} ");
      } else {
        _printText("\n мы ее уже посешали");
      }
    }
    _printText("\n конечный путь :${_toString(path)}", anotherFucntion: () {
      for (var node in _nodes) {
        node.state = ObjectState.basic;
      }
      _isRun = false;
    });
  }

  _breadthSearch(Node<num> startNode) async {
    List<Node<num>> path = [];
    setState(() {
      _isRun = true;
    });
    var visited = HashSet<Node<num>>();
    var queue = Queue<Node<num>>();
    queue.add(startNode);
    while (queue.isNotEmpty) {
      var node = queue.first;
      _printText("\n Выбираем вершину ${node.id}");
      queue.removeFirst();
      if (!visited.contains(node)) {
        visited.add(node);
        _printText("\n Посешаем вершину ${node.id}",
            anotherFucntion: () => _nodes
                .where((node2) => node2.node.id == node.id)
                .first
                .state = ObjectState.select);
        path.add(node);
        await Future.delayed(const Duration(milliseconds: 1000));
        _printText(
            "\n\nНаходим вершины ${_toString(node.incidentNodes)} помешаем их в очередь",
            anotherFucntion: () => _nodes
                .where((node2) => node2.node.id == node.id)
                .first
                .state = ObjectState.passed);
        await Future.delayed(const Duration(milliseconds: 1000));
        for (var incidentNode in node.incidentNodes) {
          queue.add(incidentNode);
        }
        _printText("\n\n очередь сейчас имеет вершины: ${_toString(queue)} ");
      } else {
        _printText("\n мы ее уже посешали");
        Future.delayed(const Duration(milliseconds: 500));
      }
    }
    _printText("\n конечный путь :${_toString(path)}", anotherFucntion: () {
      for (var node in _nodes) {
        node.state = ObjectState.basic;
      }
      _isRun = false;
    });
  }

  _addEdge(Node<num> node1, Node<num> node2) async {
    if (graph.isOriented
        ? !graph.edges.any((node) => node.from == node1 && node.to == node2)
        : !graph.edges.any((node) =>
            (node.from == node1 || node.from == node2) &&
            (node.to == node2 || node.to == node1))) {
      final value = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DialogForm(),
          ));

      setState(() {
        for (var node in _nodes) {
          node.state = ObjectState.basic;
        }
        var edge = graph.connect(node1, node2, value);
        _edges.add(EdgeWidget(
            edge: edge,
            graph: graph,
            callback: callback,
            to: map[edge.to]!,
            from: map[edge.from]!));
      });
    } else {
      setState(() {
        for (var node in _nodes) {
          node.state = ObjectState.basic;
        }
      });

      _showAlertDialog(
          context, "this is edge is exist, please delete and make new");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTapDown: (TapDownDetails details) => _onTapDown(context, details),
          child: const Scaffold(
            backgroundColor: Colors.blue,
          ),
        ),
        _needSubtitles
            ? Positioned(
                left: 0,
                top: 0,
                child: Container(
                    color: Colors.white,
                    width: 800,
                    height: 200,
                    child: Expanded(
                      child: SingleChildScrollView(
                        dragStartBehavior: DragStartBehavior.down,
                        scrollDirection: Axis.vertical, //.horizontal
                        child: Text(
                          debugText,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )))
            : const Text(""),
        ..._nodes,
        ..._edges,
        Positioned(
          child: TextButton(
              onPressed: _showSettingsPanel,
              child: const Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )),
          bottom: 0,
        )
      ],
    );
  }
}
