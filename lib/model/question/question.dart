import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sthep/global/extensions/icons/icons.dart';
import 'package:sthep/model/question/answer.dart';

class Question {
  /// variables
  late int id;
  late String title;
  late String questionerUid;
  DateTime? regDate = DateTime.now();
  DateTime? modDate = DateTime.now();

  List<String> tags = [];
  List<String> answererUids = [];
  List<int> answerIds = [];

  String? imageUrl;
  int? adoptedAnswerId;

  AdoptState state = AdoptState.notAnswered;

  /// constructor
  Question({
    required this.id,
    this.title = '',
    required this.questionerUid,
    this.regDate,
    this.modDate,
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
    modDate = (data['regDate'] ?? Timestamp.now()).toDate();
    questionerUid = data['questionerUid'];
    adoptedAnswerId = data['adoptedAnswerId'];
    imageUrl = data['imageUrl'];
    answerIds = (data['answerIds'] ?? []).cast<int>();
    answererUids = (data['answererUids'] ?? []).cast<String>();

    if (answerIds.isNotEmpty) state = AdoptState.notAdopted;
    if (adoptedAnswerId != null) state = AdoptState.adopted;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tags': tags,
    'regDate': regDate,
    'questionerUid': questionerUid,
    'adoptedAnswerId': adoptedAnswerId,
    'imageUrl': imageUrl,
    'answerIds': answerIds,
    'answererUids': answererUids,
  };

  String idToString() => '$id'.padLeft(5, '0');
  String tagsToString() => tags.join(' ');

  String toSearchString() => ['$id', title].join(' ');
}