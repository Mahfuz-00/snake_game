import 'package:flutter/material.dart';
import 'package:snake_game/Data/Models/high_score.dart';

class HighScoreWidget extends StatelessWidget {
  final List<HighScore> highScores;

  const HighScoreWidget({super.key, required this.highScores});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('High Scores', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ...highScores.asMap().entries.map((entry) => Text(
          '${entry.key + 1}. ${entry.value.score} - ${entry.value.date.toString().split('.')[0]}',
          style: const TextStyle(fontSize: 16),
        )),
      ],
    );
  }
}