import 'package:flutter/material.dart';
import 'package:sthep/global/global.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = '페이지 구성 자체를 많이 변경했어.\n'
        'MainPage 에 appBar 와 bottomBar 를 두고, bottomBar 아이콘을 클릭하면, 다른 Page 로 route 되는게 아닌, \n'
        'Scaffold body 에 들어가는 위젯이 교체되는 방식이야.\n'
        '즉, HomePage, MyPage 등의 class 는 실제 페이지 (Scaffold) 가 아니야.\n'
        '폴더 구조 보면 이해가 빠를거야.';

    return Container(
      padding: const EdgeInsets.all(30.0),
      width: 1000,
      height: 400,
      child: myText(message, 17.0, Colors.black),
    );
  }
}
