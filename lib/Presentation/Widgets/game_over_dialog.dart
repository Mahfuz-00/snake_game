import 'package:flutter/material.dart';

class GameOverDialog extends StatelessWidget {
  final int score;

  const GameOverDialog({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Game Over'),
      content: Text('Your Score: $score'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Return to menu
          },
          child: const Text('Back to Menu'),
        ),
      ],
    );
  }
}