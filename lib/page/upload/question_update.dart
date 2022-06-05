import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_painter/image_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController titleCont = TextEditingController();
  final TextEditingController tagCont = TextEditingController();

  late Question targetQuestion;

  Future<XFile?> pickImage() async {
    try {
      return await ImagePicker().pickImage(source: ImageSource.gallery);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Materials upload = Provider.of<Materials>(context);

    targetQuestion = upload.destQuestion!;
    titleCont.text = targetQuestion.title;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: screenSize.height *.8,
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: screenSize.width * .35,
                    child: TextFormField(
                      controller: titleCont,
                      decoration: const InputDecoration(
                        hintText: '제목을 입력하세요',
                      ),
                      onChanged: (text) => targetQuestion.title = text,
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width * .55,
                    child: TagEditor(
                      length: targetQuestion.tags.length,
                      controller: tagCont,
                      focusNode: _focusNode,
                      delimiters: const [',', ' '],
                      hasAddButton: true,
                      resetTextOnSubmitted: true,
                      onSubmitted: (outstandingValue) {
                        if (mounted) {
                          setState(() {
                            if (!targetQuestion.tags.contains(outstandingValue)) {
                              targetQuestion.tags.add(outstandingValue);
                            }
                          });
                        }
                      },
                      inputDecoration: const InputDecoration(
                        hintText: '태그를 입력하세요',
                      ),
                      onTagChanged: (newValue) {
                        String? msg;
                        if (mounted) {
                          setState(() {
                            if (targetQuestion.tags.contains(newValue)) {
                              msg = '태그는 중복될 수 없습니다.';
                            }
                            else if (newValue.length > 10) {
                              msg = '태그는 10글자를 초과할 수 없습니다.';
                            }
                            else if (targetQuestion.tags.length > 6) {
                              msg = '태그는 7개를 초과할 수 없습니다.';
                            }
                            if (msg != null) {
                              showMySnackBar(context, msg!, type: 'error');
                              return;
                            }
                            targetQuestion.tags.add(newValue);
                          });
                        }
                      },
                      tagBuilder: (context, index) => TagChip(
                        index: index,
                        label: targetQuestion.tags[index],
                        onDeleted: (index) {
                          if (mounted) {
                            setState(() {
                              targetQuestion.tags.removeAt(index);
                            });
                          }
                        },
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 40.0,
                          color: Palette.iconColor,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 50),
                      IconButton(
                        icon: const Icon(
                          Icons.photo,
                          size: 40.0,
                          color: Palette.iconColor,
                        ),
                        onPressed: () async {
                          XFile? xFile = await pickImage();
                          if (xFile == null) return;
                          setState(() => upload.image = File(xFile.path));
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: screenSize.width * .8,
                    height: screenSize.height * .6,
                    child: upload.image == null
                        ? upload.destQuestion!.imageUrl == null
                        ? const SthepText('이미지를 선택하세요')
                        : ImagePainter.network(
                      upload.destQuestion!.imageUrl!,
                      key: upload.imageKey,
                      scalable: true,
                      initialStrokeWidth: 2,
                      // textDelegate: DutchTextDelegate(),
                      initialColor: Colors.black,
                      initialPaintMode: PaintMode.freeStyle,
                    ) : Image.file(
                      upload.image!, fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}