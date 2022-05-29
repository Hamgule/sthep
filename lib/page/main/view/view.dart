import 'package:flutter/material.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons.dart';
import 'package:sthep/global/extensions/widgets.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/widget/profile.dart';
import 'package:intl/intl.dart';

class ViewPage extends StatelessWidget {
  const ViewPage({Key? key, this.question}) : super(key: key);

  final Question? question;

  @override
  Widget build(BuildContext context) {
    return MyFirebase.readOnce(
      path: 'users',
      id: question!.questionerUid,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Positioned.fill(child: Center(
            child: CircularProgressIndicator(color: Palette.bgColor),
          ));
        }
        var data = snapshot.data.data();
        SthepUser user = SthepUser.fromJson(data);
        return Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SthepText(
                          user.exp.levelToString(),
                          size: 17.0,
                          color: Palette.fontColor2,
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: Row(
                            children: [
                              profilePhoto(user),
                              const SizedBox(width: 10),
                              SthepText(
                                '${user.nickname} 님의 질문',
                                size: 17.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SthepText(
                    DateFormat('yyyy-MM-dd hh:mm:ss').format(question!.regDate!),
                    size: 15.0,
                    color: Palette.fontColor2,
                  ),
                ],
              ),
              Container(
                height: 60.0,
                child: Row(
                  children: [
                    for (var tag in question!.tags)
                    TagButton(
                      '#$tag',
                      size: 15.0,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: question!.imageUrl == null
                      ? Container() : Image.network(
                    question!.imageUrl!,
                    width: 500.0,
                    height: 300.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
