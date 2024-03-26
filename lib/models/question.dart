class Question {
  String question;
  List<QuestionOption> options;
  int correctIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuestionOption {
  String text;
  bool isCorrect;

  QuestionOption({
    required this.text,
    required this.isCorrect,
  });
}
