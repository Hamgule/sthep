import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
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
            itemCount: user.notifications.isEmpty ? 1 : user.notifications.length,
            itemBuilder: (context, index) {
              if (user.notifications.isEmpty) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Container(
                    color: Colors.grey.withOpacity(.4),
                    padding: const EdgeInsets.all(30.0),
                    child: const SthepText('알림이 없습니다', color: Colors.grey),
                  ),
                );
              }
              return user.notifications.map((notification)
                => NotificationTile(notification: notification)).toList()[index];
            },
          ),
        ),
      ],
    );
  }
}
