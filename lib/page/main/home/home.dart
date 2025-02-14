import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
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
  bool loaded = false;
  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    List<double> randomWidthsInCard = [];
    List<double> randomWidthsInList = [];

    for (int i = 0; i < 3; i++) {
      randomWidthsInCard.add(math.Random().nextInt(180) + 100);
      randomWidthsInList.add(math.Random().nextInt(8) * 20 + 60);
    }

    if (!loaded) {
      materials.refresh(context);
      setState(() => loaded = true);
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
                    height: 180.0,
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
                              width: 400.0,
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
                    Expanded(
                      child: Container(
                        width: 180.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: Palette.bgColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
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

    void onRefresh() async {
      materials.refresh(context);
      await user.getNotifications();

      setState(() {});

      await Future.delayed(const Duration(milliseconds: 1000));
      refreshController.refreshCompleted();
    }

    void onLoading() async {
      refreshController.loadComplete();
    }

    showWidget = materials.isGrid ? emptyCard : emptyTile;

    if (materials.visQuestions.isNotEmpty) {
      showWidget = materials.isGrid ? GridView.count(
        padding: const EdgeInsets.all(30.0),
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        children: materials.visQuestions.map(
          (question) => QuestionCard(question: question),
        ).toList(),
      ) : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        itemCount: materials.visQuestions.length,
        itemExtent: 120.0,
        itemBuilder: (context, index) {
          return QuestionTile(
            question: materials.visQuestions[index],
            onPressed: () {
              materials.gotoPage('view');
              materials.setDestQuestion(materials.visQuestions[index]);
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
