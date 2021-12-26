import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:graph_flutter_visualization/models/node_state.dart';
import 'package:graph_flutter_visualization/services/converter.dart';
import 'package:graph_flutter_visualization/widgets/dialog_ui.dart';
import 'package:graph_flutter_visualization/widgets/menu_setting.dart';
import 'package:graph_flutter_visualization/widgets/node_widget.dart';
import 'package:graph_flutter_visualization/widgets/subtitles.dart';
import 'package:graph_logic/graph_logic.dart';
import 'edge_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'message_box.dart';
import 'dart:html' as html;

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
  String _subtitles = "";
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
    var url = "C:\\Users\\Slava\\Downloads";
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
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
            var tuple = text.convertToGraph(false);
            graph = tuple.item1;
            map = tuple.item2;
            for (var node in graph.nodes) {
              _nodes.add(NodeWidget(
                map[node]!,
                graph: graph,
                node: node,
                addEdge: _addEdge,
                changeLoc: _changeLoc,
              ));
            }
            for (var edge in graph.edges) {
              _edges.add(EdgeWidget(
                  edge: edge,
                  graph: graph,
                  to: map[edge.to]!,
                  from: map[edge.from]!));
            }
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
              var tuple = text.convertToGraph(false);
              graph = tuple.item1;
              map = tuple.item2;
            });
          } else if (file.path.contains(".json")) {
            //more
          }
        } finally {}
      }
    }
  }

  _graphBypass(Function(Node<num>) action) {
    if (_nodes.any((node) => node.stateNow.state == ObjectState.select) &&
        !_isRun) {
      var node = _nodes
          .where((node) => node.stateNow.state == ObjectState.select)
          .first
          .node;
      action.call(node);
      NodeWidget.selectedNodes.clear();
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
        _printText("\n Посешаем вершину ${node.id}",
            anotherFucntion: () => _nodes
                .where((node2) => node2.node.id == node.id)
                .first
                .stateNow
                .changeState(ObjectState.select));
        _subtitles = "Visiting node number ${node.id}";
        path.add(node);
        await Future.delayed(const Duration(milliseconds: 1000));
        _printText(
            "\n\n находим вершины ${_toString(node.incidentNodes)} добаляем их в stack",
            anotherFucntion: () => _nodes
                .where((node2) => node2.node.id == node.id)
                .first
                .stateNow
                .changeState(ObjectState.passed));

        await Future.delayed(const Duration(milliseconds: 1000));
        for (var incidentNode in node.incidentNodes) {
          stack.addLast(incidentNode);
        }
        var arr = _toString(stack);
        _printText("\n\n stack сейчас имеет вершины: $arr ");
        setState(() {
          _subtitles = "Stack have $arr";
        });
        await Future.delayed(const Duration(milliseconds: 1000));
      } else {
        _printText("\n мы ее уже посешали");
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    var arr = _toString(path);
    _printText("\n конечный путь :$arr", anotherFucntion: () {
      _subtitles = "finally path $arr";
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _subtitles = "";
      for (var node in _nodes) {
        node.stateNow.changeState(ObjectState.basic);
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
                .stateNow
                .changeState(ObjectState.select));
        _subtitles = "Visiting node number ${node.id}";
        path.add(node);
        await Future.delayed(const Duration(milliseconds: 1000));
        _printText(
            "\n\nНаходим вершины ${_toString(node.incidentNodes)} помешаем их в очередь",
            anotherFucntion: () => _nodes
                .where((node2) => node2.node.id == node.id)
                .first
                .stateNow
                .changeState(ObjectState.passed));
        await Future.delayed(const Duration(milliseconds: 1000));
        for (var incidentNode in node.incidentNodes) {
          queue.add(incidentNode);
        }
        var arr = _toString(queue);
        _printText("\n\n очередь сейчас имеет вершины: $arr ");
        setState(() {
          _subtitles = "Queue have $arr";
        });
        await Future.delayed(const Duration(milliseconds: 1000));
      } else {
        _printText("\n мы ее уже посешали");
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    var arr = _toString(path);
    _printText("\n конечный путь :$arr", anotherFucntion: () {
      _subtitles = "finally path $arr";
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _subtitles = "";
      for (var node in _nodes) {
        node.stateNow.changeState(ObjectState.basic);
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
          node.stateNow.changeState(ObjectState.basic);
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
      _showAlertDialog(
          context, "this is edge is exist, please delete and make new");
      setState(() {
        for (var node in _nodes) {
          node.stateNow.changeState(ObjectState.basic);
        }
        callback(null);
      });
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
        ),
        _needSubtitles ? Subtitles(text: _subtitles) : const Text(""),
      ],
    );
  }
}
