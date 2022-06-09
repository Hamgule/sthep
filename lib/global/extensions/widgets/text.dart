import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';

class SthepText extends StatelessWidget {
  const SthepText(
      this.text, {
        Key? key,
        this.size = 20.0,
        this.color = Palette.fontColor1,
        this.bold = false,
        this.italic = false,
        this.underline = false,
      }) : super(key: key);

  final String text;
  final double size;
  final Color color;
  final bool bold;
  final bool italic;
  final bool underline;

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
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        decorationThickness: 5,

      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}