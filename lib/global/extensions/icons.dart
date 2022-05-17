import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets.dart';

enum AdoptState { notAnswered, notAdopted, adopted }

class AdoptStateIcon extends StatelessWidget {
  const AdoptStateIcon({
    Key? key,
    this.state = AdoptState.notAnswered,
  }) : super(key: key);

  final AdoptState state;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(13.0, 8.0, 13.0, 8.0),
        child: const SthepText('채택 완료', size: 13.0, color: Colors.white),
        decoration: const BoxDecoration(
          color:Palette.adoptOk,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    );
  }
}
