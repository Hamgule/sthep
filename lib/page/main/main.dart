import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/widgets.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/main/home/home.dart';
import 'package:sthep/page/main/my/my.dart';
import 'package:sthep/page/main/notification/notification.dart';
import 'package:sthep/page/main/view/view.dart';
import 'package:sthep/page/upload/upload.dart';
import 'package:sthep/page/widget/appbar.dart';
import 'package:sthep/page/widget/sidebar.dart';

List<PreferredSizeWidget> appbars(Question? question) => [
  const HomeAppBar(),
  const HomeAppBar(title: '나의 질문'),
  const HomeAppBar(title: '나의 답변'),
  const MainAppBar(title: '알림'),
  const MainAppBar(title: '마이페이지'),
  const EditAppBar(title: '질문하기'),
  EditAppBar(title: question == null ? '' : '${question.id} 번 질문 - ${question.title}'),
];

List<Widget> pages(Question? question) => [
  const HomePage(),
  const HomePage(type: 'question'),
  const HomePage(type: 'answer'),
  const NotificationPage(),
  const MyPage(),
  const UploadPage(),
  ViewPage(question: question),
];

List<bool> visualizeButton = [
  true, true, true, false, false, true, true,
];

List<Widget> floatingIcons = [
  const Icon(Icons.edit),
  const Icon(Icons.edit),
  const Icon(Icons.edit),
  Container(),
  Container(),
  const Icon(Icons.upload),
  const Icon(Icons.edit),
];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  double iconSize = 38.0;
  bool imageLoading = false;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    Materials main = Provider.of<Materials>(context, listen: false);
    SthepUser user = Provider.of<SthepUser>(context, listen: false);

    void floatingButtonPressed() async {
      Map<String, dynamic>? data = await MyFirebase.readData('autoIncrement', 'question');
      int nextId = data!['currentId'] + 1;

      if (main.newPageIndex < 3) {
        if (!user.logged) {
          showMySnackBar(context, '로그인이 필요합니다.');
          return;
        }

        main.setPageIndex(5);
        main.newQuestion = Question(
          id: nextId,
          questionerUid: user.uid!,
        );
        main.image = null;
      }

      // Upload Page
      else if (main.newPageIndex == 5) {
        if (main.newQuestion.title == '') {
          showMySnackBar(context, '제목을 입력하세요');
          return;
        }

        if (main.image == null) {
          showMySnackBar(context, '이미지를 추가하세요');
          return;
        }

        if (main.newQuestion.imageUrl == null) {
          setState(() => imageLoading = true);
        }

        main.newQuestion.imageUrl = await MyFirebase.uploadImage(
          'questions',
          main.newQuestion.idToString(),
          main.image,
        );

        setState(() => imageLoading = false);

        Map<String, dynamic> addData = main.newQuestion.toJson();
        addData['regDate'] = FieldValue.serverTimestamp();
        MyFirebase.write(
          'questions',
          main.newQuestion.idToString(),
          addData,
        );
        main.setPageIndex(0);

        MyFirebase.write('autoIncrement', 'question', {'currentId': nextId});
      }
    }

    return Consumer<Materials>(
      builder: (context, main, _) {
        return Scaffold(
          appBar: appbars(main.destQuestion)[main.newPageIndex],
          endDrawer: const SideBar(),
          body: Stack(
            children: [
              pages(main.destQuestion)[main.newPageIndex],
              if (imageLoading)
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
          floatingActionButton: visualizeButton[main.newPageIndex] ? FloatingActionButton(
            onPressed: floatingButtonPressed,
            child: floatingIcons[main.newPageIndex],
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

