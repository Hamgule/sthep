import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/user.dart';

class ViewFAB extends StatefulWidget {
  // NOT CONSTANT
  ViewFAB({Key? key}) : super(key: key);

  @override
  State<ViewFAB> createState() => _ViewFABState();
}

class _ViewFABState extends State<ViewFAB> {
  late Materials main = Provider.of<Materials>(context, listen: false);
  late SthepUser user = Provider.of<SthepUser>(context, listen: false);

  @override
  Widget build(BuildContext context) {

    void questionEditPressed() {
      main.setPageIndex(7);
      main.toggleIsChanged();
      main.image = null;
    }

    void questionDelPressed() async {
      MyFirebase.remove('questions', main.destQuestion!.qidToString());

      main.toggleLoading();

      if (main.destQuestion!.imageUrl != null) {
        await MyFirebase.removeImage(
            'questions', main.destQuestion!.qidToString());
      }
      main.toggleLoading();
      main.toggleIsChanged();

      main.setPageIndex(0);

      showMySnackBar(context, '질문을 삭제했습니다.', type: 'success');
    }

    void answerEditPressed() {
      main.setPageIndex(9);
      main.toggleIsChanged();
    }

    void answerDelPressed() async {
      if (main.destAnswer == null) return;
      MyFirebase.remove('answers', main.destAnswer!.aidToString());

      main.toggleLoading();

      // if (main.destAnswer!.imageUrl != null) {
      //   await MyFirebase.removeImage(
      //       'answers', main.destAnswer!.aidToString());
      // }
      main.toggleLoading();
      main.toggleIsChanged();

      main.destQuestion!.answers.removeWhere((answer) => answer.id == main.destAnswer!.id);
      main.destQuestion!.answererUids.remove(main.destAnswer!.answererUid);
      main.destQuestion!.answerIds.remove(main.destAnswer!.id);

      main.destQuestion!.updateState();

      MyFirebase.write(
        'questions',
        main.destQuestion!.qidToString(),
        main.destQuestion!.toJson(),
      );

      MyFirebase.remove('answers', main.destAnswer!.aidToString());

      main.setPageIndex(6);
      main.setViewFABState(FABState.comment);

      showMySnackBar(context, '질문을 삭제했습니다.', type: 'success');
    }

    if (main.destQuestion == null) {
      SingleFAB(child: const Icon(Icons.question_mark), onPressed: () {});
    }

    if (main.viewFABState == FABState.myQuestion) {
      return MultiFAB(
        children: [
          ActionButton(
            onPressed: questionEditPressed,
            icon: const Icon(Icons.edit),
          ),
          ActionButton(
            onPressed: questionDelPressed,
            icon: const Icon(Icons.delete),
          ),
        ],
      );
    }

    else if (main.viewFABState == FABState.adopt) {
      return SingleFAB(
        child: const Icon(Icons.thumb_up),
        onPressed: () {},
      );
    }

    else if (main.viewFABState == FABState.comment) {
      return SingleFAB(
        child: const Icon(Icons.comment),
        onPressed: () {
          if (!user.logged) {
            showMySnackBar(context, '로그인이 필요합니다.');
            return;
          }

          if (main.destQuestion!.answererUids.contains(user.uid)) {
            showMySnackBar(context, '이미 답변을 달았습니다.', type: 'error');
            return;
          }

          main.setPageIndex(8);
          main.image = null;
        },
      );
    }

    else if (main.viewFABState == FABState.myAnswer) {
      return MultiFAB(
        children: [
          ActionButton(
            onPressed: answerEditPressed,
            icon: const Icon(Icons.edit),
          ),
          ActionButton(
            onPressed: answerDelPressed,
            icon: const Icon(Icons.delete),
          ),
        ],
      );
    }

    return Container();
  }
}