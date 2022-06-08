import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/buttons/setting.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/model/user/user.dart';

Widget profilePhoto(SthepUser user) => Container(
  width: 30.0,
  height: 30.0,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    image: DecorationImage(
      fit: BoxFit.fill,
      image: Image.network(user.imageUrl).image,
    ),
  ),
);

Widget profile(SthepUser user) => Padding(
  padding: const EdgeInsets.all(10.0),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      profilePhoto(user),
      const SizedBox(width: 20.0),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.nickname!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.email!,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    ],
  ),
);

Widget myPageProfile(SthepUser user) => Container(
  padding: const EdgeInsets.all(10.0,),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(.5),
    borderRadius: BorderRadius.circular(15.0),
  ),
  child: Row(
    children: [
      profilePhoto(user),
      const SizedBox(width: 10.0),
      SthepText(
        'Lv. ${user.exp.level}',
        size: 13.0,
        color: Palette.fontColor2,
      ),
      const SizedBox(width: 10.0),
      SthepText('${user.nickname} 님'),
      SettingButton(onPressed: () {}),
    ],
  ),
);

Widget simpleProfile(SthepUser user) => Row(
  children: [
    Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: Image.network(user.imageUrl).image,
        ),
      ),
    ),
    const SizedBox(width: 15.0),
    Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              user.nickname!,
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