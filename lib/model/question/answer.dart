import 'package:sthep/model/painter/painter.dart';

class Answer {
  late int id;
  late String answererUid;
  late String questionId;

  Painter? painter;
  bool adopted = false;

  Answer({
    required this.id,
    required this.answererUid,
    required this.questionId,
  });

  void adopt() => adopted = true;
}