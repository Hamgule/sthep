import 'package:flutter/material.dart';
import 'package:sthep/global/extensions/widgets.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

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
                  decoration: const BoxDecoration(
                    color: Palette.notAdopted,
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
                child: const Align(
                    child: SthepText('Q', color: Colors.white),
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
                        child: SthepText(
                          '#${tempQuestion.id}', size: 15.0,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SthepText(
                          tempQuestion.title,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 600,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Align(
                      child: SthepText(
                        '새로운 답변이 달렸습니다.',
                        size: 25.0,
                      ),
                      alignment: Alignment.centerLeft),
                ),
              ),
              const SizedBox(
                width: 100,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Align(
                      child: SthepText(
                        '5분전',
                        size: 15.0,
                        color: Palette.hyperColor,
                      ),
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
