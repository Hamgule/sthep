import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

enum ActivityType { question, answer }

class MyActivity {
  ActivityType type;
  int id;

  MyActivity({required this.type, required this.id});

}

// final myActivities = LinkedHashMap<DateTime, List<MyActivity>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(activities);
//
//
// // Map<DateTime, List<MyActivity>> activities = {
// //   DateTime(2022, 5, 3) : [MyActivity(type: ActivityType.question, id: 1)],
// //   DateTime(2022, 5, 5) : [MyActivity(type: ActivityType.question, id: 2)],
// // };
//
// int getHashCode(DateTime key) {
//   return key.day * 1000000 + key.month * 10000 + key.year;
// }

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);



