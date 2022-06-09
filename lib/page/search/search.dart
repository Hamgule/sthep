import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/global/extensions/widgets/appbar.dart';
import 'package:sthep/page/main/home/home_materials.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    this.keyword,
    this.tags,
  }) : super(key: key);

  final String? keyword;
  final List<String>? tags;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController wordCont = TextEditingController();
  final TextEditingController tagCont = TextEditingController();
  late FocusNode _focusNode;

  List<String> checkboxTexts = ['질문 번호', '제목', '작성자', '내용'];

  @override
  void initState() {
    if (mounted)  _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);

    return Scaffold(
      appBar: const SearchAppBar(),
      body: Container(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SthepText('검색어: '),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SthepText(wordCont.text == ''
                                  ? '<미입력>' : wordCont.text, color: Palette.hyperColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SthepText('검색 태그: '),
                          Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SthepText(materials.searchTags.isEmpty
                                    ? '<미입력>' : materials.searchTags.map((tag) => '#$tag').join(' '),
                                  color: Palette.hyperColor,
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < 4; i++)
                    GestureDetector(
                      onTap: () => materials.toggleAllow(i),
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: Palette.hyperColor,
                            value: materials.allows[i],
                            onChanged: (_) => materials.toggleAllow(i),
                          ),
                          SthepText(
                            checkboxTexts[i],
                            color: materials.allows[i]
                                ? Palette.fontColor1
                                : Palette.fontColor2
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Column(
                  children: [
                    TextFormField(
                      controller: wordCont,
                      decoration: const InputDecoration(
                        hintText: '검색어를 입력하세요',
                      ),
                      onChanged: (text) => setState(() {
                        materials.setKeyword(text);
                      }),
                    ),
                    const SizedBox(height: 20.0),
                    TagEditor(
                      length: materials.searchTags.length,
                      controller: tagCont,
                      focusNode: _focusNode,
                      delimiters: const [',', ' '],
                      hasAddButton: true,
                      resetTextOnSubmitted: true,
                      onSubmitted: (outstandingValue) {
                        if (mounted) {
                          setState(() {
                            if (!materials.searchTags.contains(outstandingValue)) {
                              materials.searchTags.add(outstandingValue);
                            }
                          });
                        }
                      },
                      inputDecoration: const InputDecoration(
                        hintText: '태그를 입력하세요',
                      ),
                      onTagChanged: (tag) {
                        if (mounted) {
                          setState(() {
                            if (!materials.searchTags.contains(tag)) {
                              materials.addTag(tag);
                            }
                          });
                        }
                      },
                      tagBuilder: (context, index) => TagChip(
                        index: index,
                        label: materials.searchTags[index],
                        onDeleted: (index) {
                          if (mounted) {
                            setState(() => materials.removeTag(index));
                          }
                        },
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                itemCount: materials.filteredQuestions.length,
                itemExtent: 120.0,
                itemBuilder: (context, index) {
                  return QuestionTile(
                    question: materials.filteredQuestions[index],
                    onPressed: () {
                      Navigator.pop(context);
                      materials.gotoPage('view');
                      materials.setDestQuestion(materials.filteredQuestions[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
