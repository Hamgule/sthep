// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:sthep/config/palette.dart';
// import 'package:sthep/global/extensions/widgets/text.dart';
// import 'package:sthep/global/materials.dart';
// import 'indicator.dart';
//
// class MyPieChart extends StatefulWidget {
//   const MyPieChart({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => PieChartState();
// }
//
// class PieChartState extends State {
//
//   int touchedIndex = -1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             SizedBox(
//               width: screenSize.width * .2,
//               height: 300,
//               child: PieChart(
//                 PieChartData(
//                     pieTouchData: PieTouchData(
//                         touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                       setState(() {
//                         if (!event.isInterestedForInteractions ||
//                             pieTouchResponse == null ||
//                             pieTouchResponse.touchedSection == null) {
//                           touchedIndex = -1;
//                           return;
//                         }
//                         touchedIndex =
//                             pieTouchResponse.touchedSection!.touchedSectionIndex;
//                       });
//                     }),
//                     borderData: FlBorderData(
//                       show: false,
//                     ),
//                     sectionsSpace: 0,
//                     centerSpaceRadius: 40,
//                     sections: showingSections()),
//               ),
//             ),
//             SizedBox(
//               width: screenSize.width * .2,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const <Widget>[
//                   Indicator(
//                     color: Palette.hyperColor,
//                     text: '답변을 채택한 질문',
//                     isSquare: true,
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Indicator(
//                     color: Palette.notAdopted,
//                     text: '답변을 채택하지 않은 질문',
//                     isSquare: true,
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Indicator(
//                     color: Palette.adopted,
//                     text: '채택된 답변',
//                     isSquare: true,
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Indicator(
//                     color: Palette.bgColor,
//                     text: '채택되지 않은 답변',
//                     isSquare: true,
//                   ),
//                   SizedBox(
//                     height: 18,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 200,
//         ),
//       ],
//     );
//   }
//
// }
