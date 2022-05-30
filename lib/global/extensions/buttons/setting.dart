import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';

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
