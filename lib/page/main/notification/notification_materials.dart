import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/notification.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/time/time.dart';
import 'package:sthep/model/user/user.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({Key? key, required this.notification}) : super(key: key);

  final MyNotification notification;

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    return Dismissible(
      key: Key(Question.idToString(notification.id!)),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: SthepText('삭제', color: Colors.white),
          ),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          notification.check();
          user.notifications.remove(notification);

          MyFirebase.f.collection('users')
              .doc(user.uid)
              .collection('notifications')
              .doc(Question.idToString(notification.id!))
              .delete();
        }
      },
      child: InkWell(
        onTap: () {
          try {
            materials.destQuestion = materials.getQuestionById(notification.questionId!);
          }
          catch (e) {
            showMySnackBar(context, '비정상적인 접근입니다.', type: 'error');
            return;
          }
          materials.gotoPage('view');
          notification.check();
          user.updateNotChecked();

          MyFirebase.f.collection('users')
              .doc(user.uid)
              .collection('notifications')
              .doc(Question.idToString(notification.id!))
              .set(notification.toJson());
        },
        child: Container(
          color: notification.checked
              ? Colors.transparent
              : Palette.bgColor.withOpacity(.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: notification.checked ? Container() : Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Palette.bgColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Palette.iconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    child: notification.type == 'adopted'
                        ? const Icon(Icons.check, color: Colors.white)
                        : const SthepText(
                       'A',
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SthepText(
                            '${notification.questionId}', size: 17.0,
                            color: Palette.fontColor2,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SthepText(
                            notification.questionTitle!,
                            color: Palette.iconColor,
                            overflow: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Align(
                          child: SthepText(
                            notification.notice!,
                            size: 25.0,
                            color: Palette.fontColor1,
                          ),
                          alignment: Alignment.centerLeft),
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Align(
                        child: SthepText(
                          Time(t: notification.loggedDate!).toString(),
                          size: 15.0,
                          color: Palette.fontColor2,
                        ),
                        alignment: Alignment.centerLeft),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
