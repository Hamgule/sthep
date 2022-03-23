import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/model/user/user.dart';

bool isGrid = true;
User tempUser = User(
  id: 'zihoo1234',
  name: '양지후',
  nickname: 'zihoo',
  password: '',
);

PreferredSizeWidget myPageAppBar = AppBar(
  backgroundColor: Palette.appbarColor,
  foregroundColor: Palette.iconColor,
  title: Text(''),
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

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MainPageState();
}

class _MainPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myPageAppBar,
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
        )
    ),
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
            child: Container(
              child: Column(
                children: [
                  const Text(
                    '나의 정보',
                    style: TextStyle(fontSize: 20.0,),
                    textAlign: TextAlign.start,
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0)),
                  Row(
                    children: [
                      Expanded(child: profile(tempUser)),
                      const Icon(Icons.settings),
                    ],
                  ),
                ],
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
  
          //Step 3, set child widgets in drawer
          ListTile(title: Text('Item 1')),
          ListTile(title: Text('Item 2')),
          ListTile(title: Text('Item 3')),
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
