import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_painter/image_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/answer.dart';
import 'package:sthep/model/question/question.dart';

class AnswerCreatePage extends StatefulWidget {
  const AnswerCreatePage({Key? key}) : super(key: key);

  @override
  State<AnswerCreatePage> createState() => _AnswerCreatePageState();
}

class _AnswerCreatePageState extends State<AnswerCreatePage> {
  late Question targetQuestion;

  static const double canvasPadding = 5.0;

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

    upload.newAnswer = Answer();
    upload.newAnswer.imageUrl = upload.destQuestion!.imageUrl;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(canvasPadding),
                child: SizedBox(
                  width: screenSize.width,
                  child: upload.image == null
                      ? upload.newAnswer.imageUrl == null
                      ? const SthepText('이미지를 선택하세요')
                      : ImagePainter.network(
                    upload.newAnswer.imageUrl!,
                    width: 300,
                    height: 500,
                    key: upload.imageKey,
                    scalable: true,
                    initialStrokeWidth: 2,
                    //textDelegate: DutchTextDelegate(),
                    initialColor: Colors.black,
                    initialPaintMode: PaintMode.freeStyle,
                  ) : Image.file(upload.image!, fit: BoxFit.fitWidth)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}