import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/icons/icons.dart';
import 'package:sthep/global/extensions/widgets/dialog.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
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
      if (main.destQuestion!.state == FABState.adopt) {
        showMySnackBar(context, '채택완료된 질문은 수정할 수 없습니다.', type: 'error');
        return;
      }

      main.setPageIndex(7);
      main.toggleIsChanged();
      main.image = null;
    }

    void questionDelPressed() async {
      if (main.destQuestion!.state != AdoptState.notAnswered) {
        showMySnackBar(context, '답변된 질문은 삭제할 수 없습니다.', type: 'error');
        return;
      }

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
      if (main.destAnswer!.adopted) {
        showMySnackBar(context, '채택된 답변은 수정할 수 없습니다.', type: 'error');
        return;
      }

      main.setPageIndex(9);
      main.toggleIsChanged();
    }

    void answerDelPressed() async {
      if (main.destAnswer == null) return;

      if (main.destAnswer!.adopted) {
        showMySnackBar(context, '채택된 답변은 삭제할 수 없습니다.', type: 'error');
        return;
      }
      main.toggleLoading();

      MyFirebase.remove('answers', main.destAnswer!.aidToString());

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

      SthepUser questioner = main.destQuestion!.questioner;

      questioner.notificationCount++;

      Map<String, dynamic> notificationData = {
        'id': user.notificationCount,
        'checked': false,
        'type': 'answerDeleted',
        'questionId': main.destQuestion!.id,
        'questionTitle': main.destQuestion!.title,
        'notice': '답변이 삭제되었습니다.',
      };

      notificationData['loggedDate'] = FieldValue.serverTimestamp();

      MyFirebase.f.collection('users')
          .doc(questioner.uid)
          .collection('notifications')
          .doc(Question.idToString(questioner.notificationCount))
          .set(notificationData);

      MyFirebase.write('users', questioner.uid!, questioner.toJson());
    }

    void adoptPressed() async {
      if (main.destAnswer!.adopted) {
        showMySnackBar(context, '이미 채택하였습니다.', type: 'error');
        return;
      }

      if (main.destQuestion!.state == FABState.adopt) {
        showMySnackBar(context, '이미 채택된 질문입니다.', type: 'error');
        return;
      }

      bool adopted = await showMyYesNoDialog(context, title: '정말 채택하시겠습니까?');
      if (adopted) {
        main.adopt();

        SthepUser answerer = main.destAnswer!.answerer;

        answerer.notificationCount++;

        Map<String, dynamic> notificationData = {
          'id': answerer.notificationCount,
          'checked': false,
          'type': 'adopted',
          'questionId': main.destQuestion!.id,
          'questionTitle': main.destQuestion!.title,
          'notice': '답변이 채택되었습니다.',
        };

        notificationData['loggedDate'] = FieldValue.serverTimestamp();

        MyFirebase.f.collection('users')
            .doc(answerer.uid)
            .collection('notifications')
            .doc(Question.idToString(answerer.notificationCount))
            .set(notificationData);

        MyFirebase.write('users', answerer.uid!, answerer.toJson());
      }

      showMySnackBar(
        context,
        (adopted ? '채택' : '취소') + '되었습니다.',
        type: adopted ? 'success' : 'info',
      );

      main.destQuestion!.adoptedAnswerId = main.destAnswer!.id;
      main.destQuestion!.updateState();

      MyFirebase.write(
        'questions',
        main.destQuestion!.qidToString(),
        main.destQuestion!.toJson(),
      );

      MyFirebase.write(
        'answers',
        main.destAnswer!.aidToString(),
        main.destAnswer!.toJson(),
      );
    }

    void commentPressed() {
      if (!user.logged) {
        showMySnackBar(context, '로그인이 필요합니다.');
        return;
      }

      if (main.destQuestion!.state == FABState.adopt) {
        showMySnackBar(context, '이미 마감된 질문입니다.', type: 'error');
        return;
      }

      if (main.destQuestion!.answererUids.contains(user.uid)) {
        showMySnackBar(context, '이미 답변을 달았습니다.', type: 'error');
        return;
      }

      main.setPageIndex(8);
      main.image = null;
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
        child: const Icon(Icons.check),
        onPressed: adoptPressed,
      );
    }

    else if (main.viewFABState == FABState.comment) {
      return SingleFAB(
        child: const Icon(Icons.comment),
        onPressed: commentPressed,
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