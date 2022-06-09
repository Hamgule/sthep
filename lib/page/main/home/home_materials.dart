import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/icons/icons.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/time/time.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/global/extensions/widgets/profile.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    return Stack(
      children: [
        Card(
          elevation: 8.0,
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: InkWell(
            onTap: () {
              materials.gotoPage('view');
              materials.destQuestion = question;

              materials.setViewFABState(
                  user.uid == materials.destQuestion!.questionerUid
                      ? FABState.myQuestion
                      : FABState.comment
              );
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
                        Flexible(child: SthepText(question.title)),
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
                      SthepText('${question.answerIds.length}', size: 15.0),
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
          onTap: onPressed,
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
                            child: SthepText(question.title),
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
                    SthepText('${question.answerIds.length}', size: 15.0),
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
