import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/model/user/user.dart';
import './notification_materials.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  Widget build(BuildContext context) {
    SthepUser user = Provider.of<SthepUser>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: user.notifications.length,
            itemBuilder: (context, index) {
              return user.notifications.map((notification)
                => NotificationTile(notification: notification)).toList()[index];
            },
          ),
        ),
      ],
    );
  }
}
