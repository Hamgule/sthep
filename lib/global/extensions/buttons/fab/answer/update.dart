import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';

class AnswerUpdateFAB extends StatelessWidget {
  const AnswerUpdateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);

    void onPressed() async {
      materials.newAnswer = materials.destAnswer!;

      materials.toggleLoading();

      await materials.saveImage();

      materials.newAnswer.imageUrl = await MyFirebase.uploadImage(
        'answers',
        materials.newAnswer.aidToString(),
        materials.image,
      );

      materials.toggleLoading();

      materials.newAnswer.updateDB(updateModDate: true);

      showMySnackBar(
        context,
        '답변을 수정했습니다.',
        type: 'success',
      );

      materials.gotoPage('view');

      materials.destQuestion!.questioner.notify('answerUpdated', materials.destQuestion!);
    }

    return SingleFAB(child: const Icon(Icons.upload), onPressed: onPressed);
  }
}