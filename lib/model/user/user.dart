import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/login/google.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/activity.dart';
import 'package:sthep/model/question/notification.dart';
import 'package:sthep/model/user/exp.dart';

class SthepUser with ChangeNotifier {
  /// static values
  // static const String defaultImageUrl = 'https://t1.daumcdn.net/cfile/tistory/245D1A3357256A6F2A';
  static const String defaultProfile = 'https://firebasestorage.googleapis.com/v0/b/sthep-7ea14.appspot.com/o/profiles%2Fguest.png?alt=media&token=476faf46-6d28-4996-ba04-ee8247c4280e';

  /// variables
  bool logged = false;
  String? uid;
  String? name;
  String? email;
  String? nickname;
  String imageUrl = defaultProfile;
  List<int> questionIds = [];
  Map<DateTime, List<MyActivity>> activities = {};

  List<MyNotification> notifications = [];
  int notificationCount = 0;
  int notChecked = 0;

  List<Question> myQuestions = [];
  List<Question> myAnsweredQuestions = [];

  int qCount = 0;
  int aCount = 0;
  int adoptQCount = 0;
  int notAdoptQCount = 0;
  int adoptedACount = 0;
  int notAdoptedACount = 0;

  Exp exp = Exp();

  SthepUser({this.uid, this.name, this.email, this.nickname});

  void setMy(List<Question> questions) {
    if (!logged) return;

    myQuestions = [];
    myAnsweredQuestions = [];

    qCount = 0;
    aCount = 0;
    adoptQCount = 0;
    notAdoptQCount = 0;
    adoptedACount = 0;
    notAdoptedACount = 0;

    myQuestions.addAll(questions.where((question) => question.questionerUid == uid!));
    myAnsweredQuestions.addAll(questions.where((question) => question.answererUids.contains(uid!)));

    myQuestions.forEach((question) {
      List<MyActivity> myActivities = [];
      myActivities.add(MyActivity(type: ActivityType.question, id: question.id!));
      activities[question.regDate as DateTime] = myActivities;
    });

    myAnsweredQuestions.forEach((question) {
      List<MyActivity> myActivities = [];
      myActivities.add(MyActivity(type: ActivityType.answer, id: question.id!));
      activities[question.regDate as DateTime] = myActivities;
    });

    qCount = myQuestions.length;
    aCount = myAnsweredQuestions.length;

    adoptQCount = myQuestions.where((question) => question.adoptedAnswerId != null).length;
    adoptedACount = myAnsweredQuestions.where(
      (question) => question.answers.map(
        (answer) => answer.id == question.adoptedAnswerId && answer.answererUid == uid!
      ).contains(true)
    ).length;

    notAdoptQCount = qCount - adoptQCount;
    notAdoptedACount = aCount - adoptedACount;

    notifyListeners();
  }

  int sumCount() => adoptQCount + notAdoptQCount + adoptedACount + notAdoptedACount;

  void setNickname(String nickname) async {
    this.nickname = nickname;
    notifyListeners();
  }

  Future getNotifications() async {
    if (!logged) return;
    var jsonMyNotifications = await MyFirebase.readSubCollection('users', uid!, 'notifications');

    notifications = [];
    notifications.addAll(
      jsonMyNotifications.map((json)
      => MyNotification.fromJson(json)).toList().cast<MyNotification>().reversed,
    );

    updateNotChecked();
    notifyListeners();
  }

  Future sthepLogin() async {
    logged = true;
    UserCredential userCredential;
    User? user;
    userCredential = await signInWithGoogle();

    user = userCredential.user;
    if (user == null) return;

    uid = user.uid;
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL ?? SthepUser.defaultProfile;

    var json = await MyFirebase.readData('users', uid!);
    nickname = json?['nickname'];
    notificationCount = json?['notificationCount'];
    exp.totalValue = json?['exp'];

    await getNotifications();

    notifyListeners();
  }

  void sthepLogout() {
    signOutWithGoogle();
    logged = false;
    uid = null;
    name = null;
    email = null;
    imageUrl = SthepUser.defaultProfile;
    nickname = null;
    exp.totalValue = 0.0;
    notChecked = 0;
    notifyListeners();
  }

  SthepUser.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    nickname = json['nickname'];
    imageUrl = json['imageUrl'];
    email = json['email'];
    questionIds = (json['questionIds'] ?? []).cast<int>();
    notificationCount = json['notificationCount'];
    exp.setExp(json['exp'].toDouble());
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'nickname': nickname,
    'imageUrl': imageUrl,
    'questionIds': questionIds,
    'notificationCount': notificationCount,
    'exp': exp.totalValue,
  };
  
  void reloadDB() async {
    var json = await MyFirebase.readData('users', uid!);
    fromJson(json!);
  }

  void updateDB() => MyFirebase.write('users', uid!, toJson());

  void notify(String type, Question question) {
    notificationCount++;

    Map<String, String> typeToNotice = {
      'answered': '새로운 답변이 달렸습니다.',
      'answerUpdated': '답변이 수정되었습니다.',
      'answerDeleted': '답변이 삭제되었습니다.',
      'adopted': '답변이 채택되었습니다.',
    };

    Map<String, dynamic> notificationData = {
      'id': notificationCount,
      'checked': false,
      'type': type,
      'questionId': question.id,
      'questionTitle': question.title,
      'notice': typeToNotice[type],
    };

    notificationData['loggedDate'] = FieldValue.serverTimestamp();

    MyFirebase.f.collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(Question.idToString(notificationCount))
        .set(notificationData);
    updateDB();
  }

  void updateNotChecked() {
    notChecked = notifications.where((notification)
    => !notification.checked).toList().length;
    notifyListeners();
  }

  void gainExp(double gained) {
    exp.gainExp(gained);
    updateDB();
    notifyListeners();
  }

}