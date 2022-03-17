import 'package:sthep/model/painter/painter.dart';
import 'package:sthep/model/user/user.dart';

class Answer {
  late User answerer;
  late Painter? painter;

  bool adopted = false;

  Answer({required this.answerer,});

  void adopt() => adopted = true;
}