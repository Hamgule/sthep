import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

class Answer {
  late int id;
  late String answererUid;
  late int questionId;

  DateTime? regDate = DateTime.now();
  DateTime? modDate = DateTime.now();
  String? imageUrl;

  bool adopted = false;

  late SthepUser answerer;

  Answer();

  void adopt() => adopted = true;

  Answer.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    answererUid = data['answererUid'];
    adopted = data['adopted'];
    regDate = (data['regDate'] ?? Timestamp.now()).toDate();
    modDate = (data['modDate'] ?? Timestamp.now()).toDate();
    imageUrl = data['imageUrl'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'answererUid': answererUid,
    'adopted': adopted,
    'regDate': regDate,
    'modDate': modDate,
    'imageUrl': imageUrl,
  };

  String aidToString() => Question.idToString(id);
}