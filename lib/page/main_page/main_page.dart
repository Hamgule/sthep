import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/page/my_page/my_page.dart';
import 'package:sthep/page/widget/sidebar.dart';

bool isGrid = true;

PreferredSizeWidget mainPageAppBar = AppBar(
  backgroundColor: Palette.appbarColor,
  foregroundColor: Palette.iconColor,
  title: Image.asset(
    'assets/images/logo_horizontal.png',
    fit: BoxFit.contain,
    width: 120,
  ),
  actions: [
    Builder(
      builder: (context) {
        return IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPage()));
        }, icon: const Icon(Icons.search));
      }
    ),
    StatefulBuilder(
      builder: (context, setState) => IconButton(
        onPressed: () => setState(() => isGrid = !isGrid),
        icon: Icon(
          isGrid ? Icons.list_alt : Icons.window,
        ),
      ),
    ),
    StatefulBuilder(
      builder: (context, setState) => IconButton(
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        icon: const Icon(Icons.menu),
      ),
    ),
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
      endDrawer: const SideBar(),
    );
  }
}