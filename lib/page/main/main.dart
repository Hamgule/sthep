import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/buttons/fab.dart';
import 'package:sthep/global/extensions/widgets/sidebar.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/main/home/home.dart';
import 'package:sthep/page/main/my/my.dart';
import 'package:sthep/page/main/notification/notification.dart';
import 'package:sthep/page/main/view/view.dart';
import 'package:sthep/page/upload/update.dart';
import 'package:sthep/page/upload/create.dart';
import 'package:sthep/global/extensions/widgets/appbar.dart';

List<PreferredSizeWidget> appbars(Question? question) {
  return [
    const HomeAppBar(),
    const HomeAppBar(title: '나의 질문'),
    const HomeAppBar(title: '나의 답변'),
    const MainAppBar(title: '알림'),
    const MainAppBar(title: '마이페이지'),
    const BackAppBar(title: '질문하기'),
    BackAppBar(title: question == null ? '' : '${question.id} 번 질문 - ${question.title}'),
    BackAppBar(title: question == null ? '' : '수정하기: ${question.id} 번 질문 - ${question.title}'),
  ];
}

List<Widget> pages(Question? question) => [
  const HomePage(),
  const HomePage(type: 'question'),
  const HomePage(type: 'answer'),
  const NotificationPage(),
  const MyPage(),
  const CreatePage(),
  ViewPage(question: question),
  UpdatePage(question: question),
];

List<Widget?> floatingButtons = [
  const FAB(child: Icon(Icons.edit)),
  const FAB(child: Icon(Icons.edit)),
  const FAB(child: Icon(Icons.edit)),
  null,
  null,
  const FAB(child: Icon(Icons.upload)),
  const ViewFAB(),
  const FAB(child: Icon(Icons.upload)),
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
      builder: (context, main, _) {
        return Scaffold(
          appBar: appbars(main.destQuestion)[main.newPageIndex],
          endDrawer: const SideBar(),
          body: Stack(
            children: [
              pages(main.destQuestion)[main.newPageIndex],
              if (main.imageUploading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Palette.bgColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context),
          floatingActionButton: floatingButtons[main.newPageIndex],
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
      builder: (context, main, _) {
        SthepUser user = Provider.of<SthepUser>(context, listen: false);

        void setIndex(int index) {
          if (user.logged || index == 0) {
            main.setPageIndex(index);
            return;
          }
          showMySnackBar(context, '로그인이 필요합니다.');
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
                Palette.iconColor.withOpacity(main.pageIndex == 1 ? 1 : .3),
              ),
              label: 'Question',
            ),
            BottomNavigationBarItem(
              icon: iconQnA(
                'A', iconSize,
                Palette.iconColor.withOpacity(main.pageIndex == 2 ? 1 : .3),
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
          currentIndex: main.newPageIndex < 5 ? main.newPageIndex : main.pageIndex,
          onTap: setIndex,
        );
      }
    );
  }
}