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
    Materials materials = Provider.of<Materials>(context);

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
        materials.searchButton(context),
        materials.listGridToggleButton(),
        user.logged ? materials.drawerButton() : materials.loginButton(context),
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
    SthepUser user = Provider.of<SthepUser>(context);
    Materials materials = Provider.of<Materials>(context);

    List<String> modTitles = const ['질문', '질문 수정하기', '답변하기', '답변 수정하기'];
    String? modTitle;
    int? qid;

    if (modTitles.contains(title)) {
      if (materials.destQuestion != null) {
        modTitle = materials.destQuestion!.title;
        qid = materials.destQuestion!.id;
      }
    }

    return AppBar(
      backgroundColor: Palette.appbarColor,
      foregroundColor: Palette.iconColor,
      centerTitle: false,
      title: Row(
        children: [
          SthepText(
            title + (modTitle == null ? '' : ': '),
            size: 25.0,
            color: Palette.iconColor,
          ),
          const SizedBox(width: 15.0),
          if (modTitle != null)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Palette.bgColor.withOpacity(.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SthepText(
                  '$qid',
                  size: 15.0,
                  color: Palette.fontColor2,
                ),
                const SizedBox(width: 10.0),
                SthepText(
                  modTitle,
                  size: 20.0,
                  color: Palette.iconColor,
                ),
              ],
            ),
          ),
        ],
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
        materials.searchButton(context),
        materials.listGridToggleButton(),
        user.logged
            ? materials.drawerButton()
            : materials.loginButton(context),
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
    Materials materials = Provider.of<Materials>(context);

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
        materials.searchTags.isEmpty && materials.searchKeyword == ''
            ? Container() : IconButton(
          onPressed: () {
            materials.clearFilteredQuestions();

            materials.questions.forEach((question) {
              if (materials.searchKeyword == '') {
                for (var tag in materials.searchTags) {
                  if (!question.tags.contains(tag)) {
                    return;
                  }
                }
                materials.addSearchedQuestion(question);
              }
              else if (question.toSearchString(materials.allows).contains(materials.searchKeyword)) {
                for (var tag in materials.searchTags) {
                  if (!question.tags.contains(tag)) {
                    return;
                  }
                }
                materials.addSearchedQuestion(question);
              }
            });
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appbarHeight);
}
