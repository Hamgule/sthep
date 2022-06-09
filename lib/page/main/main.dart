import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/buttons/fab/answer/create.dart';
import 'package:sthep/global/extensions/buttons/fab/answer/update.dart';
import 'package:sthep/global/extensions/buttons/fab/home.dart';
import 'package:sthep/global/extensions/buttons/fab/question/create.dart';
import 'package:sthep/global/extensions/buttons/fab/question/update.dart';
import 'package:sthep/global/extensions/buttons/fab/view.dart';
import 'package:sthep/global/extensions/widgets/progress_indicator.dart';
import 'package:sthep/global/extensions/widgets/sidebar.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/main/home/home.dart';
import 'package:sthep/page/main/my/my.dart';
import 'package:sthep/page/main/notification/notification.dart';
import 'package:sthep/page/main/view/view.dart';
import 'package:sthep/page/upload/answer_create.dart';
import 'package:sthep/page/upload/answer_update.dart';
import 'package:sthep/page/upload/question_update.dart';
import 'package:sthep/page/upload/question_create.dart';
import 'package:sthep/global/extensions/widgets/appbar.dart';

List<String> pageNames = const [
  'home', 'myQuestions',
  'myAnswers', 'notifications',
  'my', 'questionCreate',
  'view', 'questionUpdate',
  'answerCreate', 'answerUpdate',
];

List<PreferredSizeWidget> appbars = [
  const HomeAppBar(),
  const HomeAppBar(title: '나의 질문'),
  const HomeAppBar(title: '나의 답변'),
  const MainAppBar(title: '알림'),
  const MainAppBar(title: '마이페이지'),
  const BackAppBar(title: '질문하기'),
  const BackAppBar(title: '질문'),
  const BackAppBar(title: '질문 수정하기'),
  const BackAppBar(title: '답변하기'),
  const BackAppBar(title: '답변 수정하기'),
];

List<Widget> pages = [
  const HomePage(),
  const HomePage(type: 'question'),
  const HomePage(type: 'answer'),
  const NotificationPage(),
  const MyPage(),
  const CreatePage(),
  const ViewPage(),
  const UpdatePage(),
  const AnswerCreatePage(),
  const AnswerUpdatePage(),
];

List<Widget?> floatingButtons() => [
  const HomeFAB(),
  const HomeFAB(),
  const HomeFAB(),
  null,
  null,
  const QuestionCreateFAB(),
  ViewFAB(), // NO CONSTANT
  const QuestionUpdateFAB(),
  const AnswerCreateFAB(),
  const AnswerUpdateFAB(),
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
          appBar: appbars[main.newPageIndex],
          endDrawer: const SideBar(),
          body: Stack(
            children: [
              pages[main.newPageIndex],
              if (main.loading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(.3),
                  child: const Center(
                    child: SthepProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context),
          floatingActionButton: floatingButtons()[main.newPageIndex],
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
      builder: (context, materials, _) {
        SthepUser user = Provider.of<SthepUser>(context);

        void setIndex(int index) async {
          if (user.logged || index == 0) {
            if (index == 4) materials.finishAnimation();
            materials.setPageIndex(index);
            materials.updateVisQuestions(user);
            await Future.delayed(
              const Duration(milliseconds: 10), () {
                materials.startAnimation();
              },
            );
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
              icon: Icon(Icons.home, size: iconSize),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: iconQnA(
                'Q', iconSize,
                Palette.iconColor.withOpacity(materials.pageIndex == 1 ? 1 : .3),
              ),
              label: 'Question',
            ),
            BottomNavigationBarItem(
              icon: iconQnA(
                'A', iconSize,
                Palette.iconColor.withOpacity(materials.pageIndex == 2 ? 1 : .3),
              ),
              label: 'Answer',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.notifications, size: iconSize),
                  if (user.notChecked > 0)
                  Positioned(
                    right: 0.0,
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Center(
                        child: Text(
                          '${user.notChecked}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: iconSize),
              label: 'My',
            ),
          ],
          currentIndex: materials.newPageIndex < 5 ? materials.newPageIndex : materials.pageIndex,
          onTap: setIndex,
        );
      }
    );
  }
}