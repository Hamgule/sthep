import 'dart:io';

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

  void addQuestion(Question q) async {
    int index = questions.indexWhere((e) => e.id == q.id);
    if (index >= 0) questions.removeAt(index);
    index = index < 0 ? 0 : index;
    questions.insert(index, q);
    // questions.add(q);
  }

  Question getQuestionById(int id) {
    return questions.where((e) => e.id == id).toList().first;
  }

  List<Question> getQuestionsByUserID(String uid) {
    return questions.where((e) => e.questionerUid == uid).toList();
  }

  /// Home
  bool isGrid = true;

  void toggleGrid() {
    isGrid = !isGrid;
    notifyListeners();
  }

  late Question newQuestion;
  Question? destQuestion;

  /// upload
  File? image;
  bool imageUploading = false;

  void toggleUploadingState() {
    imageUploading = !imageUploading;
    notifyListeners();
  }

}