import 'package:flutter/material.dart';
import 'package:sthep/page/comingsoon/comingsoon_page.dart';
import 'package:sthep/page/main/home/home.dart';
import 'package:sthep/page/search/search.dart';

class Routes {
  static Map<String, Widget> get all => const {
    '/': HomePage(),
    '/Search': SearchPage(),
    '/?': ComingSoonPage(),
  };

  static bool exist(String route) => all.containsKey(route);
}