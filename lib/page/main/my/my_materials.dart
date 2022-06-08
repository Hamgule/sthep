import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/global/extensions/widgets/profile.dart';

class MyInfoArea extends StatelessWidget {
  const MyInfoArea({Key? key}) : super(key: key);

  static const duration = Duration(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    SthepUser user = Provider.of<SthepUser>(context);

    return Container(
      width: screenSize.width * .8,
      height: screenSize.height * .20,
      decoration: BoxDecoration(
        color: Palette.bgColor.withOpacity(.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 30.0,
            left: 30.0,
            child: myPageProfile(user),
          ),
          Positioned.fill(
            bottom: 40.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                ExpPoint(),
                ExpBar(),
              ],
            )
          ),
        ],
      ),
    );
  }
}

class ExpPoint extends StatefulWidget {
  const ExpPoint({Key? key}) : super(key: key);

  @override
  State<ExpPoint> createState() => _ExpPointState();
}

class _ExpPointState extends State<ExpPoint> {
  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    Size percentBoxSize = const Size(70.0, 35.0);
    double percentBoxPosBefore = screenSize.width / 10 - percentBoxSize.width / 2;
    double percentBoxPosAfter = percentBoxPosBefore + user.exp.exp * screenSize.width * .6;

    return SizedBox(
      width: screenSize.width * .8,
      height: percentBoxSize.height,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: MyInfoArea.duration,
            left: materials.expAnimation ? percentBoxPosAfter : percentBoxPosBefore,
            curve: Curves.fastOutSlowIn,
            child: SizedBox(
              width: percentBoxSize.width,
              height: percentBoxSize.height,
              child: Column(
                children: [
                  SthepText(
                    '${(100 * user.exp.exp).toStringAsFixed(1)}%',
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
}

class ExpBar extends StatefulWidget {
  const ExpBar({Key? key}) : super(key: key);

  @override
  State<ExpBar> createState() => _ExpBarState();
}

class _ExpBarState extends State<ExpBar> {
  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    double barWidth = screenSize.width * .6;
    double expBarWidth = user.exp.exp * screenSize.width * .6;

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
          duration: MyInfoArea.duration,
          left: materials.expAnimation ? 0 : -expBarWidth,
          curve: Curves.fastOutSlowIn,
          child: AnimatedContainer(
            duration: MyInfoArea.duration,
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
}


