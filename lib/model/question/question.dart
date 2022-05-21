import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sthep/model/painter/painter.dart';

class Question {
  /// variables
  late int id;
  late String title;
  late String questionerUid;
  late DateTime regDate;

  List<String> tags = [];
  List<String> answerIds = [];

  Painter? painter;
  String? imageUrl;
  String? adoptedAnswerId;

  /// constructor
  Question({
    required this.id,
    required this.title,
    required this.questionerUid,
    required this.regDate,
    this.imageUrl,
  });

  /// methods
  void adopt(String id) => adoptedAnswerId ??= id;

  Question.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    tags = data['tags'].cast<String>();
    regDate = (data['regDate'] as Timestamp).toDate();
    questionerUid = data['questionerUid'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tags': tags,
    'regDate': regDate,
    'questionerUid': questionerUid,
  };
}