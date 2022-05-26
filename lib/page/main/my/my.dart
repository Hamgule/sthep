import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/page/main/home/home_materials.dart';
import 'package:sthep/page/main/my/my_materials.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/model/user/user.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  static late bool animFin;
  static const duration = Duration(seconds: 2);

  @override
  State<MyPage> createState() => _MainPageState();
}

class _MainPageState extends State<MyPage> {
  @override
  void initState() {
    MyPage.animFin = false;
    super.initState();
  }

  Future animate() async => await Future.delayed(
      Duration.zero, () => setState(() => MyPage.animFin = true));

  @override
  Widget build(BuildContext context) {
    tempUser.exp.setExp(102.0);

    animate();

    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context, listen: false);
    materials.questions = List.generate(
      100,
      (index) => Question(
        id: index,
        title: '$index',
        questionerUid: '',
        regDate: DateTime.now(),
      ),
    );

    return Column(
      children: [
        Center(
          child: SizedBox(
            child: MyFirebase.readContinuously(
                path: 'users',
                builder: (context, snapshot) {
                  List<int> questions = [];
                  // snapshot.data?.docs.forEach(
                  //   (doc) {
                  //     var data = doc.data()! as Map<String, dynamic>;
                  //     SthepUser u = SthepUser.fromJson(data);
                  //     print(u.nickname);
                  //     print(u.name);
                  //     print(u.questions.length);
                  //
                  //   },
                  // );
                  return Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: myInfoArea(tempUser),
                  );
                }),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myThreeActivities(
                  materials.questions.getRange(0, 3).toList(), '나의 질문'),
              SizedBox(
                width: 70.0,
                height: screenSize.width * .10,
              ),
              myThreeActivities(
                  materials.questions.getRange(0, 3).toList(), '나의 답변'),
            ],
          ),
        ),
      ],
    );
  }
}
