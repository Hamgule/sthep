import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/login/google.dart';
import 'package:sthep/model/user/exp.dart';

class SthepUser with ChangeNotifier {
  /// static values
  // static const String defaultImageUrl = 'https://t1.daumcdn.net/cfile/tistory/245D1A3357256A6F2A';
  static const String defaultImageUrl = 'https://firebasestorage.googleapis.com/v0/b/sthep-7ea14.appspot.com/o/profiles%2Fguest.png?alt=media&token=476faf46-6d28-4996-ba04-ee8247c4280e';

  /// variables
  String? uid;
  String? name;
  String? email;
  String? nickname;
  String imageUrl = defaultImageUrl;
  bool logged = false;
  List<int> questionIds = [];

  SthepUser({this.uid, this.name, this.email, this.nickname});

  Exp exp = Exp();
  List<int> questions = []; // 나의 질문들의 id 값

  void setNickname(String nickname) async {
    this.nickname = nickname;
    notifyListeners();
  }

  Future sthepLogin() async {
    UserCredential userCredential;
    User? user;
    try { userCredential = await signInWithGoogle(); }
    catch(e) { return; }

    user = userCredential.user;
    if (user == null) return;

    uid = user.uid;
    name = user.displayName;
    email = user.email;
    logged = true;

    var loadData = await MyFirebase.readData('users', uid!);
    nickname = loadData?['nickname'];

    notifyListeners();
  }

  void sthepLogout() {
    signOutWithGoogle();
    logged = false;
    notifyListeners();
  }

  SthepUser.fromJson(Map <String, dynamic> data) {
    uid = data['uid'];
    name = data['name'];
    nickname = data['nickname'];
    email = data['email'];
    questionIds = (data['questionIds'] ?? []).cast<int>();
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'nickname': nickname,
    'imageUrl': imageUrl,
    'questionIds': questionIds,
  };

  void updateDB() async {
    await MyFirebase.write('users', uid!, toJson());
  }
}