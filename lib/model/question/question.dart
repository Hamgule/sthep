import 'package:sthep/model/question/category.dart';
import 'package:sthep/model/painter/painter.dart';

class Question {
  /// variables
  late int id;
  late String title;
  late Category category;
  late String questionerUid;

  DateTime regDate = DateTime.now();
  List<String> answerIds = [];

  Painter? painter;
  String? imageUrl;
  String? adoptedAnswerId;

  /// constructor
  Question({
    required this.id,
    required this.title,
    required this.questionerUid,
    this.imageUrl,
    required this.regDate,
  });

  /// methods
  void adopt(String id) => adoptedAnswerId ??= id;
}