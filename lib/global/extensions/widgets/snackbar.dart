import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets/text.dart';

void showMySnackBar(
  BuildContext context,
  String content, {
  String type = 'info',
  bool ignoreBefore = true,
}) {
  Map<String, Color> colors = {
    'info': Palette.bgColor,
    'error': Palette.notAdopted,
    'success': Palette.adopted,
    'exp': Palette.hyperColor,
  };
  if (ignoreBefore) ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: colors[type],
      dismissDirection: DismissDirection.vertical,
      duration: const Duration(milliseconds: 1000),
      content: SthepText(content, size: 13.0, color: Colors.white),
    ),
  );
}
