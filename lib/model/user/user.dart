import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/login/google.dart';
import 'package:sthep/model/user/activity.dart';
import 'package:sthep/model/question/notification.dart';
import 'package:sthep/model/user/exp.dart';

class SthepUser with ChangeNotifier {
  /// static values
  // static const String defaultImageUrl = 'https://t1.daumcdn.net/cfile/tistory/245D1A3357256A6F2A';
  static const String defaultImageUrl = 'https://firebasestorage.googleapis.com/v0/b/sthep-7ea14.appspot.com/o/profiles%2Fguest.png?alt=media&token=476faf46-6d28-4996-ba04-ee8247c4280e';

  /// variables
  bool logged = false;
  String? uid;
  String? name;
  String? email;
  String? nickname;
  String imageUrl = defaultImageUrl;
  List<int> questionIds = [];
  Map<DateTime, List<MyActivity>> activities = {};

  List<MyNotification> notifications = [];
  int notificationCount = 0;
  int notChecked = 0;

  Exp exp = Exp();

  SthepUser({this.uid, this.name, this.email, this.nickname});


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

    var loadUser = await MyFirebase.readData('users', uid!);
    nickname = loadUser?['nickname'];

    await getNotifications();

    notifyListeners();
  }

  void sthepLogout() {
    signOutWithGoogle();
    logged = false;
    notifyListeners();
  }

  SthepUser.fromJson(Map<String, dynamic> data) {
    uid = data['uid'];
    name = data['name'];
    nickname = data['nickname'];
    email = data['email'];
    questionIds = (data['questionIds'] ?? []).cast<int>();
    notificationCount = data['notificationCount'];
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'nickname': nickname,
    'imageUrl': imageUrl,
    'questionIds': questionIds,
    'notificationCount': notificationCount,
  };

  void updateDB() async {
    await MyFirebase.write('users', uid!, toJson());
  }

  void updateNotChecked() {
    notChecked = notifications.where((notification)
    => !notification.checked).toList().length;

    notifyListeners();
  }

}