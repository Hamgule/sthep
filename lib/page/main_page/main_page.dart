import 'package:flutter/material.dart';
import 'package:sthep/global/global.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/page/my_page/my_page.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/page/widget/profile.dart';
import 'package:sthep/page/widget/sidebar.dart';


bool isGrid = true;
User tempUser = User(
  id: 'zihoo1234',
  name: '양지후',
  nickname: 'zihoo',
  password: '',
);

Question tempQuestion = Question(
  id: 1,
  title: "2016년도 수능 알려주세요..",
  questioner: tempUser,
  image: Image.asset(
    'assets/images/math.jpeg',
    height: 200.0,
  ),
);

PreferredSizeWidget mainPageAppBar = AppBar(
  backgroundColor: Palette.appbarColor,
  foregroundColor: Palette.iconColor,
  title: Image.asset(
    'assets/images/logo_horizontal.png',
    fit: BoxFit.contain,
    width: 120,
  ),
  actions: [
    Builder(builder: (context) {
      return IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const MyPage()));
          },
          icon: const Icon(Icons.search));
    }),
    StatefulBuilder(
      builder: (context, setState) => IconButton(
        onPressed: () => setState(() => isGrid = !isGrid),
        icon: Icon(
          isGrid ? Icons.list_alt : Icons.window,
        ),
      ),
    ),
    StatefulBuilder(
      builder: (context, setState) => IconButton(
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        icon: const Icon(Icons.menu),
      ),
    ),
  ],
);

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: mainPageAppBar,
      endDrawer: const SideBar(),
      body:
          GridView.count(
            padding: const EdgeInsets.all(30.0),
            crossAxisCount: 3,
            children: List.generate(100, (index) {
              return const Center(
                child: QuestionCard(),
              );
            }),
          ),
      );
  }
}

class Ranking extends StatelessWidget {
  const Ranking({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Row(
      children: [
        myText('오늘의 최다 답변자', 20.0, Palette.fontColor1),
      ],
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          elevation: 10.0,
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/images/math.jpeg',
                  height: 200.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      myText('#수학', 10.0, Palette.hyperColor),
                      const SizedBox(width: 8),
                      myText('#수능', 10.0, Palette.hyperColor),
                      Expanded(
                        child: Container(),
                      ),
                      myText('5 min ago', 10.0, Colors.grey),
                    ]),
                Row(children: <Widget>[
                  myText(tempQuestion.title, 20.0, Colors.black),
                  const SizedBox(height: 50.0),
                ]),
                Row(
                  children: [
                    Expanded(child: simpleProfile(tempUser)),
                    const Icon(Icons.comment_rounded, size: 20.0),
                    const SizedBox(width: 5.0),
                    myText('5', 15.0, Colors.black),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 30,
          top: 10,
          child: adoptState,
        ),
      ],
    );
  }
}