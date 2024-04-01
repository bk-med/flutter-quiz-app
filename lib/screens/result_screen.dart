import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quiz_app/screens/home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int? score;
  final int? totalQuestions;

  ResultScreen({Key? key, this.score, this.totalQuestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcul du pourcentage
    double percentage =
        score != null && totalQuestions != null && totalQuestions! > 0
            ? (score! / totalQuestions!) * 100
            : 0.0;
    double rating =
        score != null && totalQuestions != null && totalQuestions! > 0
            ? (score! / totalQuestions!) * 5
            : 0.0;

    // Déterminer le message basé sur le pourcentage
    String message;
    Color scoreColor;
    if (percentage >= 80) {
      message = 'Excellent ! Vous avez bien travaillé !';
    } else if (percentage >= 60) {
      message = 'Bon travail !';
    } else if (percentage >= 40) {
      message = "Pas mal, continuez comme ça !";
    } else if (percentage >= 20) {
      message = 'Vous pouvez faire mieux !';
    } else {
      message = 'Vous devez travailler encore !';
    }

    if (percentage > 75) {
      scoreColor = Colors.green;
    } else if (percentage > 50) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          toolbarHeight: 10,
        ),
        body: Container(
            color: Colors.blue[400],
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(240.0),
                  topRight: Radius.circular(240.0),
                  bottomLeft:
                      Radius.zero, // Set zero radius for the bottom left
                  bottomRight:
                      Radius.zero, // Set zero radius for the bottom right
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Résultat du Quiz',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 50.0,
                      direction: Axis.horizontal,
                    ),
                    const Text(
                      "Votre score est",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("$score",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                          )),
                      Text("/$totalQuestions",
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ))
                    ]),
                    const SizedBox(height: 20),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue[400], // Couleur de fond du bouton blanc
                        foregroundColor:
                            Colors.white, // Couleur du texte du bouton bleu
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                      ),
                      child: const Text(
                        'Retour à l\'accueil',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
