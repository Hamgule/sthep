import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sthep/model/user/exp.dart';

class User {
  /// variables
  String id;
  String name;
  String nickname;
  String password;
  Image image = Image.network("https://i.imgur.com/BoN9kdC.png");

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