import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quiz_app/models/question.dart';

class QuizService {
  Future<List<Question>> getQuestions() async {
    String jsonData = await rootBundle.loadString('assets/quiz_data.json');
    List<dynamic> jsonList = json.decode(jsonData);
    List<Question> questions = [];

    for (var item in jsonList) {
      List<QuestionOption> options = [];
      for (var option in item['options']) {
        options.add(
          QuestionOption(
            text: option,
            isCorrect: false, // Chaque option est incorrecte par défaut
          ),
        );
      }
      // Marquer la bonne réponse
      options[item['correctIndex']].isCorrect = true;

      Question question = Question(
        question: item['question'],
        options: options,
        correctIndex: item['correctIndex'],
      );
      questions.add(question);
    }

    return questions;
  }

  String getFeedback(bool isCorrect) {
    return isCorrect ? 'Bonne réponse!' : 'Mauvaise réponse!';
  }
}
