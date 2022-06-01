import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/page/main/my/my_materials.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/main/my/utils.dart';
import 'package:sthep/page/main/notification/notification_materials.dart';
import 'package:table_calendar/table_calendar.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  static late bool animFin;
  static const duration = Duration(seconds: 2);

  @override
  State<MyPage> createState() => _MainPageState();
}

class _MainPageState extends State<MyPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    MyPage.animFin = false;
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  Future animate() async => await Future.delayed(
      Duration.zero, () => setState(() => MyPage.animFin = true));

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {

    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
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
        _rangeStart = null; // Important to clean those
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

  @override
  Widget build(BuildContext context) {
    tempUser.exp.setExp(102.0);

    animate();

    Materials materials = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context, listen: false);
    // print(materials.getQuestionsByUserID(user.uid!));

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: MyFirebase.readOnce(
              path: 'users',
              id: user.uid,
              builder: (context, snapshot) {
                if (snapshot.data == null) return Container();
                var loadData = snapshot.data.data();
                return myInfoArea(SthepUser.fromJson(loadData));
              },
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: screenSize.width * .5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 100.0),
                  child: TableCalendar<Event>(
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
                        defaultTextStyle: TextStyle(color: Colors.grey,),
                        weekendTextStyle: TextStyle(color: Colors.grey),
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
              ),
            ],
          ),
          // IntrinsicHeight(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //
          //       // myThreeActivities(
          //       //     materials.questions.getRange(0, 3).toList(), '나의 질문'),
          //       // SizedBox(
          //       //   width: 70.0,
          //       //   height: screenSize.width * .10,
          //       // ),
          //       // myThreeActivities(
          //       //     materials.questions.getRange(0, 3).toList(), '나의 답변'),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
