import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/buttons/tag.dart';
import 'package:sthep/global/extensions/icons/icons.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/time/time.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/global/extensions/widgets/profile.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    Materials view = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    final PageController pageCont = PageController();
    DateTime regDate = view.destQuestion!.regDate!;
    DateTime modDate = view.destQuestion!.modDate!;
    String showDate = Time.dateFormat(modDate)
        + (Time.isConcurrent(regDate, modDate) ? '' : ' (수정됨)');

    List<Widget> sliderPages = [
      Container(
        color: Palette.bgColor.withOpacity(.2),
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
                        view.destQuestion!.questioner.exp.levelToString(),
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
                            profilePhoto(view.destQuestion!.questioner),
                            const SizedBox(width: 10),
                            SthepText(
                              '${view.destQuestion!.questioner.nickname} 님의 질문',
                              size: 17.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    AdoptStateIcon(state: view.destQuestion!.state),
                  ],
                ),
                SthepText(
                  showDate,
                  size: 15.0,
                  color: Palette.fontColor2,
                ),
              ],
            ),
            SizedBox(
              height: 60.0,
              child: Row(
                children: [
                  for (var tag in view.destQuestion!.tags)
                    TagButton(
                      '#$tag',
                      size: 18.0,
                      onPressed: () {
                        view.searchTags = [];
                        view.addTag(tag);
                        view.filteredQuestions = [];

                        view.questions.forEach((question) {
                          for (var tag in view.searchTags) {
                            if (!question.tags.contains(tag)) {
                              return;
                            }
                          }
                          view.addSearchedQuestion(question);
                        });
                        Navigator.pushNamed(context, '/Search');
                      },
                    )
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                child: view.destQuestion!.imageUrl == null
                    ? Container() : Image.network(
                  view.destQuestion!.imageUrl!,
                  width: 500.0,
                  height: 300.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    if (view.destQuestion == null) return Container();

    view.destQuestion!.answers.forEach((answer) {
      DateTime regDate = answer.regDate!;
      DateTime modDate = answer.modDate!;
      String showDate = Time.dateFormat(modDate)
          + (Time.isConcurrent(regDate, modDate) ? '' : ' (수정됨)');

      sliderPages.add(
        Container(
          padding: const EdgeInsets.all(30.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          answer.answerer.exp.levelToString(),
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
                              profilePhoto(answer.answerer),
                              const SizedBox(width: 10),
                              SthepText(
                                '${answer.answerer.nickname} 님의 답변',
                                size: 17.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SthepText(
                    showDate,
                    size: 15.0,
                    color: Palette.fontColor2,
                  ),
                ],
              ),
              SizedBox(
                height: 60.0,
                child: Row(
                  children: [
                    for (var tag in view.destQuestion!.tags)
                      TagButton(
                        '#$tag',
                        size: 18.0,
                        onPressed: () {
                          Materials search = Provider.of<Materials>(context, listen: false);
                          search.searchTags = [];
                          search.addTag(tag);
                          search.filteredQuestions = [];

                          search.questions.forEach((question) {
                            for (var tag in search.searchTags) {
                              if (!question.tags.contains(tag)) {
                                return;
                              }
                            }
                            search.addSearchedQuestion(question);
                          });
                          Navigator.pushNamed(context, '/Search');
                        },
                      )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: answer.imageUrl == null
                      ? Container() : Image.network(
                    answer.imageUrl!,
                    width: 500.0,
                    height: 300.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    return Center(
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SmoothPageIndicator(
                  controller: pageCont,
                  count: sliderPages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Palette.iconColor,
                    dotColor: Colors.grey.withOpacity(.4),
                  ),
                ),
              ),
            ),
          ),
          PageView.builder(
            controller: pageCont,
            itemCount: sliderPages.length,
            itemBuilder: (_, index) {
              return sliderPages[index % sliderPages.length];
            },
            onPageChanged: (index) {
              if (index == 0) {
                view.destAnswer = null;
                view.setViewFABState(
                    user.uid == view.destQuestion!.questionerUid
                        ? FABState.myQuestion
                        : FABState.comment
                );
                return;
              }
              view.destAnswer = view.destQuestion!.answers[index - 1];
              if (user.uid == view.destQuestion!.questionerUid) {
                view.setViewFABState(FABState.adopt);
              }
              else {
                view.setViewFABState(
                  user.uid == view.destAnswer!.answererUid
                      ? FABState.myAnswer
                      : FABState.comment,
                );
              }

            },
          ),
        ],
      ),
    );
  }
}
