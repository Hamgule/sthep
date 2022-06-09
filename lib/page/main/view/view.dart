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
    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    final PageController pageCont = PageController();
    DateTime regDate = materials.destQuestion!.regDate!;
    DateTime modDate = materials.destQuestion!.modDate!;
    String showDate = Time.dateFormat(modDate)
        + (Time.isConcurrent(regDate, modDate) ? '' : ' (수정됨)');

    List<Widget> sliderPages = [
      Container(
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
                        materials.destQuestion!.questioner.exp.levelToString(),
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
                            profilePhoto(materials.destQuestion!.questioner),
                            const SizedBox(width: 10),
                            SthepText(
                              '${materials.destQuestion!.questioner.nickname} 님의 질문',
                              size: 17.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    AdoptStateIcon(state: materials.destQuestion!.state),
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
                  for (var tag in materials.destQuestion!.tags)
                    TagButton(
                      '#$tag',
                      size: 18.0,
                      onPressed: () {
                        materials.searchTags = [];
                        materials.addTag(tag);
                        materials.filteredQuestions = [];

                        materials.questions.forEach((question) {
                          for (var tag in materials.searchTags) {
                            if (!question.tags.contains(tag)) {
                              return;
                            }
                          }
                          materials.addSearchedQuestion(question);
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
                child: materials.destQuestion!.imageUrl == null
                    ? Container() : Image.network(
                  materials.destQuestion!.imageUrl!,
                  width: 800.0,
                  height: 400.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    if (materials.destQuestion == null) return Container();

    materials.destQuestion!.answers.forEach((answer) {
      DateTime regDate = answer.regDate!;
      DateTime modDate = answer.modDate!;
      String showDate = Time.dateFormat(modDate)
          + (Time.isConcurrent(regDate, modDate) ? '' : ' (수정됨)');

      sliderPages.add(
        Container(
          color: (answer.adopted ? Palette.adopted : Palette.notAdopted).withOpacity(.2),
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
                    for (var tag in materials.destQuestion!.tags)
                    TagButton(
                      '#$tag',
                      size: 18.0,
                      onPressed: () {
                        materials.searchTags = [];
                        materials.addTag(tag);
                        materials.filteredQuestions = [];

                        materials.questions.forEach((question) {
                          for (var tag in materials.searchTags) {
                            if (!question.tags.contains(tag)) {
                              return;
                            }
                          }
                          materials.addSearchedQuestion(question);
                        });
                        Navigator.pushNamed(context, '/Search');
                      },
                    )
                  ],
                ),
              ),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   child: SizedBox(
              //     child: answer.imageUrl == null
              //         ? Container() : Image.network(
              //       answer.imageUrl!,
              //       width: 500.0,
              //       height: 300.0,
              //     ),
              //   ),
              // ),
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
                materials.destAnswer = null;
                materials.setViewFABState(
                    user.uid == materials.destQuestion!.questionerUid
                        ? FABState.myQuestion
                        : FABState.comment
                );
                return;
              }
              materials.destAnswer = materials.destQuestion!.answers[index - 1];
              if (user.uid == materials.destQuestion!.questionerUid) {
                materials.setViewFABState(FABState.adopt);
              }
              else {
                materials.setViewFABState(
                  user.uid == materials.destAnswer!.answererUid
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
