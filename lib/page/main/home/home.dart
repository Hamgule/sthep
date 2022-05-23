import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/page/main/home/home_materials.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
                  snapshot.data?.docs.forEach((doc) {
                    var data = doc.data()! as Map<String, dynamic>;
                    Question q = Question.fromJson(data);
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

