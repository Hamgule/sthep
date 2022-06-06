import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

class AnswerCreateFAB extends StatelessWidget {
  const AnswerCreateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials main = Provider.of<Materials>(context, listen: false);
    SthepUser user = Provider.of<SthepUser>(context, listen: false);

    void onPressed() async {
      Map<String, dynamic>? data = await MyFirebase.readData(
        'autoIncrement', 'answer',
      );
      int nextId = data!['currentId'] + 1;

      main.toggleLoading();

      await main.saveImage();

      main.newAnswer.id = nextId;
      main.newAnswer.answerer = user;
      main.newAnswer.answererUid = user.uid!;
      main.newAnswer.imageUrl = await MyFirebase.uploadImage(
        'answer',
        main.newAnswer.aidToString(),
        main.image,
      );

      showMySnackBar(context, '답변을 추가했습니다.', type: 'success');

      main.toggleLoading();

      Map<String, dynamic> addData = main.newAnswer.toJson();

      addData['regDate'] = FieldValue.serverTimestamp();
      addData['modDate'] = FieldValue.serverTimestamp();

      MyFirebase.write(
        'answers',
        main.newAnswer.aidToString(),
        addData,
      );

      main.toggleIsChanged();
      main.setPageIndex(6);
      MyFirebase.write('autoIncrement', 'answer', {'currentId': nextId});

      main.destQuestion!.answers.add(main.newAnswer);
      main.destQuestion!.answerIds.add(main.newAnswer.id);
      main.destQuestion!.answererUids.add(main.newAnswer.answererUid);
      main.destQuestion!.updateState();

      MyFirebase.write(
        'questions',
        main.destQuestion!.qidToString(),
        main.destQuestion!.toJson(),
      );

      SthepUser questioner = main.destQuestion!.questioner;

      questioner.notificationCount++;

      Map<String, dynamic> notificationData = {
        'id': questioner.notificationCount,
        'checked': false,
        'type': 'answered',
        'questionId': main.destQuestion!.id,
        'questionTitle': main.destQuestion!.title,
        'notice': '새로운 답변이 달렸습니다.',
      };

      notificationData['loggedDate'] = FieldValue.serverTimestamp();

      MyFirebase.f.collection('users')
          .doc(questioner.uid)
          .collection('notifications')
          .doc(Question.idToString(questioner.notificationCount))
          .set(notificationData);

      MyFirebase.write('users', questioner.uid!, questioner.toJson());
    }

    return SingleFAB(child: const Icon(Icons.upload), onPressed: onPressed);
  }
}