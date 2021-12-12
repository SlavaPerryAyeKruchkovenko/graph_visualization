import 'package:flutter/cupertino.dart';
import 'package:graph_flutter_visualization/services/my_drawer.dart';
import 'package:graph_logic/graph_logic.dart';

// ignore: must_be_immutable
class EdgeWidget extends StatefulWidget {
  Edge<num> edge;
  EdgeWidget(this.edge, {Key? key}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<EdgeWidget> createState() => _EdgeWidget(edge);
}

class _EdgeWidget extends State<EdgeWidget> {
  Edge<num> edge;
  _EdgeWidget(this.edge);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constrains) {
        return CustomPaint(
            painter: MyDrawer(edge: edge),
            size: Size(constrains.maxWidth, constrains.maxHeight));
      },
    );
  }
}
