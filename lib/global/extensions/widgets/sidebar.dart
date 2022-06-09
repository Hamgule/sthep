import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/setting.dart';
import 'package:sthep/global/extensions/widgets/dialog.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/user/exp.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/global/extensions/widgets/profile.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    void myPagePressed() {
      materials.gotoPage('my');
      Navigator.pop(context);
    }

    void settingPressed() {}

    void loginPressed() async {
      try { await user.sthepLogin(); }
      catch (e) { return; }

      if (user.nickname == null) {
        while (true) {
          Navigator.pop(context);
          await materials.inputNickname(context);
          if (materials.nicknameInput == null) {
            showMySnackBar(context, '로그인에 실패했습니다. 다시 로그인 해주세요.', type: 'error');
            return;
          }
          if (materials.nicknameInput != '') break;
          showMySnackBar(context, '올바른 닉네임을 입력하세요.', type: 'error');
        }

        user.setNickname(materials.nicknameInput!);
        user.updateDB();
        showMySnackBar(context, '\'${user.nickname}\'님 환영합니다.');

        user.gainExp(Exp.register);
        showMySnackBar(context, Exp.visualizeForm(Exp.register), type: 'exp', ignoreBefore: false);
      }
      else {
        showMySnackBar(context, '\'${user.nickname}\'님 로그인 되었습니다.');
        user.gainExp(Exp.login);
        showMySnackBar(context, Exp.visualizeForm(Exp.login), type: 'exp', ignoreBefore: false);

        materials.gotoPage('home');
      }
      user.toggleLogState();
    }

    void logoutPressed() {
      user.sthepLogout();
      Navigator.pop(context);
      materials.gotoPage('home');
      showMySnackBar(context, '로그아웃 되었습니다.', type: 'success');
    }

    void withdrawPressed() async {
      if (user.uid == null) return;

      bool withdrew = await showMyYesNoDialog(context, title: '정말 탈퇴하시겠습니까?');
      Navigator.pop(context);
      if (!withdrew) {
        showMySnackBar(context, '취소하였습니다.');
        return;
      }

      MyFirebase.remove('users', user.uid!);
      materials.gotoPage('home');
      showMySnackBar(context, '\'${user.nickname}\'님이 탈퇴되었습니다.', type: 'success');
      user.sthepLogout();
    }

    void notificationPressed() {
      Navigator.pop(context);
      materials.gotoPage('notifications');
    }

    void myQuestionPressed() {
      Navigator.pop(context);
      materials.gotoPage('myQuestions');
    }

    void myAnswerPressed() {
      Navigator.pop(context);
      materials.gotoPage('myAnswers');
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
                    onTap: myPagePressed,
                    child: Row(
                      children: [
                        profile(user),
                        const Expanded(child: SizedBox()),
                        SettingButton(onPressed: settingPressed),
                      ],
                    ),
                  ) : InkWell(
                    onTap: loginPressed,
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
            children: [
              const ListTile(
                title: SthepText('계정'),
              ),
              const Divider(
                height: 1.0,
                indent: 20.0,
                thickness: 1.5,
                endIndent: 20.0,
              ),
              SidebarTile(title: '로그아웃', onPressed: logoutPressed),
              SidebarTile(title: '회원 탈퇴', onPressed: withdrawPressed),
              SidebarTile(title: '알림', onPressed: notificationPressed),
              SidebarTile(title: '마이페이지', onPressed: myPagePressed),
              const Divider(
                height: 1.0,
                indent: 20.0,
                thickness: 1.5,
                endIndent: 20.0,
              ),
              SidebarTile(title: '내 질문', onPressed: myQuestionPressed),
              SidebarTile(title: '내 답변', onPressed: myAnswerPressed),
            ],
          ),
        ],
      ),
    );
  }
}

class SidebarTile extends StatelessWidget {
  const SidebarTile({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        splashFactory: InkSplash.splashFactory,
        // overlayColor: MaterialStateProperty.all(Palette.bgColor.withOpacity(.1)),
      ),
      child: ListTile(
        title: SthepText(
          title,
          size: 14.0,
          color: Palette.fontColor2,
        ),
      ),
    );
  }
}

