import 'package:flutter/material.dart';
import 'package:sthep/global/global.dart';

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
          DrawerHeader(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    SizedBox(height: 30.0),
                    Text(
                      '나의 정보',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                const SizedBox(height: 50.0),
                Row(
                  children: [
                    Expanded(child: profile(tempUser)),
                    settingButton,
                  ],
                ),
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
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
