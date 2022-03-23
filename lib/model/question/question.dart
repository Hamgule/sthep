import 'package:flutter/cupertino.dart';
import 'package:sthep/model/question/category.dart';
import 'package:sthep/model/painter/painter.dart';
import 'package:sthep/model/question/answer.dart';
import 'package:sthep/model/user/user.dart';

class Question {
  /// variables
  static DateTime regDate = DateTime.now();
  late int id;
  late String title;
  late User questioner;
  late Category category;
  Widget? image;
  Painter? painter;
  List answers = <Answer>[];
  int indexOfAdoptedAnswer = -1;

  /// constructor
  Question({
    required this.id,
    required this.title,
    required this.questioner,
    this.image,
    // required this.category,
  });

  /// methods
  void adopt(int n) {
    if (answers.length <= n) return;
    answers[n].adopt();
  }
}

class Questions {
  List list = <Question>[];

  Question? getById(int id) {
    for (Question q in list) {
      if (id == q.id) return q;
    }
    return null;
  }
  User? whose(int id) => getById(id)?.questioner;
}