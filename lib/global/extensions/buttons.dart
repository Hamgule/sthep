/*
   반복적으로 사용되는 기능을 위젯으로 재정의 (Buttons)
*/
import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';

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
