import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

final users = <User>[];
final questions = <Question>[];

Widget myText(String text, Color color) => Text(
  text,
  style: TextStyle(
    fontFamily: 'Nemojin020',
    color: color,
  ),
);