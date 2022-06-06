import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:provider/provider.dart';
import 'package:sthep/config/palette.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/dialog.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/global/extensions/widgets/text.dart';
import 'package:sthep/model/question/answer.dart';
import 'package:sthep/model/question/question.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sthep/model/user/user.dart';

late Size screenSize;

class Materials with ChangeNotifier {

  /// appbar
  TextEditingController nicknameController = TextEditingController();
  String? nicknameInput;

  Future inputNickname(BuildContext context) async {
    nicknameInput = await showMyInputDialog(
      context, title: '닉네임을 입력하세요.',
    );
  }
  Widget searchButton(BuildContext context) => StatefulBuilder(
    builder: (context, setState) {
      return IconButton(
        onPressed: () {
          searchKeyword = '';
          searchTags = [];
          filteredQuestions = [];
          Navigator.pushNamed(context, '/Search');
        },
        icon: const Icon(Icons.search),
      );
    },
  );

  Widget listGridToggleButton() {
    return IconButton(
      onPressed: toggleGrid,
      icon: Icon(
        isGrid ? Icons.list_alt : Icons.window,
      ),
    );
  }

  Widget drawerButton() {
    return StatefulBuilder(
      builder: (context, setState) => IconButton(
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        icon: const Icon(Icons.menu),
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    Materials main = Provider.of<Materials>(context);
    SthepUser user = Provider.of<SthepUser>(context);

    return IconButton(
      onPressed: () async {
        try { await user.sthepLogin(); }
        catch (e) { return; }

        if (user.nickname == null) {
          while (true) {
            await inputNickname(context);
            if (nicknameInput == null) {
              showMySnackBar(context, '로그인에 실패했습니다. 다시 로그인 해주세요.', type: 'error');
              return;
            }
            if (nicknameInput != '') break;
            showMySnackBar(context, '올바른 닉네임을 입력하세요.', type: 'error');
          }

          user.toggleLogState();
          user.setNickname(nicknameInput!);
          user.updateDB();
          showMySnackBar(context, '\'${user.nickname}\'님 환영합니다.', type: 'success');
          return;
        }

        user.toggleLogState();
        showMySnackBar(context, '\'${user.nickname}\'님 로그인 되었습니다.', type: 'success');
        main.setPageIndex(0);
      }, icon: const Icon(Icons.login),
    );
  }

  /// main
  int pageIndex = 0;
  int newPageIndex = 0;

  void setPageIndex(int index) {
    newPageIndex = index;
    if (index < 5) pageIndex = newPageIndex;
    notifyListeners();
  }

  /// global
  List<Question> questions = [];
  List<Question> myQuestions = [];
  List<Question> myAnsweredQuestion = [];

  void addQuestion(Question q) async {
    int index = questions.indexWhere((e) => e.id == q.id);
    if (index >= 0) questions.removeAt(index);
    index = index < 0 ? 0 : index;
    questions.insert(index, q);
    // questions.add(q);
  }

  Question getQuestionById(int id) {
    return questions.where((e) => e.id == id).toList().first;
  }

  List<Question> getQuestionsByUserID(String uid) {
    return questions.where((e) => e.questionerUid == uid).toList();
  }

  /// home
  bool isGrid = true;

  void toggleGrid() {
    isGrid = !isGrid;
    notifyListeners();
  }

  late Question newQuestion;
  late Answer newAnswer;
  Question? destQuestion;
  Answer? destAnswer;

  void setDestQuestion(Question question) {
    destQuestion = question;
    notifyListeners();
  }

  /// upload
  File? image;
  bool loading = false;
  GlobalKey<ImagePainterState> imageKey = GlobalKey<ImagePainterState>();

  Future saveImage() async {
    final editedImage = await imageKey.currentState?.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath = '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
    final imgFile = File(fullPath);
    imgFile.writeAsBytesSync(editedImage!);
    image = imgFile;
  }

  void updateLocalImage(File? image) {
    image = image;
    notifyListeners();
  }

  void toggleLoading() {
    loading = !loading;
    notifyListeners();
  }

  /// search
  String searchKeyword = '';
  List<String> searchTags = [];
  List<Question> filteredQuestions = [];

  void clearFilteredQuestions() {
    filteredQuestions = [];
    notifyListeners();
  }

  void setKeyword(String text) {
    searchKeyword = text;
    notifyListeners();
  }

  void addTag(String tag) {
    searchTags.add(tag);
    notifyListeners();
  }

  void removeTag(int index) {
    searchTags.removeAt(index);
    notifyListeners();
  }

  void addSearchedQuestion(Question question) {
    filteredQuestions.add(question);
    notifyListeners();
  }

  /// view
  bool isChanged = false;
  FABState viewFABState = FABState.myQuestion;

  void toggleIsChanged() {
    isChanged = !isChanged;
    notifyListeners();
  }

  void setViewFABState(FABState state) {
    viewFABState = state;
    notifyListeners();
  }

  void adopt() {
    destAnswer!.adopted = true;
    notifyListeners();
  }

}