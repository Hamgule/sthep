import 'package:flutter/material.dart';
import 'package:sthep/global/global.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      padding: const EdgeInsets.all(30.0),
      width: 1000,
      height: 400,
      child: myText('hello', 17.0, Colors.black),
      )
    );
  }
}
