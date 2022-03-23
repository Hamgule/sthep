import 'package:flutter/material.dart';
import 'package:sthep/model/user/user.dart';

bool isGrid = true;
User tempUser = User(
  id: 'zihoo1234',
  name: '양지후',
  nickname: 'zihoo',
  password: '',
);

PreferredSizeWidget mainPageAppBar = AppBar(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  title: Image.asset(
    'assets/images/logo_horizontal.png',
    fit: BoxFit.contain,
    width: 150,
  ),
  actions: [
    IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
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

Widget profile(User user) => Row(
      children: [
        Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: user.image.image,
              ),
            )),
        const SizedBox(width: 15.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  user.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${user.name} / ${user.nickname}',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );

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
                    const Icon(Icons.settings),
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
// class SideBar extends StatelessWidget {
//   const SideBar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(children: const [
//         DrawerHeader(
//           child: Text('My Page'),
//           decoration: BoxDecoration(
//             color: Colors.indigoAccent,
//           ),
//         ),
//         ListTile(title: Text('Item 1')),
//         ListTile(title: Text('Item 2')),
//         ListTile(title: Text('Item 3')),
//       ]),
//     );
//   }
// }
