import 'package:sthep/model/painter/painter.dart';

class Answer {
  late int id;
  late String answererUid;
  late int questionId;

  Painter? painter;
  bool adopted = false;

  Answer({
    required this.id,
    required this.answererUid,
    required this.questionId,
  });

  void adopt() => adopted = true;

  Answer.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    answererUid = data['answererUid'];
    questionId = data['questionId'];
    adopted = data['adopted'];
  }
}