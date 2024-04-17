// import 'package:flutter/material.dart';

// void main() {
//   runApp(MindMapApp());
// }

// class MindMapApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Mind Map'),
//         ),
//         body: MindMap(),
//       ),
//     );
//   }
// }

// class MindMap extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         child: CustomPaint(
//           painter: MindMapPainter(),
//           size: Size(400, 400),
//         ),
//       ),
//     );
//   }
// }

// class MindMapPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint linePaint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 5.0
//       ..style = PaintingStyle.stroke;

//     // Draw connections between nodes
//     drawCurveLine(canvas, Offset(200, 0), Offset(100, 200), linePaint);
//     drawCurveLine(canvas, Offset(200, 0), Offset(300, 200), linePaint);
//     drawCurveLine(canvas, Offset(200, 0), Offset(-100, 200), linePaint);
//     drawCurveLine(canvas, Offset(200, 0), Offset(500, 200), linePaint);

//     // Draw nodes
//     _drawNode(canvas, Offset(200, 0), "Root");
//     _drawNode(canvas, Offset(100, 200), "Child 1xxxxxxxxxxxxxxxxxxxxxxxxxxxx");
//     _drawNode(canvas, Offset(300, 200), "Child 2");
//     _drawNode(canvas, Offset(-100, 200), "Child 3");
//     _drawNode(canvas, Offset(500, 200), "Child 4");
//   }

//   void _drawNode(Canvas canvas, Offset position, String text) {
//     Paint nodePaint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;

//     Paint textPaint = Paint()..color = Colors.white;

//     double nodeRadius = 40.0;

//     // Draw node circle
//     canvas.drawCircle(position, nodeRadius, nodePaint);

//     // Draw text inside the node
//     TextSpan span = TextSpan(
//       text: text,
//       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//     );

//     TextPainter tp = TextPainter(
//       text: span,
//       textAlign: TextAlign.center,
//       textDirection: TextDirection.ltr,
//     );

//     tp.layout();
//     tp.paint(canvas,
//         Offset(position.dx - (tp.width / 2), position.dy - (tp.height / 2)));
//   }

//   void drawCurveLine(Canvas canvas, Offset start, Offset end, Paint paint) {
//     double distanceX = (end.dx - start.dx).abs();
//     double distanceY = (end.dy - start.dy).abs();

//     // Calculate half the vertical distance between the nodes
//     double halfVerticalDistance = distanceY / 2;

//     // Define control points
//     double controlPoint1X = start.dx;
//     double controlPoint1Y = start.dy +
//         halfVerticalDistance; // Move downward with half vertical distance

//     double controlPoint2X = end.dx;
//     double controlPoint2Y = start.dy +
//         halfVerticalDistance; // Move horizontally to the top of target node

//     // Draw curve line using cubic Bezier curve
//     final Path path = Path();
//     path.moveTo(start.dx + 0, start.dy + 40);
//     path.cubicTo(
//       controlPoint1X,
//       controlPoint1Y,
//       controlPoint2X,
//       controlPoint2Y,
//       end.dx,
//       end.dy - 40,
//     );

//     // Draw the path
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(MindMapApp());
}

class MindMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mind Map'),
        ),
        body: MindMap(),
      ),
    );
  }
}

class Node {
  final String text;
  final List<Node> children;

  Node({required this.text, this.children = const []});
}

class FinalNode {
  final String text;
  final List<Node> children;
  final Offset offset;
  final TextPainter painter;

  FinalNode(
      {required this.text,
      this.children = const [],
      required this.offset,
      required this.painter});
}

class MindMap extends StatefulWidget {
  const MindMap({super.key});

  @override
  MindMapState createState() => MindMapState();
}

