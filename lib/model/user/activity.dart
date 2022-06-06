import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

enum ActivityType { question, answer }

class MyActivity {
  ActivityType type;
  int id;

  MyActivity({required this.type, required this.id});

}

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



