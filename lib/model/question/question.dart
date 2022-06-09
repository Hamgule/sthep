import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/icons/icons.dart';
import 'package:sthep/model/question/answer.dart';
import 'package:sthep/model/user/user.dart';

class Question {
  static const defaultBlankPaper = 'https://firebasestorage.googleapis.com/v0/b/sthep-7ea14.appspot.com/o/questions%2Fdefault.png?alt=media&token=c3f7e6b6-7c80-4dbb-859a-3e3d7adac434';

  /// variables
  int? id;
  late String title;
  late String questionerUid;
  DateTime? regDate = DateTime.now();
  DateTime? modDate = DateTime.now();

  List<String> tags = [];
  List<int> answerIds = [];
  List<String> answererUids = [];

  late SthepUser questioner;
  List<Answer> answers = [];

  String? content;
  String? imageUrl;
  int? adoptedAnswerId;

  AdoptState state = AdoptState.notAnswered;

  /// constructor
  Question({
    required this.questioner,
    required this.questionerUid,
  });

  /// methods
  void adopt(int id) => adoptedAnswerId ??= id;

  Question.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    tags = json['tags'].cast<String>();
    regDate = (json['regDate'] ?? Timestamp.now()).toDate();
    modDate = (json['modDate'] ?? Timestamp.now()).toDate();
    questionerUid = json['questionerUid'];
    adoptedAnswerId = json['adoptedAnswerId'];
    content = json['content'];
    imageUrl = json['imageUrl'];
    answerIds = (json['answerIds'] ?? []).cast<int>();
    answererUids = (json['answererUids'] ?? []).cast<String>();
    updateState();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tags': tags,
    'regDate': regDate,
    'modDate': modDate,
    'questionerUid': questionerUid,
    'adoptedAnswerId': adoptedAnswerId,
    'content': content,
    'imageUrl': imageUrl,
    'answerIds': answerIds,
    'answererUids': answererUids,
  };

  void updateState() {
    state = AdoptState.notAnswered;
    if (answerIds.isNotEmpty) state = AdoptState.notAdopted;
    if (adoptedAnswerId != null) state = AdoptState.adopted;
  }

  void addAnswer(Answer answer) {
    answers.add(answer);
    answerIds.add(answer.id!);
    answererUids.add(answer.answererUid);

    updateState();
    updateDB();
  }

  void removeAnswer(Answer answer) {
    answers.removeWhere((ans) => ans.id == answer.id);
    answererUids.remove(answer.answererUid);
    answerIds.remove(answer.id);

    updateState();
    updateDB();
  }

  static String idToString(int id) => '$id'.padLeft(5, '0');

  String qidToString() => idToString(id!);
  String tagsToString() => tags.join(' ');

  String toSearchString(List<bool> allows) {
    List<String?> searchStrings = ['$id', title, questioner.nickname, content];
    List<String?> allowStrings = [];

    for (int i = 0; i < searchStrings.length; i++) {
      if (allows[i]) allowStrings.add(searchStrings[i]);
    }
    return allowStrings.join(' ');
  }

  Future<int> getNextId() async {
    Map<String, dynamic>? data = await MyFirebase.readData('autoIncrement', 'question');
    return data!['currentId'] + 1;
  }

  void createDB() async {
    Map<String, dynamic> json = toJson();

    json['regDate'] = FieldValue.serverTimestamp();
    json['modDate'] = FieldValue.serverTimestamp();

    MyFirebase.write('questions', qidToString(), json);
    MyFirebase.write('autoIncrement', 'question', {'currentId': id});
  }

  void updateDB({bool updateModDate = false}) {
    Map<String, dynamic> json = toJson();
    if (updateModDate) json['modDate'] = FieldValue.serverTimestamp();
    MyFirebase.write('questions', qidToString(), toJson());
  }

  void deleteDB() {
    MyFirebase.remove('questions', qidToString());
    MyFirebase.removeImage('questions', qidToString());
  }
}