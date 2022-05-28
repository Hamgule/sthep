/*
   반복적으로 사용되는 기능을 위젯으로 재정의 (Buttons)
*/
import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets.dart';

// 설정 버튼
class SettingButton extends StatelessWidget {
  const SettingButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.settings,
        color: Palette.iconColor,
        size: 18.0,
      ),
    );
  }
}

// 태그 버튼
class TagButton extends StatelessWidget {
  const TagButton(
    this.text, {
    Key? key,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: SthepText(
        text,
        color: Palette.hyperColor,
        size: size,
      ),
    );
  }
}
