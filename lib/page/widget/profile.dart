import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/global.dart';
import 'package:sthep/model/user/user.dart';

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

Widget myPageProfile = Container(
  padding: const EdgeInsets.all(10.0,),
  child: Row(
    children: [
      profilePhoto(tempUser),
      const SizedBox(width: 10.0),
      myText('Lv. ${tempUser.exp.level}', 13.0, Palette.fontColor2),
      const SizedBox(width: 10.0),
      myText('${tempUser.name} 님', 20.0, Palette.fontColor1),
      settingButton,
    ],
  ),
);

Widget simpleProfile(User user) => Row(
  children: [
    Container(
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: user.image.image,
          ),
        )),
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
        ],
      ),
    ),
  ],
);