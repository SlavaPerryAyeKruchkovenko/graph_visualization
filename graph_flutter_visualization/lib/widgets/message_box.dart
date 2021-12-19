import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessangeBox extends StatelessWidget {
  final String text;
  const MessangeBox({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Warning", style: TextStyle(color: Colors.white)),
        content: Text(text, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        elevation: 24.0,
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))));
  }
}
