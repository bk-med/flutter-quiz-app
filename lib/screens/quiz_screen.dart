import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/screens/result_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> questions;
  int currentQuestionIndex = 0;
  int numberOfQuestions = 0;
  int seconds = 30;
  late Timer timer;
  late List<Color> optionsBackgroundColor;
  late List<Color> selectedOptionsColor;
  int points = 0;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadQuizData();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  resetColors() {
    optionsBackgroundColor = List<Color>.filled(4, Colors.white);
    selectedOptionsColor = List<Color>.filled(4, Colors.black);
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          gotoNextQuestion();
        }
      });
    });
  }

  loadQuizData() async {
    QuizService quizService = QuizService();
    questions = quizService.getQuestions();
    // log questions
    questions.then((questions) {
      numberOfQuestions = questions.length;
    }).catchError((error) {
      print(error);
    });
    setState(() {
      optionsBackgroundColor = List<Color>.filled(4, Colors.white);
      selectedOptionsColor = List<Color>.filled(4, Colors.black);
      isLoaded = true;
    });
  }

  void checkAnswer(int selectedIndex) {
    questions.then((value) {
      bool correctAnswer =
          (selectedIndex == value[currentQuestionIndex].correctIndex);
      if (correctAnswer) {
        setState(() {
          points++;
          optionsBackgroundColor[selectedIndex] = Colors.green;
          selectedOptionsColor[selectedIndex] = Colors.white;
        });
      } else {
        setState(() {
          optionsBackgroundColor[selectedIndex] = Colors.red;
          optionsBackgroundColor[value[currentQuestionIndex].correctIndex] =
              Colors.green;
          selectedOptionsColor[selectedIndex] = Colors.white;
          selectedOptionsColor[value[currentQuestionIndex].correctIndex] =
              Colors.white;
        });
      }
      Timer(const Duration(seconds: 1), () {
        gotoNextQuestion();
      });
    }).catchError((error) {
      print(error);
    });
  }

  gotoNextQuestion() {
    setState(() {
      currentQuestionIndex++;
      if (currentQuestionIndex < numberOfQuestions) {
        resetColors();
        seconds = 30;
      } else {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(score: points, totalQuestions: numberOfQuestions),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1}/${numberOfQuestions}',
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: seconds / 30,
                          valueColor: const AlwaysStoppedAnimation(Colors.blue),
                          backgroundColor: Colors.grey,
                          strokeWidth: 5,
                        ),
                      ),
                      Text(
                        '$seconds',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ]),
            const SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<List<Question>>(
                  future: questions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !isLoaded) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<Question> data = snapshot.data!;
                      if (currentQuestionIndex < data.length) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 10.0),
                            Text(
                              data[currentQuestionIndex].question,
                              style: const TextStyle(fontSize: 20.0),
                            ),
                            const SizedBox(height: 20.0),
                            ...List.generate(
                              data[currentQuestionIndex].options.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  if (seconds > 0) {
                                    checkAnswer(index);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: optionsBackgroundColor[index],
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]),
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    data[currentQuestionIndex]
                                        .options[index]
                                        .text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedOptionsColor[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(child: Text('End of Quiz'));
                      }
                    } else {
                      return const Center(child: Text('No data'));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
