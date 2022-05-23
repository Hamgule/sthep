import 'package:flutter/material.dart';
import 'package:sthep/global/extensions/widgets.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/page/widget/profile.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/model/question/question.dart';
import 'package:intl/intl.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SthepUser user = SthepUser(
      uid: 'zihoo1234',
      name: '양지후',
      email: 'asdf@asdf.com',
      nickname: 'zihoo',
    );
    Question question = Question(
      id: 1,
      title: '2020년도 수학',
      questionerUid: '1234',
      imageUrl: 'test',
      regDate: DateTime.now(),
    );

    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: SthepText(
                  'Lv10',
                  size: 17.0,
                  color: Palette.fontColor2,
                ),
              ),
              SizedBox(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Row(
                    children: [
                      profilePhoto(user),
                      SthepText(
                        '${user.nickname}님의 질문',
                        size: 17.0,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: SthepText('#${question.id}', color: Palette.fontColor2),
              ),
              SizedBox(
                width: 600,
                child: SthepText(question.title),
              ),
              SizedBox(
                width: 150,
                child: SthepText(
                  DateFormat('yyyy-MM-dd').format(question.regDate!),
                  size: 17.0,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
                child: Image.network(
              'https://mblogthumb-phinf.pstatic.net/20141116_179/cherry2holic_1416118086274YqvdW_PNG/K-2.png?type=w2',
              width: 350,
              height: 450,
              fit: BoxFit.fill,
            )),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: FloatingActionButton(
                onPressed: () {
                  //const UploadPage();
                },
                child: const Icon(Icons.edit),
                backgroundColor: Palette.hyperColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
