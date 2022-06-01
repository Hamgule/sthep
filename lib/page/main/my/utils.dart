import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(eventSource);

Map<DateTime,List<Event>> eventSource = {
  DateTime(2022,5,3) : [const Event('질문')],
  DateTime(2022,5,5) : [const Event('답변')],
};

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
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