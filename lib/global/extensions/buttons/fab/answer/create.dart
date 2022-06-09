import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/exp.dart';

class AnswerCreateFAB extends StatelessWidget {
  const AnswerCreateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);

    void onPressed() async {
      materials.toggleLoading();

      await materials.saveImage();

      materials.newAnswer.id = await materials.newAnswer.getNextId();
      materials.newAnswer.imageUrl = await MyFirebase.uploadImage(
        'answer',
        materials.newAnswer.aidToString(),
        materials.image,
      );

      materials.toggleLoading();

      materials.newAnswer.createDB();

      showMySnackBar(context, '답변을 추가했습니다.', type: 'success');

      materials.newAnswer.answerer.gainExp(Exp.createAnswer);
      showMySnackBar(context, Exp.visualizeForm(Exp.createAnswer), type: 'exp', ignoreBefore: false);

      materials.toggleIsChanged();
      materials.gotoPage('view');

      materials.destQuestion!.addAnswer(materials.newAnswer);
      materials.destQuestion!.questioner.notify('answered', materials.destQuestion!);
    }

    return SingleFAB(child: const Icon(Icons.upload), onPressed: onPressed);
  }
}