import 'package:flutter/material.dart';
import 'package:sthep/global/global.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/question/answer.dart';

bool isGrid = true;
User tempUser = User(
  id: 'zihoo1234',
  name: '양지후',
  nickname: 'zihoo',
  password: '',
);

Question tempQuestion = Question(
  id: 1,
  title: "이거 모르겠어요..",
  questioner: tempUser,
  image: Image.asset(
    'assets/images/math.jpeg',
    height: 200.0,
  ),
);

Answer tempAnswer = Answer(
  id: 1,
  answerer: tempUser,
  question: tempQuestion,
);

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: Palette.hyperColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Row(
            children: [
              //알림
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Palette.adoptNot,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xff5F68B7).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Align(
                    child: myText('Q', 20.0, Colors.white),
                    alignment: Alignment.center),
              ),
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: myText('#${tempQuestion.id}', 15.0, Colors.grey.withOpacity(0.7)),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: myText(tempQuestion.title, 25.0, Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 600,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Align(
                      child: myText('새로운 답변이 달렸습니다.', 25.0, Colors.black),
                      alignment: Alignment.centerLeft),
                ),
              ),
              SizedBox(
                width: 100,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Align(
                      child: myText('5분전', 15.0, Palette.hyperColor),
                      alignment: Alignment.centerLeft),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
