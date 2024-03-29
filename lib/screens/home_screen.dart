import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Largeur de 100% de l'écran
        height: double.infinity, // Hauteur de 100% de l'écran
        // change body background color
        color: Color(0xFF4b7c7a),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                    width: 120, // Adjust as needed
                    height: 120, // Adjust as needed
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // Change color as needed
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Quiz',
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4b7c7a),
                              )),
                          Text('App',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFf8c660),
                              )),
                        ],
                      ),
                    ))
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFf8c660),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text(
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
