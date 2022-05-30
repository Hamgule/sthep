import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/icons/icons.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/time/time.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/main/notification/notification_materials.dart';
import 'package:sthep/global/extensions/widgets/profile.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  // animation control variables
  bool animate = false;
  int aniVelocity = 15000;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: aniVelocity), vsync: this,
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });

    _animation.addListener(() => setState(() {}));

    late final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: Offset(animate ? 1.0 : 0.0, 0.0),
      end: Offset(animate ? -1.0 : 0.0, 0.0),
    ).animate(_animation as Animation<double>);


    return SlideTransition(
      position: _offsetAnimation,
      child: Stack(
        children: [
          Positioned(
            child: SizedBox(
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (MediaQuery.of(context).orientation == Orientation.landscape)
                  const SthepText(
                    '오늘의 최다 답변자',
                    size: 20.0,
                    color: Palette.fontColor1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            color: Colors.yellow,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                          profile(tempUser),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            color: Colors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                          profile(tempUser),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            color: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                          profile(tempUser),
                        ],
                      ),
                    ],
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

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 8.0,
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: InkWell(
            onTap: () {
              Materials home = Provider.of<Materials>(context, listen: false);
              home.setPageIndex(6);
              home.destQuestion = question;
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  question.imageUrl == null
                      ? Container(
                    padding: const EdgeInsets.all(70.0),
                    height: 200.0,
                    child: Image.asset(
                      'assets/images/logo_horizontal.png',
                  ),
                      ) : Image.network(
                    question.imageUrl!,
                    height: 200.0,
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      question.tags.isEmpty ? Container() :
                      Flexible(
                        child: SthepText(
                          question.tags.map((e) => '#$e').join('  '),
                          size: 10.0,
                          color: Palette.hyperColor,
                          overflow: true,
                        ),
                      ),
                      SthepText(
                        Time(t: question.regDate!).toString(),
                        size: 10.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        SthepText(
                          '${question.id}',
                          size: 12.0,
                          color: Palette.fontColor2,
                        ),
                        const SizedBox(width: 10.0),
                        SthepText(question.title),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyFirebase.readOnce(
                          path: 'users',
                          id: question.questionerUid,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) return Container();
                            var loadData = snapshot.data.data();
                            return simpleProfile(SthepUser.fromJson(loadData));
                          },
                        ),
                      ),
                      const Icon(Icons.comment_rounded, size: 20.0),
                      const SizedBox(width: 5.0),
                      SthepText('${question.answers.length}', size: 15.0),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 30,
          top: 10,
          child: AdoptStateIcon(state: question.state),
        ),
      ],
    );
  }
}

class QuestionTile extends StatelessWidget {
  const QuestionTile({
    Key? key,
    required this.question,
    required this.onPressed,
  }) : super(key: key);

  final Question question;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(5.0),
      title: Card(
        elevation: 8.0,
        child: InkWell(
          onTap: () {
            Materials home = Provider.of<Materials>(context, listen: false);
            Navigator.pop(context);
            home.setPageIndex(6);
            home.destQuestion = question;
          },
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
                      height: 40.0,
                      child: Row(
                        children: [
                          for(String tag in question.tags)
                          SthepText('#$tag  ', size: 14.0, color: Palette.hyperColor)
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100.0,
                          alignment: Alignment.centerRight,
                          child: AdoptStateIcon(
                            state: question.state,
                          ),
                        ),
                        Container(
                          width: 50.0,
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.all(20.0),
                          child: SthepText(
                            '${question.id}',
                            size: 15.0,
                            color: Palette.fontColor2,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: SthepText(question.title, overflow: true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 150.0,
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.all(20.0),
                child: MyFirebase.readOnce(
                  path: 'users',
                  id: question.questionerUid,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Container();
                    var loadData = snapshot.data.data();
                    return simpleProfile(SthepUser.fromJson(loadData));
                  },
                ),
              ),
              Container(
                width: 70.0,
                margin: const EdgeInsets.all(20.0),
                child: SthepText(
                  Time(t: question.regDate!).toString(),
                  size: 10.0,
                  color: Colors.grey,
                ),
              ),
              Container(
                width: 50.0,
                margin: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.comment_rounded, size: 20.0),
                    const SizedBox(width: 5.0),
                    SthepText('${question.answers.length}', size: 15.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
