import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/global.dart';
import 'package:sthep/page/main/answer/answer.dart';
import 'package:sthep/page/main/home/home_materials.dart';
import 'package:sthep/page/main/home/home.dart';
import 'package:sthep/page/main/my/my.dart';
import 'package:sthep/page/main/my/my_materials.dart';
import 'package:sthep/page/main/notification/notification.dart';
import 'package:sthep/page/main/question/question.dart';
import 'package:sthep/page/widget/sidebar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

const pages = [
  HomePage(),
  QuestionPage(),
  AnswerPage(),
  NotificationPage(),
  MyPage(),
];

class _MainPageState extends State<MainPage> {

  double iconSize = 38.0;
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: pageIndex < 4 ? mainPageAppBar : myPageAppBar,
      // appBar: mainPageAppBar,
      endDrawer: const SideBar(),
      body: pages[pageIndex],
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  void menuSelected(int index) => setState(() => pageIndex = index);

  Widget iconQnA(String qoa, double size, Color color) => Stack(
    alignment: Alignment.center,
    children: [
      Icon(Icons.chat_bubble_outline, size: size, color: color),
      Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: myText(qoa, iconSize * 0.3, color, bold: true),
      ),
    ],
  );

  Widget _buildBottomBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Palette.iconColor,
      unselectedItemColor: Palette.iconColor.withOpacity(.3),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: iconSize,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: iconQnA(
            'Q', iconSize,
            Palette.iconColor.withOpacity(pageIndex == 1 ? 1 : .3),
          ),
          label: 'Question',
        ),
        BottomNavigationBarItem(
          icon: iconQnA(
            'A', iconSize,
            Palette.iconColor.withOpacity(pageIndex == 2 ? 1 : .3),
          ),
          label: 'Answer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications, size: iconSize),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: iconSize),
          label: 'My',
        ),
      ],
      currentIndex: pageIndex,
      onTap: menuSelected,
    );
  }
}

