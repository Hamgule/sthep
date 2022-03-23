import 'package:flutter/material.dart';
import 'package:sthep/global/global.dart';
import 'package:sthep/page/main_page/main_page.dart';

void main() {
  runApp(const MyApp());

  // Categories c = Categories();
  // await c.loadJson();
  // c.toMap();
  // print(c.find('공학'));
  // print(c.next('대학>자연과학계열>생활과학'));

  // Exp e = Exp();
  // print(e.totalValue);
  // print(e.level);
  // print(e.value);
  // print(e.exp);

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}