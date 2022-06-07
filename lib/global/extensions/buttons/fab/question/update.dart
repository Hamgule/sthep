import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';

class QuestionUpdateFAB extends StatelessWidget {
  const QuestionUpdateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);

    void onPressed() async {
      materials.newQuestion = materials.destQuestion!;

      if (materials.newQuestion.title == '') {
        showMySnackBar(context, '제목을 입력하세요');
        return;
      }

      materials.toggleLoading();

      await materials.saveImage();

      materials.newQuestion.imageUrl = await MyFirebase.uploadImage(
        'questions',
        materials.newQuestion.qidToString(),
        materials.image,
      );

      materials.toggleLoading();

      materials.newQuestion.updateDB(updateModDate: true);

      showMySnackBar(
        context,
        '질문을 수정했습니다.',
        type: 'success',
      );

      materials.gotoPage('home');
    }
    return SingleFAB(child: const Icon(Icons.upload), onPressed: onPressed);
  }
}