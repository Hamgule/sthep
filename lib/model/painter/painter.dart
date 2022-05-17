import 'package:sthep/model/painter/dot.dart';
import 'package:sthep/model/painter/history.dart';
import 'package:flutter/material.dart';

class Painter {

  /// variables
  List<List<Dot>> lines = [];
  final histories = History();

  double size = 2.0;
  Color color = Colors.black;
  bool eraseMode = false;

  /// getters
  List<List<Dot>> get allLines {
    List<List<Dot>> _lines = [];
    for (List<Dot> line in lines) {
      _lines.add(line);
    }
    return _lines;
  }

  /// methods
  void drawStart(Offset offset) {
    List<Dot> _line = [];
    _line.add(Dot(
      offset: Offset(offset.dx, offset.dy),
      color: Colors.black,
      size: 2.0,
    ));

    lines.add(_line);
  }

  void drawing(Offset offset) {
    Dot _dot = Dot(
      offset: Offset(offset.dx, offset.dy),
      color: Colors.black,
      size: 2.0,
    );
    lines.last.add(_dot);
  }

  void drawEnd() {
    histories.addHistory(lines);
  }

  void erase(Offset offset) {
    // const eraserSize = 15.0;

    // for (int i = lines.length; i > 0; i--) {
    //   for (Dot dot in lines[i - 1]) {
    //     if (sqrt(pow(offset.dx * imageSize.width - dot.offset.dx * imageSize.width, 2)
    //         + pow(offset.dy * imageSize.height - dot.offset.dy * imageSize.height, 2)) < eraserSize) {
    //       lines.remove(lines[i - 1]);
    //       histories.addHistory(lines);
    //       break;
    //     }
    //   }
    // }
  }

  void eraseAll() {
    lines = [];
    histories.addHistory(lines);
  }

  void undo() {
    List<dynamic> _past = histories.getPast();
    lines = [..._past];
  }
  void redo() {
    List<dynamic> _future = histories.getFuture();
    lines = [..._future];
  }

}