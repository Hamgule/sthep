import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sthep/global/global.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/page/main/my/my_materials.dart';

bool isGrid = true;
late bool animFin;
const duration = Duration(seconds: 2);

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MainPageState();
}

class _MainPageState extends State<MyPage> {
  @override
  void initState() {
    animFin = false;
    super.initState();
  }

  Future animate() async =>
      await Future.delayed(Duration.zero, () => setState(() => animFin = true));

  @override
  Widget build(BuildContext context) {
    tempUser.exp.setExp(102.0);

    animate();

    questions.addAll([
        Question(id: 3, questioner: tempUser, title: 'Q1',),
        Question(id: 12, questioner: tempUser, title: 'Q2',),
        Question(id: 42, questioner: tempUser, title: 'Q3',),
    ]);

    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: myInfoArea(tempUser),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myThreeActivities(questions.getRange(0, 3).toList(), '나의 질문'),
              SizedBox(width: 70.0, height: screenSize.width * .10,),
              myThreeActivities(questions.getRange(0, 3).toList(), '나의 답변'),
            ],
          ),
        ),
      ],
    );
  }
}