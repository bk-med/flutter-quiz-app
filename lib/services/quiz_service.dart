import 'dart:convert';
import 'dart:math'; // Import the dart:math library for shuffling
import 'package:flutter/services.dart';
import 'package:quiz_app/models/question.dart';

class QuizService {
  Future<List<Question>> getQuestions() async {
    String jsonData = await rootBundle.loadString('assets/quiz_data.json');
    List<dynamic> jsonList = json.decode(jsonData);
    List<Question> questions = [];

    // Shuffle the list of questions
    jsonList.shuffle();

    for (var item in jsonList) {
      List<QuestionOption> options = [];

      // Shuffle the list of options
      List<dynamic> shuffledOptions = List.from(item['options']);
      shuffledOptions.shuffle();

      for (var option in shuffledOptions) {
        options.add(
          QuestionOption(
            text: option,
            isCorrect: false, // Each option is incorrect by default
          ),
        );
      }

      // Find the index of the correct answer in the shuffled options
      int correctIndex =
          shuffledOptions.indexOf(item['options'][item['correctIndex']]);

      // Mark the correct answer
      options[correctIndex].isCorrect = true;

      Question question = Question(
        question: item['question'],
        options: options,
        correctIndex: correctIndex,
      );
      questions.add(question);
    }

    return questions;
  }

  String getFeedback(bool isCorrect) {
    return isCorrect ? 'Bonne réponse!' : 'Mauvaise réponse!';
  }
}
