import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:provider/provider.dart';
import 'package:sthep/firebase/firebase.dart';
import 'package:sthep/global/extensions/buttons/fab/fab.dart';
import 'package:sthep/global/extensions/widgets/dialog.dart';
import 'package:sthep/global/extensions/widgets/snackbar.dart';
import 'package:sthep/model/question/answer.dart';
import 'package:sthep/model/question/question.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sthep/model/user/exp.dart';
import 'package:sthep/model/user/user.dart';
import 'package:sthep/page/main/main.dart';

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
    Materials materials = Provider.of<Materials>(context);
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

          user.setMy(materials.questions);
          user.setNickname(nicknameInput!);
          user.updateDB();
          showMySnackBar(context, '\'${user.nickname}\'님 환영합니다.', type: 'success');

          user.toggleLoginState();

          user.gainExp(Exp.register);
          showMySnackBar(context, Exp.visualizeForm(Exp.register), type: 'exp', ignoreBefore: false);

          return;
        }

        user.setMy(materials.questions);
        showMySnackBar(context, '\'${user.nickname}\'님 로그인 되었습니다.', type: 'success');

        user.toggleLoginState();

        user.gainExp(Exp.login);
        showMySnackBar(context, Exp.visualizeForm(Exp.login), type: 'exp', ignoreBefore: false);

        setPageIndex(0);

      }, icon: const Icon(Icons.login),
    );
  }

  /// main
  int pageIndex = 0;
  int newPageIndex = 0;

  void gotoPage(String route) {
    setPageIndex(pageNames.indexWhere((name) => name == route));
  }

  void setPageIndex(int index) {
    newPageIndex = index;
    if (index < 5) pageIndex = newPageIndex;
    notifyListeners();
  }

  /// global
  List<Question> questions = [];
  List<Answer> answers = [];
  List<SthepUser> users = [];
  List<Question> visQuestions = [];

  Future loadQuestions() async {
    questions = [];
    var jsonQuestions = await MyFirebase.readCollection('questions');
    questions.addAll(jsonQuestions.map((json) => Question.fromJson(json)).toList().reversed);
    notifyListeners();
  }

  Future loadAnswers() async {
    answers = [];
    var jsonAnswers = await MyFirebase.readCollection('answers');
    answers.addAll(jsonAnswers.map((json) => Answer.fromJson(json)).toList());
    notifyListeners();
  }

  Future loadUsers() async {
    users = [];
    var jsonAnswers = await MyFirebase.readCollection('users');
    users.addAll(jsonAnswers.map((json) => SthepUser.fromJson(json)).toList());
    notifyListeners();
  }

  Question getQuestionById(int id) {
    return questions.where((e) => e.id == id).toList().first;
  }

  List<Question> getQuestionsByUserID(String uid) {
    return questions.where((e) => e.questionerUid == uid).toList();
  }

  Answer getAnswerById(int id) {
    return answers.where((e) => e.id == id).toList().first;
  }

  List<Answer> getAnswersByUserID(String uid) {
    return answers.where((e) => e.answererUid == uid).toList();
  }

  SthepUser getUserByUid(String uid) {
    return users.where((e) => e.uid == uid).toList().first;
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
  List<bool> allows = [false, false, false, false, false];

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

  void toggleAllow(int index) {
    allows[index] = !allows[index];
    notifyListeners();
  }

  void addSearchedQuestion(Question question) {
    filteredQuestions.add(question);
    notifyListeners();
  }

  /// view
  bool loadControl = false;
  FABState viewFABState = FABState.myQuestion;

  void refresh(BuildContext context) async {
    SthepUser user = Provider.of<SthepUser>(context, listen: false);

    await loadQuestions();
    await loadAnswers();
    await loadUsers();

    questions.forEach((question) {
      question.questioner = getUserByUid(question.questionerUid);
      question.answers = [];
      question.answerIds.forEach((answerId) {
        question.answers.add(getAnswerById(answerId));
        question.answers.forEach((answer) {
          answer.answerer = getUserByUid(answer.answererUid);
        });
      });
    });

    user.setMy(questions);
    updateVisQuestions(user);
  }

  void updateVisQuestions(SthepUser user) {
    visQuestions = [];
    if (newPageIndex == 0) {
      visQuestions.addAll(questions);
    }
    else if (newPageIndex == 1) {
      visQuestions.addAll(user.myQuestions);
    }
    else if (newPageIndex == 2) {
      visQuestions.addAll(user.myAnsweredQuestions);
    }
    notifyListeners();
  }

  void toggleLoadControl() {
    loadControl = !loadControl;
    // notifyListeners();
  }

  void setViewFABState(FABState state) {
    viewFABState = state;
    notifyListeners();
  }

  void adopt() {
    destAnswer!.adopt();
    destQuestion!.adoptedAnswerId = destAnswer!.id;
    destQuestion!.updateState();
    notifyListeners();
  }

  /// my
  bool expAnimation = false;

  void startAnimation() {
    expAnimation = true;
    notifyListeners();
  }

  void finishAnimation() {
    expAnimation = false;
    notifyListeners();
  }
}