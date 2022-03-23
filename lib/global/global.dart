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

Widget profilePhoto(User user) => Container(
  width: 50.0,
  height: 50.0,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    image: DecorationImage(
      fit: BoxFit.fill,
      image: user.image.image,
    ),
  ),
);

Widget profile(User user) => Row(
  children: [
    profilePhoto(user),
    const SizedBox(width: 15.0),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              user.id,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '${user.name} / ${user.nickname}',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    ),
  ],
);

Widget settingButton = IconButton(
  onPressed: () {},
  icon: Icon(
    Icons.settings,
    color: Palette.iconColor,
    size: 18.0,
  ),
);