import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/global/materials.dart';
import 'package:sthep/model/question/question.dart';
import 'package:sthep/model/user/user.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials main = Provider.of<Materials>(context, listen: false);
    SthepUser user = Provider.of<SthepUser>(context, listen: false);

    void onPressed() async {
      Map<String, dynamic>? data = await MyFirebase.readData(
          'autoIncrement', 'question');
      int nextId = data!['currentId'] + 1;

      if (!user.logged) {
        showMySnackBar(context, '로그인이 필요합니다.');
        return;
      }

      main.setPageIndex(5);
      main.newQuestion = Question(
        id: nextId,
        questionerUid: user.uid!,
      );
      main.image = null;
    }

    return SingleFAB(child: const Icon(Icons.edit), onPressed: onPressed);
  }
}

class CreateFAB extends StatelessWidget {
  const CreateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials main = Provider.of<Materials>(context, listen: false);

    void onPressed() async {
      Map<String, dynamic>? data = await MyFirebase.readData(
          'autoIncrement', 'question');
      int nextId = data!['currentId'] + 1;

      if (main.newQuestion.title == '') {
        showMySnackBar(context, '제목을 입력하세요');
        return;
      }

      main.toggleUploadingState();
      if (main.image != null) {
        await main.saveImage();

        main.newQuestion.imageUrl = await MyFirebase.uploadImage(
          'questions',
          main.newQuestion.idToString(),
          main.image,
        );
      }
      main.toggleUploadingState();

      Map<String, dynamic> addData = main.newQuestion.toJson();

      addData['regDate'] = FieldValue.serverTimestamp();

      MyFirebase.write(
        'questions',
        main.newQuestion.idToString(),
        addData,
      );

      main.setPageIndex(0);
      MyFirebase.write('autoIncrement', 'question', {'currentId': nextId});
    }

    return SingleFAB(child: const Icon(Icons.upload), onPressed: onPressed);
  }
}

class ViewFAB extends StatelessWidget {
  const ViewFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials main = Provider.of<Materials>(context, listen: false);
    SthepUser user = Provider.of<SthepUser>(context, listen: false);

    void editPressed() {
      main.setPageIndex(7);
      main.image = null;
    }

    void delPressed() {
      Materials main = Provider.of<Materials>(context, listen: false);
      MyFirebase.remove('questions', main.destQuestion!.idToString());
      MyFirebase.removeImage('questions', main.destQuestion!.idToString());
      main.setPageIndex(0);
    }

    if (main.destQuestion == null) {
      SingleFAB(child: const Icon(Icons.question_mark), onPressed: () {});
    }

    return user.uid == main.destQuestion!.questionerUid
        ? MultiFAB(
      children: [
        ActionButton(
          onPressed: editPressed,
          icon: const Icon(Icons.edit),
        ),
        ActionButton(
          onPressed: delPressed,
          icon: const Icon(Icons.delete),
        ),
      ],
    ) : SingleFAB(
      child: const Icon(Icons.comment),
      onPressed: () {},
    );
  }
}


class UpdateFAB extends StatelessWidget {
  const UpdateFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Materials main = Provider.of<Materials>(context, listen: false);

    void onPressed() async {
      Map<String, dynamic>? data = await MyFirebase.readData(
          'autoIncrement', 'question');
      int nextId = data!['currentId'] + 1;

      main.newQuestion = main.destQuestion!;

      if (main.newQuestion.title == '') {
        showMySnackBar(context, '제목을 입력하세요');
        return;
      }

      main.toggleUploadingState();

      if (main.image == null) {
        await main.saveImage();

        main.newQuestion.imageUrl = await MyFirebase.uploadImage(
          'questions',
          main.newQuestion.idToString(),
          main.image,
        );
      }
      // if (main.image != null) {
      //   main.newQuestion.imageUrl = await MyFirebase.uploadImage(
      //     'questions',
      //     main.destQuestion!.idToString(),
      //     main.image,
      //   );
      // }

      main.toggleUploadingState();

      Map<String, dynamic> addData = main.newQuestion.toJson();

      addData['modDate'] = FieldValue.serverTimestamp();

      MyFirebase.write(
        'questions',
        main.newQuestion.idToString(),
        addData,
      );

      main.setPageIndex(0);
      MyFirebase.write('autoIncrement', 'question', {'currentId': nextId});
    }
    return SingleFAB(child: const Icon(Icons.upload), onPressed: onPressed);
  }
}


class SingleFAB extends StatefulWidget {
  const SingleFAB({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  State<SingleFAB> createState() => _SingleFABState();
}

class _SingleFABState extends State<SingleFAB> {

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      onPressed: widget.onPressed,
      child: widget.child,
      backgroundColor: Palette.iconColor,
    );
  }
}

class MultiFAB extends StatelessWidget {
  const MultiFAB({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 80.0,
      children: children,
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Palette.iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 120.0 / count;
    double angleInDegrees = count == 1 ? 45.0 : 15.0 * (4.0 - count) / 3.0;
    for (int i = 0; i < count; i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.menu),
            backgroundColor: Palette.iconColor,
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Palette.iconColor,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: Colors.white,
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  const TagChip({
    Key? key,
    required this.label,
    required this.onDeleted,
    required this.index,
  }) : super(key: key);

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Palette.hyperColor.withOpacity(.4),
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: SthepText(label, size: 13.0),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () => onDeleted(index),
    );
  }
}