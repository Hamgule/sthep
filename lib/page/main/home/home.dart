import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/answer.dart';
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
  List<Question> visQuestions = [];

  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    void getQuestions() async {
      materials.questions = [];
      var loadData = await MyFirebase.readCollection('questions');
      materials.questions.addAll(loadData.map((data) => Question.fromJson(data)).toList());
      materials.toggleIsChanged();
    }

    Future<SthepUser> getUser(String uid) async {
      var loadData = await MyFirebase.readData('users', uid);
      if (loadData == null) return SthepUser();
      return SthepUser.fromJson(loadData);
    }

    if (materials.questions.isEmpty || materials.isChanged) getQuestions();
    materials.myQuestions = [];
    materials.myAnsweredQuestion = [];

    materials.questions.forEach((question) {
      if (user.uid == question.questionerUid) {
        materials.myQuestions.add(question);
      }

      if (question.answererUids.contains(user.uid)) {
        materials.myAnsweredQuestion.add(question);
      }
    });

    materials.questions.forEach((question) async {
      question.questioner = await getUser(question.questionerUid);
      question.answers = [];

      question.answerIds.forEach((answerId) async {
        var data = await MyFirebase.readData('answers', Question.idToString(answerId));
        if (data == null) return;
        Answer tempAnswer = Answer.fromJson(data);
        tempAnswer.answerer = await getUser(tempAnswer.answererUid);
        question.answers.add(tempAnswer);
      });
    });

    visQuestions = [];
    if (materials.newPageIndex == 0) {
      visQuestions.addAll(materials.questions);
    }
    else if (materials.newPageIndex == 1) {
      visQuestions.addAll(materials.myQuestions);
    }
    else if (materials.newPageIndex == 2) {
      visQuestions.addAll(materials.myAnsweredQuestion);
    }

    void onRefresh() async {
      var loadData = await MyFirebase.readCollection('questions');
      materials.questions = [];
      materials.questions.addAll(loadData.map((data) => Question.fromJson(data)).toList());
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 1000));
      refreshController.refreshCompleted();
    }

    void onLoading() async {
      refreshController.loadComplete();
    }

    return SmartRefresher(
      header: const MaterialClassicHeader(
        color: Colors.white,
        backgroundColor: Palette.iconColor,
      ),
      enablePullDown: true,
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: materials.isGrid ? GridView.count(
        padding: const EdgeInsets.all(30.0),
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        children: visQuestions.map(
              (question) => QuestionCard(question: question),
        ).toList(),
      ) : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        itemCount: visQuestions.length,
        itemExtent: 120.0,
        itemBuilder: (context, index) {
          return QuestionTile(
            question: visQuestions[index],
            onPressed: () {
              Materials home = Provider.of<Materials>(context, listen: false);
              home.setPageIndex(6);
              home.setDestQuestion(visQuestions[index]);
            },
          );
        },
      ),
    );
  }
}
