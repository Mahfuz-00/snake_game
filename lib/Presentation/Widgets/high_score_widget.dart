import 'package:flutter/material.dart';
import 'package:snake_game/Data/Models/high_score.dart';

class HighScoreWidget extends StatelessWidget {
  final List<HighScore> highScores;

  const HighScoreWidget({super.key, required this.highScores});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'High Scores',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (highScores.isEmpty)
            const Text('No high scores yet.')
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: highScores.length,
              itemBuilder: (context, index) {
                final score = highScores[index];
                return ListTile(
                  title: Text('Score: ${score.score}'),
                  subtitle: Text('Date: ${score.date.toString().substring(0, 10)}'),
                );
              },
            ),
        ],
      ),
    );
  }
}