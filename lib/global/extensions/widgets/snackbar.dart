import 'package:flutter/material.dart';

void showMySnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 500),
      content: Text(content),
    ),
  );
}
