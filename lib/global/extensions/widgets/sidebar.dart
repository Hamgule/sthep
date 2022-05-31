import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/buttons/setting.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/global/extensions/widgets/profile.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

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

    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 200.0,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    alignment: Alignment.centerLeft,
                    child: const SthepText('나의 정보', color: Palette.fontColor2),
                  ),
                  const SizedBox(height: 50.0),
                  user.logged ? InkWell(
                    onTap: () {
                      Materials main = Provider.of<Materials>(context, listen: false);
                      main.setPageIndex(4);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        profile(user),
                        const Expanded(child: SizedBox()),
                        SettingButton(onPressed: () {}),
                      ],
                    ),
                  ) : InkWell(
                    onTap: () async {
                      try {
                        await user.sthepLogin();
                        if (user.nickname == null) return;
                        showMySnackBar(context, '\'${user.nickname}\'님 로그인 되었습니다.');
                        Navigator.pop(context);
                      }
                      catch (e) {
                        if (user.nickname == null) {
                          await inputNickname();
                          user.setNickname(nicknameController.text.trim());
                        }
                        user.updateDB();
                        showMySnackBar(context, '\'${user.nickname}\'님 환영합니다.');
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: const SthepText('GOOGLE 로그인'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Palette.bgColor.withOpacity(.3),
              ),
            ),
          ),

          if (user.logged)
          Column(
            children: const [
              ListTile(
                title: SthepText('계정'),
              ),
              Divider(
                height: 1.0,
                indent: 20.0,
                thickness: 1.5,
                endIndent: 20.0,
              ),
              ListTile(title: SthepText('로그아웃', size: 14.0, color: Palette.fontColor2)),
              ListTile(title: SthepText('회원 탈퇴', size: 14.0, color: Palette.fontColor2)),
              ListTile(title: SthepText('내 활동', size: 14.0, color: Palette.fontColor2)),
              ListTile(
                title: SthepText('마이페이지'),
              ),
              Divider(
                height: 1.0,
                indent: 20.0,
                thickness: 1.5,
                endIndent: 20.0,
              ),
              ListTile(title: SthepText('내 질문', size: 14.0, color: Palette.fontColor2)),
              ListTile(title: SthepText('내 답변', size: 14.0, color: Palette.fontColor2)),
            ],
          ),
        ],
      ),
    );
  }
}

