<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

This package include classes describing logic of graph. 

## Features

You can create oriented or unoriented grpaph. grapgh can work only with num's types.

## Getting started

Graph has static method which helps to create graph.

## Usage
```dart
var list = [0, 1, 2, 3, 4];
  var nodes = list.map((e) => Node(e)).toList();
  List<Tuple<Node<int>, Node<int>>> incedentNodes = [
    Tuple(nodes[0], nodes[1]),
    Tuple(nodes[0], nodes[2]),
    Tuple(nodes[1], nodes[3]),
    Tuple(nodes[1], nodes[4]),
    Tuple(nodes[2], nodes[3]),
    Tuple(nodes[3], nodes[4]),
  ];
  var values = [11, 2, 3, 4, 5, 6];
  var graph = Graph.makeGraph<int>(incedentNodes, values, isOriented: false);
```

you can get link table of node's link
```dart
var table = graph.linkTable;
```
example of link table the code above

0:
0 11 2 100000 100000
1: 
11 0 100000 3 4 
2: 
2 100000 0 5 100000 
3: 
100000 3 5 0 6
4: 
100000 4 100000 6 0

## Additional information

this package was created for training purposes.
