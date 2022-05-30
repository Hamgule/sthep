import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sthep/global/extensions/icons/icons.dart';

class Question {
  /// variables
  late int id;
  late String title;
  late String questionerUid;
  DateTime? regDate = DateTime.now();
  DateTime? modDate = DateTime.now();

  List<String> tags = [];
  List<dynamic> answers = [];

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
    answers = (data['answers'] ?? []);
    adoptedAnswerId = data['adoptedAnswerId'];
    imageUrl = data['imageUrl'];

    if (answers.isNotEmpty) state = AdoptState.notAdopted;
    if (adoptedAnswerId != null) state = AdoptState.adopted;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tags': tags,
    'regDate': regDate,
    'questionerUid': questionerUid,
    'answers': answers,
    'adoptedAnswerId': adoptedAnswerId,
    'imageUrl': imageUrl,
  };

  String idToString() => '$id'.padLeft(5, '0');
  String tagsToString() => tags.join(' ');

  String toSearchString() => ['$id', title].join(' ');
}