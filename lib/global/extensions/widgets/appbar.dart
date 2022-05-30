import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/logo/logo.dart';
import 'package:sthep/model/user/user.dart';

const double appbarHeight = 60.0;

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(appbarHeight);

  @override
  Widget build(BuildContext context) {
    SthepUser user = Provider.of<SthepUser>(context);

    TextEditingController nicknameController = TextEditingController();

    Future inputNickname() async {
      await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            titlePadding: EdgeInsets.zero,
            title: Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Palette.bgColor.withOpacity(.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0),
                ),
              ),
              child: const SthepText('닉네임을 입력하세요.'),
            ),
            content: TextFormField(
              controller: nicknameController,
            ),
            actions: [
              TextButton(
                child: const Text("확인"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
    Widget searchButton() => StatefulBuilder(
      builder: (context, setState) {
        return IconButton(
          onPressed: () {
            Materials search = Provider.of<Materials>(context, listen: false);
            search.searchKeyword = '';
            search.searchTags = [];
            search.filteredQuestions = [];
            Navigator.pushNamed(context, '/Search');
          },
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
      return StatefulBuilder(
        builder: (context, setState) => IconButton(
          onPressed: () => Scaffold.of(context).openEndDrawer(),
          icon: const Icon(Icons.menu),
        ),
      );
    }

    Widget loginButton() {
      return IconButton(
        onPressed: () async {
          try { await user.sthepLogin(); }
          catch (e) {
            if (user.nickname == null) {
              await inputNickname();
              user.setNickname(nicknameController.text.trim());
            }
            user.updateDB();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 1000),
                content: Text('\'${user.nickname}\'님 환영합니다.'),
              ),
            );
          }
        }, icon: const Icon(Icons.login),
      );
    }

    return AppBar(
      backgroundColor: Palette.appbarColor,
      foregroundColor: Palette.iconColor,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Image.asset(
              Logo.asset,
              fit: BoxFit.contain,
              width: 110,
            ),
          ),
          if (title != null)
          SthepText(
            ' - $title',
            size: 25.0,
            color: Palette.iconColor,
          ),
        ],
      ),
      actions: [
        searchButton(),
        listGridToggleButton(),
        user.logged ? drawerButton() : loginButton(),
      ],
    );
  }
}

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.appbarColor,
      foregroundColor: Palette.iconColor,
      centerTitle: false,
      title: SthepText(
        title,
        size: 25.0,
        color: Palette.iconColor,
      ),
      leading: Consumer<Materials>(
        builder: (context, upload, _) {
          return IconButton(
            onPressed: () => upload.setPageIndex(upload.pageIndex),
            icon: const Icon(Icons.arrow_back_ios),
          );
        }
      ),
      actions: [
        StatefulBuilder(
          builder: (context, setState) => IconButton(
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appbarHeight);
}


class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.appbarColor,
      foregroundColor: Palette.iconColor,
      centerTitle: false,
      title: SthepText(
        title,
        size: 25.0,
        color: Palette.iconColor,
      ),
      actions: [
        StatefulBuilder(
          builder: (context, setState) => IconButton(
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appbarHeight);
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.appbarColor,
      foregroundColor: Palette.iconColor,
      centerTitle: false,
      title: const SthepText(
        '검색',
        size: 25.0,
        color: Palette.iconColor,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      iconTheme: const IconThemeData(color: Palette.iconColor),
      actions: [
        Consumer<Materials>(
          builder: (context, search, _) {
            return search.searchTags.isEmpty && search.searchKeyword == ''
                ? Container() : IconButton(
              onPressed: () {
                Materials search = Provider.of<Materials>(context, listen: false);
                search.clearFilteredQuestions();

                search.questions.forEach((question) {
                  if (search.searchKeyword == '') {
                    for (var tag in search.searchTags) {
                      if (!question.tags.contains(tag)) {
                        return;
                      }
                    }
                    search.addSearchedQuestion(question);
                  }
                  else if (question.toSearchString().contains(search.searchKeyword)) {
                    for (var tag in search.searchTags) {
                      if (!question.tags.contains(tag)) {
                        return;
                      }
                    }
                    search.addSearchedQuestion(question);
                  }
                });
              },
              icon: const Icon(Icons.search),
            );
          }
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appbarHeight);
}
