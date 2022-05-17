import 'package:flutter/material.dart';
import 'package:sthep/global/extensions/widgets.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(30.0),
      width: 1000,
      height: 400,
      child: const SthepText('', size: 17.0),
    );
  }
}
