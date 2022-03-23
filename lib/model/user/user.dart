import 'package:flutter/material.dart';
import 'package:sthep/model/user/exp.dart';

class User {
  /// variables
  String id;
  String name;
  String nickname;
  String password;
  Image image = Image.network("https://t1.daumcdn.net/cfile/tistory/245D1A3357256A6F2A");

  Exp exp = Exp();

  /// constructor
  User({
    required this.id,
    required this.name,
    required this.nickname,
    required this.password,
  });

  // void setImage(String src) => image = Image.network("https://i.imgur.com/BoN9kdC.png");

}