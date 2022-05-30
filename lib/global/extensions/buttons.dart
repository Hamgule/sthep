/*
   반복적으로 사용되는 기능을 위젯으로 재정의 (Buttons)
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/widgets.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

// 설정 버튼
class SettingButton extends StatelessWidget {
  const SettingButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.settings,
        color: Palette.iconColor,
        size: 18.0,
      ),
    );
  }
}

// 태그 버튼
class TagButton extends StatelessWidget {
  const TagButton(
    this.text, {
    Key? key,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: SthepText(
        text,
        color: Palette.hyperColor,
        size: size,
      ),
    );
  }
}

class FAB extends StatefulWidget {
  const FAB({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {

  @override
  Widget build(BuildContext context) {
    Materials main = Provider.of<Materials>(context, listen: false);
    SthepUser user = Provider.of<SthepUser>(context, listen: false);

    void onPressed() async {
      Map<String, dynamic>? data = await MyFirebase.readData(
          'autoIncrement', 'question');
      int nextId = data!['currentId'] + 1;

      bool isNum(int n) => main.newPageIndex == n;

      if (main.newPageIndex < 3) {
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

      // Upload Page
      else if (isNum(5)) {
        if (main.newQuestion.title == '') {
          showMySnackBar(context, '제목을 입력하세요');
          return;
        }

        main.toggleUploadingState();

        if (main.image != null) {
          await main.saveImage();
          main.newQuestion.imageUrl = await MyFirebase.uploadImage(
            'questions',
            main.newQuestion.idToString(),
            main.image,
          );
        }

        main.toggleUploadingState();

        Map<String, dynamic> addData = main.newQuestion.toJson();

        addData['regDate'] = FieldValue.serverTimestamp();

        MyFirebase.write(
          'questions',
          main.newQuestion.idToString(),
          addData,
        );

        main.setPageIndex(0);
        MyFirebase.write('autoIncrement', 'question', {'currentId': nextId});
      }
      else if (isNum(7)) {

        main.newQuestion = main.destQuestion!;

        if (main.newQuestion.title == '') {
          showMySnackBar(context, '제목을 입력하세요');
          return;
        }

        main.toggleUploadingState();

        if (main.image != null) {
          await main.saveImage();
          main.newQuestion.imageUrl = await MyFirebase.uploadImage(
            'questions',
            main.newQuestion.idToString(),
            main.image,
          );
        }

        main.toggleUploadingState();

        Map<String, dynamic> addData = main.newQuestion.toJson();

        addData['modDate'] = FieldValue.serverTimestamp();

        MyFirebase.write(
          'questions',
          main.newQuestion.idToString(),
          addData,
        );

        main.setPageIndex(0);
        MyFirebase.write('autoIncrement', 'question', {'currentId': nextId});
      }
    }
    return FloatingActionButton(
      onPressed: onPressed,
      child: widget.child,
      backgroundColor: Palette.iconColor,
    );
  }
}

// ViewPage 의 floating action button
class ViewFAB extends StatelessWidget {
  const ViewFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 80.0,
      children: [
        ActionButton(
          onPressed: () {
            Materials main = Provider.of<Materials>(context, listen: false);
            main.setPageIndex(7);
            main.image = null;
          },
          icon: const Icon(Icons.edit),
        ),
        ActionButton(
          onPressed: () {
            Materials main = Provider.of<Materials>(context, listen: false);
            MyFirebase.remove('questions', main.destQuestion!.idToString());
            main.setPageIndex(0);
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}

