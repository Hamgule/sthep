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

  double adoptQCount = 0;
  double notAdoptQCount = 0;
  double adoptedACount = 0;
  double notAdoptedACount = 0;

  Exp exp = Exp();

  SthepUser({this.uid, this.name, this.email, this.nickname});

  double sumCount() => adoptQCount + notAdoptQCount + adoptedACount + notAdoptedACount;

  void toggleLogState() {
    logged = !logged;
    notifyListeners();
  }

  void setNickname(String nickname) async {
    this.nickname = nickname;
    notifyListeners();
  }

  Future getNotifications() async {
    var loadMyNotifications = await MyFirebase.readSubCollection('users', uid!, 'notifications');

    notifications = [];
    notifications.addAll(
      loadMyNotifications.map((data)
      => MyNotification.fromJson(data)).toList().cast<MyNotification>(),
    );

    updateNotChecked();
    notifyListeners();
  }

  Future sthepLogin() async {
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
    exp.totalValue = json?['exp'];

    await getNotifications();

    notifyListeners();
  }

  void sthepLogout() {
    signOutWithGoogle();
    logged = false;
    notifyListeners();
  }

  SthepUser.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  void fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    nickname = json['nickname'];
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