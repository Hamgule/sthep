import 'package:flutter/material.dart';
import './notification_materials.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50.0,
        ),
        Expanded(
          child: ListView(
            children: List.generate(10, (index) {
              return Column(
                children: const [
                  Notifications(),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
