import 'package:flutter/material.dart';

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

    // Déterminer le message basé sur le pourcentage
    String message;
    Color messageColor;
    if (percentage >= 80) {
      message =
          'Félicitations ! Vous avez réussi le quiz avec un excellent score de $score/$totalQuestions!';
      messageColor = Colors.green;
    } else if (percentage >= 50) {
      message =
          'Bravo ! Vous avez réussi le quiz avec un score de $score/$totalQuestions.';
      messageColor = Colors.orange;
    } else {
      message =
          'Dommage, votre score est de $score/$totalQuestions. Continuez à vous entraîner !';
      messageColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Résultat')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Résultat du Quiz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: messageColor),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Retour à l'écran précédent
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Couleur de fond du bouton
                textStyle: TextStyle(fontSize: 16), // Style du texte
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10), // Padding du bouton
              ),
              child: Text('Rejouer'),
            ),
          ],
        ),
      ),
    );
  }
}
