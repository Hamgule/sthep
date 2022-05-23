import 'package:flutter/material.dart';
import 'package:sthep/model/question/question.dart';

late Size screenSize;

class Materials with ChangeNotifier {

  /// main
  int pageIndex = 0;
  int newPageIndex = 0;

  void setPageIndex(int index) {
    newPageIndex = index;
    if (index < 5) pageIndex = newPageIndex;
    notifyListeners();
  }

  ///
  List<Question> questions = [];

  Question getQuestionById(int id) {
    return questions.where((e) => e.id == id).toList().first;
  }

  /// Home
  bool isGrid = true;

  void toggleGrid() {
    isGrid = !isGrid;
    notifyListeners();
  }

  /// Upload
  late String title;
  List<String> tags = [];

}