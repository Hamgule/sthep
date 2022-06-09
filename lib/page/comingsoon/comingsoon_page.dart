import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Palette.bgColor,
        elevation: 0.0,
      ),
      body: Container(
        color: Palette.bgColor,
        child: Center(
          child: Center(
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Coming Soon...',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(.7),
                    fontSize: 30.0,
                  ),
                  speed: const Duration(milliseconds: 300),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ),
        ),
      ),
    );
  }
}
