import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
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
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController titleCont = TextEditingController();
  final TextEditingController tagCont = TextEditingController();
  late Question targetQuestion;

  String scannedText = "";
  bool copied = false;

  Future<XFile?> pickImage() async {
    try {
      return await ImagePicker().pickImage(source: ImageSource.gallery);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
    scannedText = "";
    return null;
  }

  bool textScanning = false;

  XFile? imageFile;

  void getRecognisedText(XFile image, Materials materials) async {
    materials.toggleLoading();
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints.cast<Offset>();
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          scannedText += element.text + ' ';
        }
      }
      materials.newQuestion.content = scannedText;
    }
    materials.toggleLoading();
    setState(() {});
    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);
    targetQuestion = materials.newQuestion;

    return Scaffold(
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
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
                          setState(() => materials.imageKey = GlobalKey<ImagePainterState>());
                          setState(() => materials.image = File(xFile.path));
                          getRecognisedText(xFile, materials);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: scannedText.isEmpty? screenSize.width * .8 : screenSize.width * .5,
                    height: screenSize.height * .6,
                    child: materials.image == null
                        ? ImagePainter.network(
                      Question.defaultBlankPaper,
                      width: 150,
                      height: 500,
                      key: materials.imageKey,
                      scalable: true,
                      initialStrokeWidth: 2,
                      //textDelegate: DutchTextDelegate(),
                      initialColor: Colors.black,
                      initialPaintMode: PaintMode.freeStyle,
                    ) : ImagePainter.file(
                      materials.image!,
                      width: 150,
                      height: 500,
                      key: materials.imageKey,
                      scalable: true,
                      initialStrokeWidth: 2,
                      //textDelegate: DutchTextDelegate(),
                      initialColor: Colors.black,
                      initialPaintMode: PaintMode.freeStyle,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (textScanning) const CircularProgressIndicator(),
                      if (scannedText.isNotEmpty)
                      SizedBox(
                        width: screenSize.width * .4,
                        height: screenSize.height * .6,
                        child: Column(
                          children: [
                            Container(
                              color: Palette.hyperColor.withOpacity(0.3),
                              width: screenSize.width * .4,
                              height: 55,
                              child: Row(
                                children: [
                                  const SizedBox(width: 50.0),
                                  const Expanded(child: Center(child: SthepText('인식된 Text'))),
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () async {
                                      setState(() => copied = true);
                                      await Future.delayed(const Duration(milliseconds: 500), () {
                                        setState(() => copied = false);
                                      });
                                      Clipboard.setData(
                                        ClipboardData(text: scannedText),
                                      );
                                      showMySnackBar(
                                        context,
                                        '클립보드에 복사되었습니다.',
                                        type: 'success',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: AnimatedContainer(
                                  padding: const EdgeInsets.all(20.0),
                                  duration: const Duration(milliseconds: 100),
                                  child: Text(
                                    scannedText,
                                    style: TextStyle(
                                      color: copied ? Palette.hyperColor : Palette.fontColor1,
                                      fontSize: scannedText.length > 300 ? 14 : 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
