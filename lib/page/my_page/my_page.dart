import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/global.dart';
import 'package:sthep/page/widget/profile.dart';
import 'package:sthep/page/widget/sidebar.dart';

bool isGrid = true;

PreferredSizeWidget myPageAppBar = AppBar(
  backgroundColor: Palette.appbarColor,
  foregroundColor: Palette.iconColor,
  centerTitle: false,
  title: myText('마이페이지', 25.0, Palette.iconColor,),
  actions: [
    StatefulBuilder(
      builder: (context, setState) => IconButton(
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        icon: const Icon(Icons.menu),
      ),
    ),
  ],
);

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MainPageState();
}

class _MainPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myPageAppBar,
      endDrawer: const SideBar(),
      body: Column(
        children: [
          Row(
            children: [myPageProfile,],
          ),
        ],
      ),
    );
  }
}