class MindMapState extends State<MindMap> {
  late List<Node> nodes;
  late double _halfMediaWidth;
  // Add a GlobalKey
  final GlobalKey _containerKey = GlobalKey();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nodes = [
      Node(text: "Root", children: [
        Node(
          text: "Child 1xxxxxxxxxxxxx",
        ),
        Node(text: "Child 2", children: [
          Node(text: "Child 5"),
          Node(text: "Child 6"),
          Node(text: "Child 14"),
        ]),
        Node(text: "Child 3"),
        Node(text: "Child 4"),
        Node(text: "Child 7"),
        Node(text: "Child 8"),
        Node(text: "Child 9"),
        Node(text: "Child 10"),
        Node(text: "Child 11"),
        Node(text: "Child 12"),
        Node(text: "Child 13"),
      ]),
    ];

    return Padding(
        padding: EdgeInsets.zero,
        child: Center(
          child: Container(
            key: _containerKey,
            alignment: Alignment.topCenter,
            child: CustomPaint(
              painter: MindMapPainter(
                  nodes: nodes,
                  mediaWidth: MediaQuery.of(context).size.width,
                  containerKey: _containerKey),
              //size: Size(400, 400),
            ),
          ),
        ));
  }
}

class MindMapPainter extends CustomPainter {
  final List<Node> nodes;
  final double mediaWidth;
  final GlobalKey containerKey;

