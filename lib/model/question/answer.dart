import 'package:sthep/model/painter/painter.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

class Answer {
  late int id;
  late User answerer;
  late Painter? painter;
  late Question question;

  bool adopted = false;

  Answer({required this.id, required this.answerer, required this.question});

  void adopt() => adopted = true;
}