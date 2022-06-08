import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/exp.dart';

class QuestionCreateFAB extends StatelessWidget {
  const QuestionCreateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);

    void onPressed() async {
      if (materials.newQuestion.title == '') {
        showMySnackBar(context, '제목을 입력하세요');
        return;
      }

      materials.toggleLoading();

      await materials.saveImage();

      materials.newQuestion.id = await materials.newQuestion.getNextId();
      materials.newQuestion.imageUrl = await MyFirebase.uploadImage(
        'questions',
        materials.newQuestion.qidToString(),
        materials.image,
      );

      materials.toggleLoading();

      materials.newQuestion.createDB();

      materials.toggleIsChanged();

      showMySnackBar(
        context,
        '${materials.newQuestion.id}번 질문을 등록했습니다.',
        type: 'success',
      );

      materials.newQuestion.questioner.gainExp(Exp.createQuestion);
      showMySnackBar(context, Exp.visualizeForm(Exp.createQuestion), type: 'exp', ignoreBefore: false);

      materials.gotoPage('home');
    }

    return SingleFAB(child: const Icon(Icons.upload), onPressed: onPressed);
  }
}
