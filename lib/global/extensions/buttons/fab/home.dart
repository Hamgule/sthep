import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials main = Provider.of<Materials>(context, listen: false);
    SthepUser user = Provider.of<SthepUser>(context, listen: false);

    void onPressed() async {
      Map<String, dynamic>? data = await MyFirebase.readData(
          'autoIncrement', 'question');
      int nextId = data!['currentId'] + 1;

      if (!user.logged) {
        showMySnackBar(context, '로그인이 필요합니다.');
        return;
      }

      main.setPageIndex(5);
      main.newQuestion = Question(
        id: nextId,
        questionerUid: user.uid!,
      );
      main.image = null;
    }

    return SingleFAB(child: const Icon(Icons.edit), onPressed: onPressed);
  }
}