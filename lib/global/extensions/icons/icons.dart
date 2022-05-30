import 'package:flutter/material.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/widgets/text.dart';

enum AdoptState { notAnswered, notAdopted, adopted }

class AdoptIconInfo {
  String text;
  Color color;
  Color textColor;

  AdoptIconInfo({
    this.text = '답변 없음',
    this.color = Palette.notAnswered,
    this.textColor = Palette.fontColor1,
});
}

class AdoptStateIcon extends StatelessWidget {
  const AdoptStateIcon({
    Key? key,
    this.state = AdoptState.notAnswered,
  }) : super(key: key);

  final AdoptState state;

  @override
  Widget build(BuildContext context) {
    Map<AdoptState, AdoptIconInfo> _info = {
      AdoptState.notAnswered: AdoptIconInfo(),
      AdoptState.notAdopted: AdoptIconInfo(text: '미채택', color: Palette.notAdopted),
      AdoptState.adopted: AdoptIconInfo(text: '채택 완료', color: Palette.adopted),
    };

    return Material(
      elevation: 10.0,
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(13.0, 8.0, 13.0, 8.0),
        child: SthepText(_info[state]!.text, size: 13.0, color: _info[state]!.textColor),
        decoration: BoxDecoration(
          color: _info[state]!.color,
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    );
  }
}
