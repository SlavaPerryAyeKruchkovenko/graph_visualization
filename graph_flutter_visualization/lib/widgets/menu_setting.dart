import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final Function() depthSearch;
  final Function() breadthSearch;
  final Function() saveFile;
  final Function() uploadFile;
  final Function() openSubtitles;
  const Menu({
    Key? key,
    required this.depthSearch,
    required this.breadthSearch,
    required this.saveFile,
    required this.uploadFile,
    required this.openSubtitles,
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
              onPressed: widget.uploadFile,
              icon: const Icon(Icons.cloud_upload),
              color: Colors.white,
              highlightColor: Colors.pink,
            ),
            IconButton(
              onPressed: widget.saveFile,
              icon: const Icon(Icons.cloud_download),
              color: Colors.white,
              highlightColor: Colors.pink,
            ),
            IconButton(
              onPressed: widget.openSubtitles,
              icon: const Icon(Icons.closed_caption),
              color: Colors.white,
              highlightColor: Colors.pink,
            ),
          ],
        ));
  }
}
