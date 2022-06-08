import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

class Answer {
  int? id;
  late String answererUid;
  int? questionId;
  DateTime? regDate = DateTime.now();
  DateTime? modDate = DateTime.now();
  String? imageUrl;

  bool adopted = false;

  late SthepUser answerer;

  Answer({
    required this.answerer,
    required this.answererUid,
  });

  void adopt() => adopted = true;

  Answer.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answererUid = json['answererUid'];
    adopted = json['adopted'];
    regDate = (json['regDate'] ?? Timestamp.now()).toDate();
    modDate = (json['modDate'] ?? Timestamp.now()).toDate();
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'answererUid': answererUid,
    'adopted': adopted,
    'regDate': regDate,
    'modDate': modDate,
    'imageUrl': imageUrl,
  };

  String aidToString() => Question.idToString(id!);

  Future<int> getNextId() async {
    Map<String, dynamic>? data = await MyFirebase.readData('autoIncrement', 'answer');
    return data!['currentId'] + 1;
  }

  void createDB() async {
    Map<String, dynamic> json = toJson();

    json['regDate'] = FieldValue.serverTimestamp();
    json['modDate'] = FieldValue.serverTimestamp();

    MyFirebase.write('answers', aidToString(), json);
    MyFirebase.write('autoIncrement', 'answer', {'currentId': id});
  }

  void updateDB({bool updateModDate = false}) {
    Map<String, dynamic> json = toJson();
    if (updateModDate) json['modDate'] = FieldValue.serverTimestamp();
    MyFirebase.write('answers', aidToString(), json);
  }
  void deleteDB() => MyFirebase.remove('answers', aidToString());
}