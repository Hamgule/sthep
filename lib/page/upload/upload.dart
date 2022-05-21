import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:sthep/global/extensions/widgets.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}



class _UploadPageState extends State<UploadPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _tags = TextEditingController();
  final List<String> _values = [];

  PickedFile? _image;

  void _onDelete(index) => setState(() => _values.removeAt(index));

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        width: 1400,
        height: 800,
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: 600,
              child: TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  hintText: '질문을 입력하세요',
                ),
              ),
            ),
            SizedBox(
              width: 600,
              child: TagEditor(
                length: _values.length,
                controller: _tags,
                focusNode: _focusNode,
                delimiters: const [',', ' '],
                hasAddButton: true,
                resetTextOnSubmitted: true,
                onSubmitted: (outstandingValue) {
                  setState(() => _values.add(outstandingValue));
                },
                inputDecoration: const InputDecoration(
                  hintText: '태그를 입력하세요...',
                ),
                onTagChanged: (newValue) => setState(() => _values.add(newValue)),
                tagBuilder: (context, index) => _Chip(
                  index: index,
                  label: _values[index],
                  onDeleted: _onDelete,
                ),
                // InputFormatters example, this disallow \ and /
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
                ],
              ),
            ),
            SizedBox(
              height: 300.0,
              child: Center(
                child: _image == null
                    ? const SthepText('이미지가 없습니다.')
                    : Image.file(File(_image!.path)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add_a_photo,
                    size: 40.0,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 50,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.wallpaper,
                    size: 40.0,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
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
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
