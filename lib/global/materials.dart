import 'package:flutter/material.dart';
import 'package:sthep/model/question/question.dart';

late Size screenSize;

class Materials with ChangeNotifier {

  /// upload
  int pageIndex = 0;
  int newPageIndex = 0;

  void setPageIndex(int index) {
    newPageIndex = index;
    if (index < 5) pageIndex = newPageIndex;
    notifyListeners();
  }

  ///
  List<Question> questions = [];

  void addQuestion(Question q) {
    questions.add(q);
    // notifyListeners();
  }

  /// Home
  bool isGrid = true;

  void toggleGrid() {
    isGrid = !isGrid;
    notifyListeners();
  }
}