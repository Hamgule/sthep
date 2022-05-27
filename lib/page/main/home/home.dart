import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/main/home/home_materials.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    this.type = 'default',
  }) : super(key: key);

  final String type;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;
    Materials materials = Provider.of<Materials>(context);

    return Consumer<Materials>(
      builder: (context, home, _) {
        return Column(
          children: [
            const Ranking(),
            Expanded(
              child: MyFirebase.readContinuously(
                path: 'questions',
                builder: (context, snapshot) {
                  materials.questions = [];
                  SthepUser user = Provider.of<SthepUser>(context);
                  
                  snapshot.data?.docs.forEach((doc) async {
                    var data = doc.data()! as Map<String, dynamic>;
                    Question q = Question.fromJson(data);

                    if (widget.type == 'question') {
                      if (user.uid != q.questionerUid) {
                        return;
                      }
                    }
                    else if (widget.type == 'answer') {
                      if (q.answers.isEmpty) return;
                      q.answers.forEach((answer) async {
                        if (user.uid != (await answer.get()).data()['answererUid']) {
                          return;
                        }
                      });
                    }
                    materials.questions.add(q);
                  },
                );
                return GridView.count(
                  padding: const EdgeInsets.all(30.0),
                  crossAxisCount: 3,
                  children: materials.questions.map(
                  (question) => QuestionCard(question: question),
                  ).toList(),
                );
              }),
            ),
          ],
        );
      }
    );
  }
}

