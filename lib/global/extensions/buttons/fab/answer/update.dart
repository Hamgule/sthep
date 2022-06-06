import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/user.dart';

class AnswerUpdateFAB extends StatelessWidget {
  const AnswerUpdateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials main = Provider.of<Materials>(context, listen: false);
    SthepUser user = Provider.of<SthepUser>(context, listen: false);

    void onPressed() async {

      main.toggleLoading();

      await main.saveImage();
      main.newAnswer = main.destAnswer!;
      main.newAnswer.imageUrl = await MyFirebase.uploadImage(
        'answer',
        main.newAnswer.aidToString(),
        main.image,
      );

      main.newAnswer.answererUid = user.uid!;
      Map<String, dynamic> updateData = main.newAnswer.toJson();

      updateData['modDate'] = FieldValue.serverTimestamp();
      main.newAnswer.modDate = DateTime.now();

      main.toggleLoading();

      MyFirebase.write(
        'answers',
        main.newAnswer.aidToString(),
        updateData,
      );

      main.destQuestion!.answers.forEach((answer) {
        if (answer.id == main.newAnswer.id) answer = main.newAnswer;
      });

      main.toggleIsChanged();
      main.setPageIndex(6);

      showMySnackBar(context, '답변을 수정했습니다.', type: 'success');
    }

    return SingleFAB(child: const Icon(Icons.upload), onPressed: onPressed);
  }
}