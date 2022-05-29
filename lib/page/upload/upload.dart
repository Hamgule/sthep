import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key, this.question}) : super(key: key);

  final Question? question;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController titleCont = TextEditingController();
  final TextEditingController tagCont = TextEditingController();

  late Question targetQuestion;

  static const double canvasPadding = 20.0;

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

    // Create
    if (widget.question == null) {
      targetQuestion = upload.newQuestion;
    }
    // Update
    else {
      targetQuestion = widget.question!;
      titleCont.text = targetQuestion.title;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextFormField(
                controller: titleCont,
                decoration: const InputDecoration(
                  hintText: '제목을 입력하세요',
                ),
                onChanged: (text) => targetQuestion.title = text,
              ),
              const SizedBox(height: 20.0),
              TagEditor(
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
                  if (mounted) {
                    setState(() {
                      if (!targetQuestion.tags.contains(newValue)) {
                        targetQuestion.tags.add(newValue);
                      }
                    });
                  }
                },
                tagBuilder: (context, index) => _Chip(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                    const SizedBox(width: 50),
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
              ),
              Stack(
                children: [
                  Container(
                    color: Palette.bgColor,
                    width: screenSize.width * .90,
                    height: 700.0,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.all(canvasPadding),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(canvasPadding),
                    child: SizedBox(
                      width: screenSize.width * .40,
                      child: widget.question == null
                          ? upload.image == null
                          ? const SthepText('이미지를 선택하세요')
                          : Image.file(upload.image!, fit: BoxFit.fitWidth)
                          : widget.question!.imageUrl == ''
                          ? const SthepText('이미지를 선택하세요')
                          : Image.network(widget.question!.imageUrl!, fit: BoxFit.fitWidth),
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

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () => onDeleted(index),
    );
  }
}
