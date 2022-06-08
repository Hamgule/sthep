import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  const SettingButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container();
    // return IconButton(
    //   onPressed: onPressed,
    //   icon: const Icon(
    //     Icons.settings,
    //     color: Palette.iconColor,
    //     size: 18.0,
    //   ),
    // );
  }
}
