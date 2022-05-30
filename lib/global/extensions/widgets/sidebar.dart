import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/buttons/setting.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/global/extensions/widgets/profile.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Consumer<SthepUser>(
                      builder: (context, user, _) {
                        return user.logged ? InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              profile(user),
                              const Expanded(child: SizedBox()),
                              SettingButton(onPressed: () {}),
                            ],
                          ),
                        ) : InkWell(
                          onTap: () async {
                            // await user.sthepLogin();
                            // await inputNickname();
                            // user.setNickname(nicknameController.text);
                            // user.updateDB();
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
                        );
                      }
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Palette.bgColor.withOpacity(.3),
              ),
            ),
          ),

          //Step 3, set child widgets in drawer
          const ListTile(
            title: Text('계정',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          const Divider(
            height: 1.0,
            thickness: 1.5,
            indent: 20.0,
            endIndent: 20.0,
          ),
          const ListTile(title: Text('로그아웃')),
          const ListTile(title: Text('회원 탈퇴')),
          const  ListTile(title: Text('내 활동')),
          const ListTile(
            title: Text('마이페이지',
                style: TextStyle(fontSize: 20.0, color: Colors.black)),
          ),
          const Divider(
            height: 1.0,
            thickness: 1.5,
            indent: 20.0,
            endIndent: 20.0,
          ),
          const ListTile(title: Text('내 질문')),
          const ListTile(title: Text('내 답변')),
        ],
      ),
    );
  }
}

