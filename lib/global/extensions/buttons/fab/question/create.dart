import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';

class QuestionCreateFAB extends StatelessWidget {
  const QuestionCreateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials main = Provider.of<Materials>(context, listen: false);

    void onPressed() async {
      Map<String, dynamic>? data = await MyFirebase.readData('autoIncrement', 'question',);
      int nextId = data!['currentId'] + 1;

      if (main.newQuestion.title == '') {
        showMySnackBar(context, '제목을 입력하세요');
        return;
      }

      main.toggleLoading();

      await main.saveImage();

      main.newQuestion.imageUrl = await MyFirebase.uploadImage(
        'questions',
        main.newQuestion.qidToString(),
        main.image,
      );

      main.toggleLoading();

      Map<String, dynamic> addData = main.newQuestion.toJson();

      addData['regDate'] = FieldValue.serverTimestamp();
      addData['modDate'] = FieldValue.serverTimestamp();

      MyFirebase.write(
        'questions',
        main.newQuestion.qidToString(),
        addData,
      );

      main.toggleIsChanged();
      main.setPageIndex(0);
      MyFirebase.write('autoIncrement', 'question', {'currentId': nextId});

      showMySnackBar(context, '${main.newQuestion.id}번 질문을 등록했습니다.', type: 'success');
    }

    return SingleFAB(child: const Icon(Icons.upload), onPressed: onPressed);
  }
}
