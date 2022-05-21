import 'package:flutter/material.dart';
import 'package:sthep/model/question/question.dart';

late Size screenSize;

class Materials with ChangeNotifier {

  List<Question> questions = [];

  void addQuestion(Question q) {
    questions.add(q);
    // notifyListeners();
  }

  bool isGrid = true;

  // Homepage
  void toggleGrid() {
    isGrid = !isGrid;
    notifyListeners();
  }
}