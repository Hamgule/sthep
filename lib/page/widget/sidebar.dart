import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/global.dart';
import 'package:sthep/page/widget/profile.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
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
                    child: myText('나의 정보', 20.0, Palette.fontColor2),
                  ),
                  const SizedBox(height: 50.0),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        profile(tempUser),
                        const Expanded(child: SizedBox()),
                        settingButton(() {}),
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
          const ListTile(title: Text('아이디 변경')),
          const ListTile(title: Text('비밀번호 변경')),
          const ListTile(title: Text('이메일 변경')),
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
