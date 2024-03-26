import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz App')),
      body: Container(
        width: double.infinity, // Largeur de 100% de l'écran
        height: double.infinity, // Hauteur de 100% de l'écran
        decoration: BoxDecoration(
          color: Colors.blue, // Couleur de fond bleue
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/ideas.png',
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Bienvenue au Quiz',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.white, // Couleur de fond du bouton blanc
                foregroundColor: Colors.blue, // Couleur du texte du bouton bleu
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Commencer le Quiz',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
