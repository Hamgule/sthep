import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

final users = <User>[];
final questions = <Question>[];

User tempUser = User(
  id: 'zihoo1234',
  name: '양지후',
  nickname: 'zihoo',
  password: '',
);

Widget myText(String text, double size, Color color) => Text(
  text,
  style: TextStyle(
    fontFamily: 'Nemojin030',
    color: color,
    fontSize: size,
  ),
);

Widget settingButton = IconButton(
  onPressed: () {},
  icon: Icon(
    Icons.settings,
    color: Palette.iconColor,
    size: 18.0,
  ),
);