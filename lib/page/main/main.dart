import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/main/answer/answer.dart';
import 'package:sthep/page/main/home/home.dart';
import 'package:sthep/page/main/my/my.dart';
import 'package:sthep/page/main/notification/notification.dart';
import 'package:sthep/page/main/question/question.dart';
import 'package:sthep/page/upload/upload.dart';
import 'package:sthep/page/widget/appbar.dart';
import 'package:sthep/page/widget/sidebar.dart';

List<PreferredSizeWidget> appbars = const [
  HomeAppBar(),
  MainAppBar(title: '나의 질문'),
  MainAppBar(title: '나의 답변'),
  MainAppBar(title: '알림'),
  MainAppBar(title: '마이페이지'),
  UploadAppBar(),
];

List<Widget> pages = const [
  HomePage(),
  QuestionPage(),
  AnswerPage(),
  NotificationPage(),
  MyPage(),
  UploadPage(),
];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  double iconSize = 38.0;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Consumer<Materials>(
      builder: (context, upload, _) {
        return Scaffold(
          appBar: appbars[upload.newPageIndex],
          endDrawer: const SideBar(),
          body: pages[upload.newPageIndex],
          bottomNavigationBar: _buildBottomBar(context),
          floatingActionButton: upload.pageIndex == 0 ? FloatingActionButton(
            onPressed: () => setState(() => upload.setPageIndex(5)),
            child: const Icon(Icons.add),
            backgroundColor: Palette.hyperColor,
          ) : null,
        );
      }
    );
  }

  Widget iconQnA(String qoa, double size, Color color) => Stack(
    alignment: Alignment.center,
    children: [
      Icon(Icons.chat_bubble_outline, size: size, color: color),
      Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: SthepText(
          qoa, size: iconSize * 0.3,
          color: color,
          bold: true,
        ),
      ),
    ],
  );

  Widget _buildBottomBar(BuildContext context) {
    return Consumer<Materials>(
      builder: (context, upload, _) {
        void setIndex(int index) {
          SthepUser user = Provider.of<SthepUser>(context, listen: false);

          if (user.logged || index == 0) {
            upload.setPageIndex(index);
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 500),
              content: Text('먼저 로그인이 필요합니다.'),
            ),
          );
        }

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
                Palette.iconColor.withOpacity(upload.pageIndex == 1 ? 1 : .3),
              ),
              label: 'Question',
            ),
            BottomNavigationBarItem(
              icon: iconQnA(
                'A', iconSize,
                Palette.iconColor.withOpacity(upload.pageIndex == 2 ? 1 : .3),
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
          currentIndex: upload.newPageIndex < 5 ? upload.newPageIndex : upload.pageIndex,
          onTap: setIndex,
        );
      }
    );
  }
}

