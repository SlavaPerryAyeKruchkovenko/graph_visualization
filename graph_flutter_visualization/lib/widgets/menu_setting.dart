import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Menu extends StatefulWidget {
  final Function() depthSearch;
  Function() breadthSearch;
  Menu({
    Key? key,
    required this.depthSearch,
    required this.breadthSearch,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Menu();
}

class _Menu extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 60.0),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: widget.depthSearch,
              icon: const Icon(Icons.swap_vert),
              color: Colors.white,
              highlightColor: Colors.pink,
            ),
            IconButton(
              onPressed: widget.breadthSearch,
              icon: const Icon(Icons.swap_horiz),
              color: Colors.white,
              highlightColor: Colors.pink,
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.cloud_upload),
              color: Colors.white,
              highlightColor: Colors.pink,
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.cloud_download),
              color: Colors.white,
              highlightColor: Colors.pink,
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.closed_caption),
              color: Colors.white,
              highlightColor: Colors.pink,
            ),
          ],
        ));
  }
}
