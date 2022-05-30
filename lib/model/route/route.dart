import 'package:flutter/material.dart';
import 'package:sthep/page/comingsoon/comingsoon_page.dart';
import 'package:sthep/page/main/home/home.dart';
import 'package:sthep/page/search/search.dart';

class Routes {
  static Map<String, Widget> get all => const {
    '/': HomePage(),
    // '/Question': QuestionPage(),
    // '/Answer': AnswerPage(),
    // '/Notification': NotificationPage(),
    // '/My': MyPage(),
    '/Search': SearchPage(),
    '/?': ComingSoonPage(),
  };
  // static List<String> get bottomBar => const [
  //   '/', '/Question', '/Answer', '/Notification', '/My',
  // ];

  static bool exist(String route) => all.containsKey(route);
}