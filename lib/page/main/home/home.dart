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
                child: MyFirebase.readOnce(
                  path: 'questions',
                  builder: (context, snapshot) {
                    materials.questions = [];
                    SthepUser user = Provider.of<SthepUser>(context);

                    snapshot.data?.docs.forEach((doc) async {
                      var questionData = doc.data()! as Map<String, dynamic>;
                      Question q = Question.fromJson(questionData);

                      if (widget.type == 'question') {
                        if (user.uid != q.questionerUid) {
                          return;
                        }
                      }

                      else if (widget.type == 'answer') {
                        bool answered = false;
                        q.answererUids.forEach((answererUid) {
                          if (user.uid == answererUid) {
                            print(user.uid);
                            print(answererUid);
                            answered = true; return;
                          }
                        });
                        if (!answered) return;
                      }
                      materials.questions.add(q);
                    });

                    return materials.isGrid ? GridView.count(
                      padding: const EdgeInsets.all(30.0),
                      crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
                      children: materials.questions.map(
                            (question) => QuestionCard(question: question),
                      ).toList(),
                    ) : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      itemCount: materials.questions.length,
                      itemExtent: 120.0,
                      itemBuilder: (context, index) {
                        return QuestionTile(
                          question: materials.questions[index],
                          onPressed: () {
                            Materials home = Provider.of<Materials>(context, listen: false);
                            home.setPageIndex(6);
                            home.destQuestion = materials.questions[index];
                          },
                        );
                      },
                    );
                  }),
              ),
            ],
          );
        }
    );
  }
}
