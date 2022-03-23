import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

final users = <User>[];
final questions = <Question>[];

late Size screenSize;

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

Widget adoptState = Material(
  elevation: 10.0,
  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
  child: Container(
    padding: const EdgeInsets.fromLTRB(13.0, 8.0, 13.0, 8.0),
    child: myText('채택 완료', 13.0, Colors.white),
    decoration: BoxDecoration(
      color:Palette.adoptOk,
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
    ),
  ),
);