import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/time/time.dart';

class QuestionUpdateFAB extends StatelessWidget {
  const QuestionUpdateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials main = Provider.of<Materials>(context, listen: false);

    void onPressed() async {
      main.newQuestion = main.destQuestion!;

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

      Map<String, dynamic> updateData = main.newQuestion.toJson();

      updateData['modDate'] = FieldValue.serverTimestamp();

      MyFirebase.write(
        'questions',
        main.newQuestion.qidToString(),
        updateData,
      );

      main.questions.forEach((question) {
        if (question.id == main.destQuestion!.id) question.modDate = DateTime.now();
      });


      main.setPageIndex(0);
      showMySnackBar(context, '질문을 수정했습니다.', type: 'success');
    }
    return SingleFAB(child: const Icon(Icons.upload), onPressed: onPressed);
  }
}