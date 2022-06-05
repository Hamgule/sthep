import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class SthepProgressIndicator extends StatelessWidget {
  const SthepProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JumpingDotsProgressIndicator(
      color: Colors.white,
      fontSize: 100.0,
    );
  }
}
