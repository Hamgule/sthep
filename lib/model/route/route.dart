import 'package:flutter/material.dart';
import 'package:sthep/page/comingsoon/comingsoon_page.dart';

class Routes {
  static Map<String, Widget> get all => const {
    // '/': HomePage(),
    // '/Question': QuestionPage(),
    // '/Answer': AnswerPage(),
    // '/Notification': NotificationPage(),
    // '/My': MyPage(),
    '/?': ComingSoonPage(),
  };
  static List<String> get bottomBar => const [
    '/', '/Question', '/Answer', '/Notification', '/My',
  ];

  static bool exist(String route) => all.containsKey(route);
}