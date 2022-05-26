import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/model/painter/painter.dart';
import 'package:sthep/model/user/user.dart';

class Question {
  /// variables
  late int id;
  late String title;
  late String questionerUid;
  DateTime? regDate = DateTime.now();

  List<String> tags = [];
  List<int> answerIds = [];

  Painter? painter;
  String? imageUrl;
  int? adoptedAnswerId;

  /// constructor
  Question({
    required this.id,
    this.title = '',
    required this.questionerUid,
    this.regDate,
    this.imageUrl,
    this.adoptedAnswerId,
  });

  /// methods
  void adopt(int id) => adoptedAnswerId ??= id;

  Question.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    tags = data['tags'].cast<String>();
    regDate = (data['regDate'] ?? Timestamp.now()).toDate();
    questionerUid = data['questionerUid'];
    answerIds = (data['answerIds'] ?? []).cast<int>();
    adoptedAnswerId = data['adoptedAnswerId'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tags': tags,
    'regDate': regDate,
    'questionerUid': questionerUid,
    'answerIds': answerIds,
    'adoptedAnswerId': adoptedAnswerId,
  };

  String idToString() => '$id'.padLeft(3, '0');

}