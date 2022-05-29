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
import 'package:sthep/page/main/notification/notification_materials.dart';
import 'package:sthep/page/widget/profile.dart';

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          elevation: 10.0,
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: InkWell(
            onTap: () {
              Materials home = Provider.of<Materials>(context, listen: false);
              home.setPageIndex(6);
              home.destQuestion = widget.question;
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.question.imageUrl == null
                      ? Container(
                    padding: const EdgeInsets.all(70.0),
                    height: 200.0,
                    child: Image.asset(
                      'assets/images/logo_horizontal.png',
                  ),
                      ) : Image.network(
                    widget.question.imageUrl!,
                    height: 200.0,
                  ),
                  const SizedBox(height: 10.0),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        SthepText(
                          '${widget.question.id}',
                          size: 12.0,
                          color: Palette.fontColor2,
                        ),
                        const SizedBox(width: 10.0),
                        SthepText(widget.question.title),
                      ],
                    ),
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
                      SthepText('${widget.question.answers.length}', size: 15.0),
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
          child: AdoptStateIcon(state: widget.question.state),
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
