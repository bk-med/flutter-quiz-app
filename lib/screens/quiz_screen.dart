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
  int seconds = 30;
  late Timer timer;
  late List<Color> optionsColor;
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
    optionsColor = List<Color>.filled(4, Colors.white);
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
    setState(() {
      optionsColor = List<Color>.filled(4, Colors.white);
      isLoaded = true;
    });
  }

  void checkAnswer(int selectedIndex) {
    if (questions != null) {
      questions.then((value) {
        bool correctAnswer =
            (selectedIndex == value[currentQuestionIndex].correctIndex);
        if (correctAnswer) {
          setState(() {
            points++;
            optionsColor[selectedIndex] = Colors.green;
          });
        } else {
          setState(() {
            optionsColor[selectedIndex] = Colors.red;
            optionsColor[value[currentQuestionIndex].correctIndex] =
                Colors.green;
          });
        }
        Timer(Duration(seconds: 2), () {
          gotoNextQuestion();
        });
      }).catchError((error) {
        print(error);
      });
    }
  }

  gotoNextQuestion() {
    setState(() {
      currentQuestionIndex++;
      if (currentQuestionIndex < 20) {
        resetColors();
        seconds = 30;
      } else {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(score: points, totalQuestions: 20),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: seconds / 30,
                    valueColor: const AlwaysStoppedAnimation(Colors.blue),
                    backgroundColor: Colors.grey,
                    strokeWidth: 8,
                  ),
                ),
                Text(
                  '$seconds s',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<List<Question>>(
                  future: questions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !isLoaded) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<Question> data = snapshot.data!;
                      if (currentQuestionIndex < data.length) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Question ${currentQuestionIndex + 1}/20',
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              data[currentQuestionIndex].question,
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(height: 20.0),
                            ...List.generate(
                              data[currentQuestionIndex].options.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  if (seconds > 0) {
                                    checkAnswer(index);
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: optionsColor[index],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    data[currentQuestionIndex]
                                        .options[index]
                                        .text,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(child: Text('End of Quiz'));
                      }
                    } else {
                      return Center(child: Text('No data'));
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
