import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/page/main/my/my_materials.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/model/user/activity.dart';
import 'package:sthep/model/user/indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';


class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MainPageState();
}

class _MainPageState extends State<MyPage> {
  late final ValueNotifier<List<MyActivity>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    List<MyActivity> temp = [];
    _selectedEvents = ValueNotifier(temp);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  Widget build(BuildContext context) {
    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    LinkedHashMap<DateTime, List<MyActivity>> myActivities = LinkedHashMap<DateTime, List<MyActivity>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(user.activities);

    List<MyActivity> _getEventsForDay(DateTime day) {
      return myActivities[day] ?? [];
    }

    List<MyActivity> _getEventsForRange(DateTime start, DateTime end) {
      final days = daysInRange(start, end);

      return [
        for (final d in days) ..._getEventsForDay(d),
      ];
    }

    void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      if (!isSameDay(_selectedDay, selectedDay)) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          _rangeStart = null;
          _rangeEnd = null;
          _rangeSelectionMode = RangeSelectionMode.toggledOff;
        });

        _selectedEvents.value = _getEventsForDay(selectedDay);
      }
    }

    void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
      setState(() {
        _selectedDay = null;
        _focusedDay = focusedDay;
        _rangeStart = start;
        _rangeEnd = end;
        _rangeSelectionMode = RangeSelectionMode.toggledOn;
      });

      // `start` or `end` could be null
      if (start != null && end != null) {
        _selectedEvents.value = _getEventsForRange(start, end);
      } else if (start != null) {
        _selectedEvents.value = _getEventsForDay(start);
      } else if (end != null) {
        _selectedEvents.value = _getEventsForDay(end);
      }
    }
    int touchedIndex = -1;

    List<PieChartSectionData> showingSections() {


      return List.generate(4, (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: Palette.pieAdopt,
              value: user.adoptQCount.toDouble(),
              title: '${user.adoptQCount.toInt()}\n(${100 * user.adoptQCount ~/ user.sumCount()}%)',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Palette.iconColor,
              ),
            );
          case 1:
            return PieChartSectionData(
              color: Palette.pieNotAdopt,
              value: user.notAdoptQCount.toDouble(),
              title: '${user.notAdoptQCount.toInt()}\n(${100 * user.notAdoptQCount ~/ user.sumCount()}%)',
              radius: radius,
              titleStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Palette.iconColor,
              ),
            );
          case 2:
            return PieChartSectionData(
              color: Palette.pieAdopted,
              value: user.adoptedACount.toDouble(),
              title: '${user.adoptedACount.toInt()}\n(${100 * user.adoptedACount ~/ user.sumCount()}%)',

              radius: radius,
              titleStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Palette.iconColor,
              ),
            );
          case 3:
            return PieChartSectionData(
              color: Palette.pieNotAdopted,
              value: user.notAdoptedACount.toDouble(),
              title: '${user.notAdoptedACount.toInt()}\n(${100 * user.notAdoptedACount ~/ user.sumCount()}%)',
              radius: radius,
              titleStyle: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Palette.iconColor,
              ),
            );
          default:
            throw Error();
        }
      });
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * .1),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: MyInfoArea(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: SizedBox(
                width: screenSize.width * .8,
                child: Column(
                  children: [
                    Row(
                      children:[
                        SizedBox(
                          width: screenSize.width * .4,
                          height: 50,
                          child: const SthepText("나의 활동 기록"),
                        ),
                        SizedBox(
                          width: screenSize.width * .4,
                          height: 50,
                          child: const SthepText("나의 활동 현황"),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenSize.width * .4,
                          height: 500,
                          child: TableCalendar<MyActivity>(
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                            rangeStartDay: _rangeStart,
                            rangeEndDay: _rangeEnd,
                            calendarFormat: _calendarFormat,
                            rangeSelectionMode: _rangeSelectionMode,
                            eventLoader: _getEventsForDay,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            calendarStyle : CalendarStyle(
                                defaultTextStyle: const TextStyle(color: Colors.grey),
                                weekendTextStyle: const TextStyle(color: Colors.grey),
                                outsideDaysVisible: false,
                                todayDecoration: const BoxDecoration(
                                    color: Palette.fontColor2,
                                    shape: BoxShape.circle,
                                ),
                                todayTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                ),
                                markerDecoration: BoxDecoration(
                                  color: Palette.hyperColor.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                markerSizeScale: 0.9,
                                markerMargin: EdgeInsets.zero,
                                markersAlignment: Alignment.center,
                                markersAutoAligned: false,
                                markersMaxCount: 1,
                            ),
                            onDaySelected: _onDaySelected,
                            onRangeSelected: _onRangeSelected,
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * .4,
                          height: 500,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: screenSize.width * .2,
                                    height: 300,
                                    child: user.myAnsweredQuestions.isEmpty && user.myQuestions.isEmpty
                                        ? const SthepText("활동 내역이 없습니다", color: Palette.fontColor2)
                                        : PieChart(
                                              PieChartData(
                                                  pieTouchData: PieTouchData(
                                                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                                        setState(() {
                                                          if (!event.isInterestedForInteractions ||
                                                              pieTouchResponse == null ||
                                                              pieTouchResponse.touchedSection == null) {
                                                            touchedIndex = -1;
                                                            return;
                                                          }
                                                          touchedIndex =
                                                              pieTouchResponse.touchedSection!.touchedSectionIndex;
                                                        });
                                                      }),
                                                  borderData: FlBorderData(
                                                    show: false,
                                                  ),
                                                  sectionsSpace: 0,
                                                  centerSpaceRadius: 40,
                                                  sections: showingSections()),
                                            )
                                  ),
                                  user.myAnsweredQuestions.isEmpty && user.myQuestions.isEmpty
                                      ? const SthepText(" ")
                                      : SizedBox(
                                    width: screenSize.width * .2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Indicator(
                                          color: Palette.pieAdopt,
                                          text: '답변을 채택한 질문',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Palette.pieNotAdopt,
                                          text: '답변을 채택하지 않은 질문',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Palette.pieAdopted,
                                          text: '채택된 답변',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Palette.pieNotAdopted,
                                          text: '채택되지 않은 답변',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 200,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
