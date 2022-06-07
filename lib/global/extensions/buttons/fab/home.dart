import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    void onPressed() async {
      if (!user.logged) {
        showMySnackBar(context, '로그인이 필요합니다.');
        return;
      }

      materials.image = null;
      materials.newQuestion = Question(
        questioner: user,
        questionerUid: user.uid!,
      );

      materials.gotoPage('questionCreate');
    }

    return SingleFAB(child: const Icon(Icons.edit), onPressed: onPressed);
  }
}