class MyNotification {
  String? type;
  int? questionId;
  String? questionTitle;

  MyNotification({
    this.type,
    this.questionId,
    this.questionTitle,
  });

  MyNotification.fromJson(Map<String, dynamic> data) {
    type = data['type'];
    questionId = data['questionId'];
    questionTitle = data['questionTitle'];
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'questionId': questionId,
    'questionTitle': questionTitle,
  };
}