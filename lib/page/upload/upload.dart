import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets.dart';
import 'package:sthep/global/materials.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController titleCont = TextEditingController();
  final TextEditingController tagCont = TextEditingController();

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

    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<Materials>(
          builder: (context, upload, _) {
            return Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: titleCont,
                    decoration: const InputDecoration(
                      hintText: '제목을 입력하세요',
                    ),
                    onChanged: (text) => upload.newQuestion.title = text,
                  ),
                  const SizedBox(height: 20.0),
                  TagEditor(
                    length: upload.newQuestion.tags.length,
                    controller: tagCont,
                    focusNode: _focusNode,
                    delimiters: const [',', ' '],
                    hasAddButton: true,
                    resetTextOnSubmitted: true,
                    onSubmitted: (outstandingValue) {
                      if (mounted) {
                        setState(() {
                          if (!upload.newQuestion.tags.contains(outstandingValue)) {
                            upload.newQuestion.tags.add(outstandingValue);
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
                          if (!upload.newQuestion.tags.contains(newValue)) {
                            upload.newQuestion.tags.add(newValue);
                          }
                        });
                      }
                    },
                    tagBuilder: (context, index) => _Chip(
                      index: index,
                      label: upload.newQuestion.tags[index],
                      onDeleted: (index) {
                        if (mounted) {
                          setState(() {
                            upload.newQuestion.tags.removeAt(index);
                          });
                        }
                      },
                    ),
                    // InputFormatters example, this disallow \ and /
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
                            Icons.add_a_photo,
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
                          child: upload.image == null
                              ? const SthepText('이미지가 없습니다.')
                              : Image.file(upload.image!, fit: BoxFit.fitWidth),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
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
