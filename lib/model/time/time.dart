import 'package:flutter/material.dart';

class Time with ChangeNotifier {
  late DateTime t;
  DateTime cur = DateTime.now();

  Time({required this.t});

  @override
  String toString() => convertToPassedTime(cur.difference(t));

  static String timeFormat(String type, int value) {
    return value < 2 ? '$value $type ago' : '$value ${type}s ago';
  }

  static String convertToPassedTime(Duration diffNow) {
    int days = diffNow.inDays;
    int hours = diffNow.inHours;
    int minutes = diffNow.inMinutes;
    int seconds = diffNow.inSeconds;

    return (
      days > 0 ? timeFormat('day', days) :
      hours > 0 ? timeFormat('hour', hours) :
      minutes > 0 ? timeFormat('minute', minutes) :
      timeFormat('second', seconds)
    );
  }
}