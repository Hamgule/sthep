import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/icons/icons.dart';
import 'package:sthep/global/extensions/widgets/dialog.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/answer.dart';
import 'package:sthep/model/user/user.dart';

class ViewFAB extends StatefulWidget {
  // NOT CONSTANT
  ViewFAB({Key? key}) : super(key: key);

  @override
  State<ViewFAB> createState() => _ViewFABState();
}

class _ViewFABState extends State<ViewFAB> {

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    void questionEditPressed() {
      if (materials.destQuestion!.state == FABState.adopt) {
        showMySnackBar(context, '채택완료된 질문은 수정할 수 없습니다.', type: 'error');
        return;
      }

      materials.toggleIsChanged();
      materials.gotoPage('questionUpdate');
    }

    void questionDelPressed() async {
      if (materials.destQuestion!.state != AdoptState.notAnswered) {
        showMySnackBar(context, '답변된 질문은 삭제할 수 없습니다.', type: 'error');
        return;
      }

      MyFirebase.remove('questions', materials.destQuestion!.qidToString());

      materials.toggleLoading();

      if (materials.destQuestion!.imageUrl != null) {
        await MyFirebase.removeImage(
            'questions', materials.destQuestion!.qidToString());
      }

      materials.toggleLoading();
      materials.toggleIsChanged();

      showMySnackBar(context, '질문을 삭제했습니다.', type: 'success');

      materials.gotoPage('home');
    }

    void answerEditPressed() {
      if (materials.destAnswer!.adopted) {
        showMySnackBar(context, '채택된 답변은 수정할 수 없습니다.', type: 'error');
        return;
      }

      materials.toggleIsChanged();
      materials.gotoPage('answerUpdate');
    }

    void answerDelPressed() async {
      if (materials.destAnswer == null) return;

      if (materials.destAnswer!.adopted) {
        showMySnackBar(context, '채택된 답변은 삭제할 수 없습니다.', type: 'error');
        return;
      }
      materials.toggleLoading();

      materials.destQuestion!.removeAnswer(materials.destAnswer!);
      materials.destAnswer!.removeDB();

      materials.toggleLoading();
      materials.toggleIsChanged();

      materials.setViewFABState(FABState.comment);
      materials.destQuestion!.questioner.notify('answerDeleted', materials.destQuestion!);

      showMySnackBar(context, '질문을 삭제했습니다.', type: 'success');
      materials.gotoPage('view');
    }

    void adoptPressed() async {
      if (materials.destAnswer!.adopted) {
        showMySnackBar(context, '이미 채택하였습니다.', type: 'error');
        return;
      }

      if (materials.destQuestion!.state == FABState.adopt) {
        showMySnackBar(context, '이미 채택된 질문입니다.', type: 'error');
        return;
      }

      bool adopted = await showMyYesNoDialog(context, title: '정말 채택하시겠습니까?');
      if (adopted) {
        materials.adopt();
        materials.destAnswer!.answerer.notify('adopted', materials.destQuestion!);
      }

      showMySnackBar(
        context,
        (adopted ? '채택' : '취소') + '되었습니다.',
        type: adopted ? 'success' : 'info',
      );

      materials.destQuestion!.updateDB();
      materials.destAnswer!.updateDB();
    }

    void commentPressed() {
      if (!user.logged) {
        showMySnackBar(context, '로그인이 필요합니다.');
        return;
      }

      if (materials.destQuestion!.state == FABState.adopt) {
        showMySnackBar(context, '이미 마감된 질문입니다.', type: 'error');
        return;
      }

      if (materials.destQuestion!.answererUids.contains(user.uid)) {
        showMySnackBar(context, '이미 답변을 달았습니다.', type: 'error');
        return;
      }

      materials.image = null;
      materials.newAnswer = Answer(answerer: user, answererUid: user.uid!);
      materials.newAnswer.imageUrl = materials.destQuestion!.imageUrl;

      materials.gotoPage('answerCreate');
    }

    if (materials.viewFABState == FABState.myQuestion) {
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

    else if (materials.viewFABState == FABState.adopt) {
      return SingleFAB(
        child: const Icon(Icons.check),
        onPressed: adoptPressed,
      );
    }

    else if (materials.viewFABState == FABState.comment) {
      return SingleFAB(
        child: const Icon(Icons.comment),
        onPressed: commentPressed,
      );
    }

    else if (materials.viewFABState == FABState.myAnswer) {
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

    return SingleFAB(
      child: const Icon(Icons.question_mark),
      onPressed: () {},
    );
  }
}