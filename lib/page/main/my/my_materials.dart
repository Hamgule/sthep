import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/exp.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/global/extensions/widgets/profile.dart';

import 'my.dart';

PreferredSizeWidget myPageAppBar = AppBar(
  backgroundColor: Palette.appbarColor,
  foregroundColor: Palette.iconColor,
  centerTitle: false,
  title: const SthepText(
    '마이페이지',
    size: 25.0,
    color: Palette.iconColor,
  ),
  actions: [
    StatefulBuilder(
      builder: (context, setState) => IconButton(
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        icon: const Icon(Icons.menu),
      ),
    ),
  ],
);

Widget myInfoArea(SthepUser user) {
  return Container(
    width: screenSize.width * .8,
    height: screenSize.height * .25,
    decoration: BoxDecoration(
        color: Palette.bgColor.withOpacity(.2),
        borderRadius: BorderRadius.circular(10.0,)
    ),
    child: Stack(
      children: [
        Positioned(
          top: 40.0,
          left: 40.0,
          child: myPageProfile(user),
        ),
        Positioned.fill(
          bottom: 40.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              expPoint(user.exp),
              expBar(user.exp),
            ],
          )
        ),
      ],
    ),
  );
}

Widget expPoint(Exp exp) {
  Size percentBoxSize = const Size(70.0, 35.0);
  double percentBoxPosBefore = screenSize.width / 10 - percentBoxSize.width / 2;
  double percentBoxPosAfter = percentBoxPosBefore + exp.exp * screenSize.width * .6;

  return SizedBox(
    width: screenSize.width * .8,
    height: percentBoxSize.height,
    child: Stack(
      children: [
        AnimatedPositioned(
          duration: MyPage.duration,
          left: MyPage.animFin ? percentBoxPosAfter : percentBoxPosBefore,
          curve: Curves.fastOutSlowIn,
          child: SizedBox(
            width: percentBoxSize.width,
            height: percentBoxSize.height,
            child: Column(
              children: [
                SthepText(
                  '${(100 * exp.exp).toStringAsFixed(1)}%',
                  size: 15.0,
                  color: Palette.hyperColor,
                ),
                const Icon(
                  Icons.location_on,
                  size: 15.0,
                  color: Palette.hyperColor
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget expBar(Exp exp) {
  double barWidth = screenSize.width * .6;
  double expBarWidth = exp.exp * screenSize.width * .6;

  return Stack(
    children: [
      Container(
        width: barWidth,
        height: 13.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(),
        ),
      ),
      AnimatedPositioned(
        duration: MyPage.duration,
        left: MyPage.animFin ? 0 : -expBarWidth,
        curve: Curves.fastOutSlowIn,
        child: AnimatedContainer(
          duration: MyPage.duration,
          curve: Curves.fastOutSlowIn,
          width: expBarWidth,
          height: 13.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Palette.hyperColor.withOpacity(.3),
                Palette.hyperColor.withOpacity(.6),
              ],
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    ],
  );
}
