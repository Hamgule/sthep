import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sthep/model/route/route.dart';
import 'package:sthep/page/main/main.dart';

class Sthep extends StatelessWidget {
  const Sthep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sthep',
      home: const MainPage(),
      initialRoute: '/',
      onGenerateRoute: _getRoute,
      debugShowCheckedModeBanner: false,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    String route = settings.name ?? '';
    // Object args = settings.arguments ?? Object();

    Map<String, Widget> pages = Routes.all;
    Duration duration = const Duration(milliseconds: 100);

    if (!Routes.exist(route)) route = '/?';

    return PageTransition(
      child: pages[route]!,
      type: PageTransitionType.fade,
      duration: duration,
    );
  }
}