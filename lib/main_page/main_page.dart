import 'package:flutter/material.dart';

PreferredSizeWidget mainPageAppBar = AppBar(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  title:
    Image.asset(
      'assets/images/logo_horizontal.png',
      fit: BoxFit.contain,
      width: 150,
    ),
  actions: const [
    Icon(Icons.search,),
    Icon(Icons.list,),
    Icon(Icons.window,),
  ],

);


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainPageAppBar,
    );
  }
}
