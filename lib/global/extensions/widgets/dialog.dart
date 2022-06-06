import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets/text.dart';

Future<String?> showMyInputDialog(BuildContext context, {
  required String title,
}) async {
  TextEditingController textCont = TextEditingController();
  String? inputText;

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Palette.bgColor.withOpacity(.3),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        child: SthepText(title),
      ),
      content: TextFormField(
        controller: textCont,
      ),
      actions: [
        TextButton(
          child: const Text("확인"),
          onPressed: () {
            inputText = textCont.text;
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );

  return inputText;
}

Future<bool> showMyYesNoDialog(BuildContext context, {
  required String title,
}) async {
  bool pressedValue = false;

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Palette.bgColor.withOpacity(.3),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        child: SthepText(title),
      ),
      actions: [
        TextButton(
          child: const Text('취소'),
          onPressed: () {
            pressedValue = false;
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('확인'),
          onPressed: () {
            pressedValue = true;
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );

  return pressedValue;
}