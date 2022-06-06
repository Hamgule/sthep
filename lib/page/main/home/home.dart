import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/answer.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/activity.dart';
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

    List<double> randomWidthsInCard = [];
    List<double> randomWidthsInList = [];

    for (int i = 0; i < 3; i++){
      randomWidthsInCard.add(math.Random().nextInt(200) + 100);
      randomWidthsInList.add(math.Random().nextInt(8) * 20 + 60);
    }

    Widget emptyCard = GridView.count(
      padding: const EdgeInsets.all(30.0),
      crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
      children: [
        Card(
          color: Colors.white,
          elevation: 8.0,
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: Palette.bgColor.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: SthepText(
                        '해당 자료가 없습니다.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (double width in randomWidthsInCard)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOutBack,
                          width: width,
                          height: 10.0,
                          decoration: BoxDecoration(
                            color: Palette.bgColor.withOpacity(.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Palette.bgColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Container(
                        width: 80.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color: Palette.bgColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    Widget emptyTile = ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      itemCount: 1,
      itemExtent: 120.0,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.all(5.0),
          title: Card(
            color: Colors.white,
            elevation: 8.0,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            for (double width in randomWidthsInList)
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeInOut,
                                width: width,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  color: Palette.bgColor.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 30.0),
                              width: 60.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                color: Palette.bgColor.withOpacity(.2),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Container(
                              width: 50.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Palette.bgColor.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Container(
                              width: 450.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Palette.bgColor.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10.0),
                                child: const SthepText('해당 자료가 없습니다'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 35.0),
                    Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Palette.bgColor.withOpacity(.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Container(
                          width: 80.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            color: Palette.bgColor.withOpacity(.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 50.0),
                    Container(
                      width: 180.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Palette.bgColor.withOpacity(.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Widget showWidget = Container();

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

      materials.myQuestions.forEach((question) {
        List<MyActivity> myActivities = [];
        myActivities.add(MyActivity(type: ActivityType.question, id: question.id));
        user.activities[question.regDate as DateTime] = myActivities;
      });


      materials.myAnsweredQuestion.forEach((answer) {
        List<MyActivity> myActivities = [];
        myActivities.add(MyActivity(type: ActivityType.answer, id: answer.id));
        user.activities[answer.regDate as DateTime] =  myActivities;
      });
    });
    user.activities.forEach((date, activity) {
      print(date);
      activity.forEach((element) {
        print(element);
      });
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

    showWidget = materials.isGrid ? emptyCard : emptyTile;

    if (visQuestions.isNotEmpty) {
      showWidget = materials.isGrid ? GridView.count(
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
      );
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
      child: showWidget,
    );
  }
}
