import 'package:cloud_firestore/cloud_firestore.dart';

class MyNotification {
  bool checked = false;
  int? id;
  String? type;
  int? questionId;
  String? questionTitle;
  String? notice;
  DateTime? loggedDate;

  MyNotification({
    this.id,
    this.type,
    this.questionId,
    this.questionTitle,
    this.notice,
    this.loggedDate,
  });

  void check() => checked = true;

  MyNotification.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    checked = data['checked'];
    type = data['type'];
    questionId = data['questionId'];
    questionTitle = data['questionTitle'];
    notice = data['notice'];
    loggedDate = (data['loggedDate'] ?? Timestamp.now()).toDate();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'checked': checked,
    'type': type,
    'questionId': questionId,
    'questionTitle': questionTitle,
    'notice': notice,
    'loggedDate': loggedDate,
  };
}