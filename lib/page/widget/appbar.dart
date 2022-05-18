import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/logo/logo.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget searchButton() => StatefulBuilder(
      builder: (context, setState) {
        return IconButton(
          onPressed: () => Navigator.pushNamed(context, '/Search'),
          icon: const Icon(Icons.search),
        );
      },
    );

    Widget listGridToggleButton() {
      return Consumer<Materials>(
        builder: (context, home, _) => IconButton(
          onPressed: home.toggleGrid,
          icon: Icon(
            home.isGrid ? Icons.list_alt : Icons.window,
          ),
        ),
      );
    }

    Widget drawerButton() {
      return IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: const Icon(Icons.menu),
      );
    }

    return AppBar(
      backgroundColor: Palette.appbarColor,
      foregroundColor: Palette.iconColor,
      title: Image.asset(
        Logo.asset,
        fit: BoxFit.contain,
        width: 120,
      ),
      actions: [
        searchButton(),
        listGridToggleButton(),
        drawerButton(),
      ],
    );
  }
}