  MindMapPainter(
      {required this.nodes,
      required this.mediaWidth,
      required this.containerKey});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isNotEmpty) {
      _drawNode(canvas, nodes, const Offset(0, 0));
    }
  }

  Offset _calculateCoordinate(
    Node node,
    String? direction,
    double nodeWidth,
    double nodeHeight,
    double parentDy,
    double xOffset,
  ) {
    Offset offset = const Offset(0, 0);
    final containerContext = containerKey.currentContext;
    // if (containerContext != null) {
    //   final RenderBox containerRenderBox =
    //       containerContext.findRenderObject() as RenderBox;
    //   final containerPosition = containerRenderBox.localToGlobal(Offset.zero);
    if (direction == null || direction == 'right' && parentDy != 0) {
      offset = Offset(
        //containerPosition.dx -
        nodeWidth / 2 + xOffset,
        //containerPosition.dy -
        parentDy + 100 - nodeHeight / 2,
      );
    } else if (direction == 'left') {
      offset = Offset(
        //containerPosition.dx -
        nodeWidth / 2 - xOffset,
        //containerPosition.dy -
        parentDy + 100 - nodeHeight / 2,
      );
    } else {
      offset = Offset(
        //containerPosition.dx -
        nodeWidth / 2 - (xOffset / 2),
        //containerPosition.dy -
        parentDy + 100 - nodeHeight / 2,
      );
    }
    ;

    // }
    return offset;
  }

  List<FinalNode> _setNodeListCoordinate(
      Canvas canvas, List<Node> nodeList, Offset parentOffset) {
    List<TextPainter> spanList = [];

    for (Node node in nodeList) {
      TextSpan span = TextSpan(
        text: node.text,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      );

      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      tp.layout();
      spanList.add(tp);
    }

    List<String> directionList = _generatePositionList(nodeList);
    List<Offset> offsetList = [];
    double gap = 20;
    double dx = 0;

    dx = parentOffset.dx;

    for (int i = 0; i < directionList.length; i++) {
      if (directionList[i] != "left") {
        break;
      } else {
        dx += spanList[i].width + 20;
        if (i == directionList.length - 1) {
          if (directionList[i].length % 2 == 0) {
            dx += gap / 2;
          } else {
            dx += gap;
          }
        } else {
          dx += gap;
        }
      }
    }

    if (directionList.length == nodeList.length) {
      bool check = false;
      for (int i = 0; i < nodeList.length; i++) {
        if (!check) {
          if (directionList[i] != "left" && !directionList.contains("null")) {
            check = true;
            dx = gap / 2;
          } else if (directionList[i] != "left" &&
              directionList.contains("null") &&
              directionList.length > 1) {
            check = true;
            dx = gap;
          }
        } else if (directionList[i] == "right") {
          dx += gap;
        } else if (directionList[i] == "null") {
          dx = spanList[i].width / 2 + 20;
        }

        double xOffset = spanList[i].width + 20;
        offsetList.add(_calculateCoordinate(nodeList[i], directionList[i],
            xOffset, spanList[i].height + 20, parentOffset.dy, dx));

        if (directionList[i] == "left") {
          dx -= (xOffset + gap);
        } else if (directionList[i] == "right") {
          dx += (xOffset + gap);
        } else if (directionList[i] == "null" && directionList.length > 1) {
          dx += (xOffset / 2 + gap);
        }
      }
    }

    List<FinalNode> _completedNodeList = [];

    if (directionList.length == nodeList.length &&
        nodeList.length == spanList.length &&
        offsetList.length == spanList.length) {
      for (int i = 0; i < directionList.length; i++) {
        _completedNodeList.add(FinalNode(
            text: nodeList[i].text,
            offset: offsetList[i],
            painter: spanList[i],
            children: nodeList[i].children));
      }
    }

    return _completedNodeList;
  }

  List<String> _generatePositionList(List<Node> nodeList) {
    // Calculate the half length of the original list
    int halfLength = (nodeList.length / 2).ceil();

    // Create a new list to store the generated values
    List<String> newList = [];
    // Iterate through the elements of the original list
    for (int i = 0; i < nodeList.length; i++) {
      if (i + 1 == halfLength && nodeList.length % 2 != 0) {
        newList.add('null');
      }
      // Check if the index is less than half length
      else if (i + 1 <= halfLength) {
        // Add 'left' to the new list if the condition is met
        newList.add('left');
      } else {
        // Add 'right' to the new list if the condition is not met
        newList.add('right');
      }
    }
    return newList;
  }

  List<FinalNode> _drawNode(Canvas canvas, List<Node> nodeList, Offset offset) {
    List<FinalNode> finalNodeList =
        _setNodeListCoordinate(canvas, nodeList, offset);

    final Paint nodePaint = Paint()
      ..color = const Color.fromRGBO(33, 150, 243, 1)
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    final Paint textPaint = Paint()..color = Colors.white;

    for (FinalNode node in finalNodeList) {
      double rectangleWidth = node.painter.width + 20;
      double rectangleHeight = node.painter.height + 20;
      // Draw node rectangle
      canvas.drawRect(
        Rect.fromCenter(
          center: node.offset,
          width: rectangleWidth,
          height: rectangleHeight,
        ),
        nodePaint,
      );

      // Draw text inside the node
      node.painter.paint(
        canvas,
        Offset(
          node.offset.dx - (node.painter.width / 2),
          node.offset.dy - (node.painter.height / 2),
        ),
      );

      if (node.children.isNotEmpty) {
        int i = 0;
        List<FinalNode> childFinalNodeList = [];
        childFinalNodeList = _drawNode(canvas, node.children, node.offset);
        print(node.offset);

        for (FinalNode childNode in childFinalNodeList) {
          drawCurveLine(canvas, node.offset, childNode.offset, linePaint,
              rectangleWidth / 2, rectangleHeight / 2);

          i++;
        }
        i = 0;
      }
    }

    return finalNodeList;
  }

  void drawCurveLine(Canvas canvas, Offset start, Offset end, Paint paint,
      double nodeWidth, double nodeHeight) {
    double distanceX = (end.dx - start.dx).abs();
    double distanceY = (end.dy - start.dy).abs();

    // Calculate half the vertical distance between the nodes
    double halfVerticalDistance = distanceY / 2;

    // Define control points
    double controlPoint1X = start.dx;
    double controlPoint1Y = start.dy +
        halfVerticalDistance; // Move downward with half vertical distance

    double controlPoint2X = end.dx;
    double controlPoint2Y = start.dy +
        halfVerticalDistance; // Move horizontally to the top of target node

    // Draw curve line using cubic Bezier curve
    final Path path = Path();
    path.moveTo(start.dx + 0, start.dy + nodeHeight);
    path.cubicTo(
      controlPoint1X,
      controlPoint1Y,
      controlPoint2X,
      controlPoint2Y,
      end.dx,
      end.dy - nodeHeight,
    );

    // Draw the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
