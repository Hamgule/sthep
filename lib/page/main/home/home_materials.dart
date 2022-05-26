import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/icons.dart';
import 'package:sthep/global/extensions/widgets.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/time/time.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/widget/profile.dart';

SthepUser tempUser = SthepUser(
  uid: 'zihoo1234',
  name: '양지후',
  email: 'asdf@asdf.com',
  nickname: 'zihoo',
);

Question tempQuestion = Question(
  id: 1,
  title: '2016년도 수능 알려주세요..',
  imageUrl: 'assets/images/math.jpeg',
  questionerUid: tempUser.uid!,
);



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
              height: 100.0,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: SthepText(
                      '오늘의 최다 답변자',
                      size: 20.0,
                      color: Palette.fontColor1,
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    color: Colors.yellow,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  profile(tempUser),
                  const SizedBox(width: 30),
                  Container(
                    width: 30,
                    height: 30,
                    color: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  profile(tempUser),
                  const SizedBox(width: 30),
                  Container(
                    width: 30,
                    height: 30,
                    color: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  profile(tempUser),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  AdoptState state = AdoptState.notAnswered;

  void changeState() {
    if (widget.question.adoptedAnswerId != null) {
      state = AdoptState.adopted;
    } else if (widget.question.answerIds.isNotEmpty) {
      state = AdoptState.notAdopted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          elevation: 10.0,
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: InkWell(
            onTap: () {},
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      widget.question.tags.isEmpty ? Container() :
                      Flexible(
                        child: SthepText(
                          widget.question.tags.map((e) => '#$e').join('  '),
                          size: 10.0,
                          color: Palette.hyperColor,
                          overflow: true,
                        ),
                      ),
                      SthepText(
                        Time(t: widget.question.regDate!).toString(),
                        size: 10.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SthepText(widget.question.title),
                      const SizedBox(height: 50.0),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyFirebase.readOnce(
                          path: 'users',
                          id: widget.question.questionerUid,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) return Container();
                            var loadData = snapshot.data.data();
                            return simpleProfile(SthepUser.fromJson(loadData));
                          },
                        ),
                      ),
                      const Icon(Icons.comment_rounded, size: 20.0),
                      const SizedBox(width: 5.0),
                      SthepText('${widget.question.answerIds.length}', size: 15.0),
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
          child: MyFirebase.readContinuously(
            path: 'questions',
            id: widget.question.idToString(),
            builder: (context, snapshot) {
              if (snapshot.data == null) return Container();
              var loadData = snapshot.data.data();
              Materials materials = Provider.of<Materials>(context);
              materials.getQuestionById(loadData['id']);
              changeState();
              return AdoptStateIcon(state: state);
            },
          ),
        ),
      ],
    );
  }
}

class QuestionList extends StatelessWidget {
  const QuestionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(

    );
  }
}
