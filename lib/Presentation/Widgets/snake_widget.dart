import 'package:flutter/material.dart';
import 'package:snake_game/Domain/Entities/snake.dart';

class SnakeWidget extends StatelessWidget {
  final double cellSize;
  final Snake snake;

  const SnakeWidget({super.key, required this.cellSize, required this.snake});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var i = 0; i < snake.segments.length; i++)
          Positioned(
            left: snake.segments[i].x * cellSize,
            top: snake.segments[i].y * cellSize,
            child: i == 0 && snake.spinPositions.contains(snake.segments[i])
                ? RotationTransition(
              turns: AlwaysStoppedAnimation(360 / 360), // Simplified; use AnimationController for dynamic spin
              child: Container(
                width: cellSize,
                height: cellSize,
                color: Colors.green,
              ),
            )
                : Container(
              width: cellSize,
              height: cellSize,
              color: i == 0 ? Colors.green : Colors.lightGreen,
            ),
          ),
      ],
    );
  }
}