import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets/text.dart';

class TagButton extends StatefulWidget {
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
  State<TagButton> createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => pressed = true),
      onPointerUp: (details) {
        setState(() => pressed = false);
        widget.onPressed();
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(10.0),
        height: 40.0,
        child: SthepText(
          widget.text,
          color: Palette.hyperColor,
          size: widget.size,
          underline: pressed,
        ),
      ),
    );
  }
}