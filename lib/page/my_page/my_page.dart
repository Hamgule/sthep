import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/global.dart';
import 'package:sthep/model/user/exp.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/widget/profile.dart';
import 'package:sthep/page/widget/sidebar.dart';

bool isGrid = true;

PreferredSizeWidget myPageAppBar = AppBar(
  backgroundColor: Palette.appbarColor,
  foregroundColor: Palette.iconColor,
  centerTitle: false,
  title: myText('마이페이지', 25.0, Palette.iconColor,),
  actions: [
    StatefulBuilder(
      builder: (context, setState) => IconButton(
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        icon: const Icon(Icons.menu),
      ),
    ),
  ],
);

Widget myInfoArea(User user) => Container(
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
        child: Align(
          alignment: Alignment.bottomCenter,
          child: expBar(user.exp),
        )
      ),
    ],
  ),
);

Widget expBar(Exp exp) => Container(
  child: Stack(
    children: [
      // Container(
      //   width: exp.exp * screenSize.width * .6,
      //   height: 10.0,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(10.0),
      //   ),
      // ),
      Container(
        width: screenSize.width * .6,
        height: 10.0,
        decoration: BoxDecoration(
          color: Palette.iconColor.withOpacity(.4),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ],
  ),
);

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MainPageState();
}

class _MainPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    tempUser.exp.gainExp(124354.0);
    print(tempUser.exp.exp);

    return Scaffold(
      appBar: myPageAppBar,
      endDrawer: const SideBar(),
      body: Column(
        children: [
          Row(
            children: [myInfoArea(tempUser),],
          ),
        ],
      ),
    );
  }
}
