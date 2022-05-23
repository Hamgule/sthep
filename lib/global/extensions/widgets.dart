/*
   반복적으로 사용되는 기능을 위젯으로 재정의 (Widgets)
*/

import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';

// 특정 폰트가 적용된 Text() 위젯
class SthepText extends StatelessWidget {
  const SthepText(
    this.text, {
    Key? key,
    this.size = 20.0,
    this.color = Palette.fontColor1,
    this.bold = false,
    this.italic = false,
    this.overflow = false,
  }) : super(key: key);

  final String text;
  final double size;
  final Color color;
  final bool bold;
  final bool italic;
  final bool overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Nemojin030',
        color: color,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      ),
      // overflow: overflow ? TextOverflow.ellipsis : TextOverflow.visible,
      overflow: TextOverflow.ellipsis,
    );
  }
}

void showMySnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 500),
      content: Text(content),
    ),
  );
}