import 'dart:math';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Domain/Entities/food.dart';
import 'package:snake_game/Domain/Entities/position.dart';
import 'package:snake_game/Domain/Entities/snake.dart';
import 'package:snake_game/Domain/Repositories/game_repository.dart';

class GameUseCase implements GameRepository {
  @override
  Snake moveSnake(Snake snake, int gridWidth, int gridHeight, GameMode mode) {
    final head = snake.segments.first;
    Position newHead;
    switch (snake.direction) {
      case Direction.up:
        newHead = Position(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Position(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Position(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Position(head.x + 1, head.y);
        break;
    }

    if (mode == GameMode.rapid) {
      newHead = Position(
        (newHead.x + gridWidth) % gridWidth,
        (newHead.y + gridHeight) % gridHeight,
      );
    }

    final newSegments = [newHead, ...snake.segments.sublist(0, snake.segments.length - 1)];
    final newSpinPositions = snake.spinPositions
        .where((pos) => newSegments.contains(pos))
        .toList();

    return snake.copyWith(segments: newSegments, spinPositions: newSpinPositions);
  }

  @override
  bool checkCollision(Snake snake, int gridWidth, int gridHeight, GameMode mode) {
    final head = snake.segments.first;
    if (mode == GameMode.classic &&
        (head.x < 0 || head.x >= gridWidth || head.y < 0 || head.y >= gridHeight)) {
      return true;
    }
    return snake.segments.sublist(1).contains(head);
  }

  @override
  Food generateFood(Snake snake, int gridWidth, int gridHeight, int foodCount, int specialFoodCount) {
    final random = Random();
    Position position;
    do {
      position = Position(
        random.nextInt(gridWidth),
        random.nextInt(gridHeight),
      );
    } while (snake.segments.contains(position));

    final isSpecial = foodCount % 10 == 0;
    final points = isSpecial ? min(5 + specialFoodCount, 25) : 10;

    return Food(position: position, isSpecial: isSpecial, points: points);
  }

  Snake performSpin(Snake snake) {
    if (snake.spinPositions.length >= 3) return snake; // Prevent spin if max reached
    final newSegments = snake.segments.sublist(0, snake.segments.length - 1);
    final newSpinPositions = [...snake.spinPositions, snake.segments.first];
    // Placeholder: Play spin sound (assets/sounds/spin.wav)
    return snake.copyWith(segments: newSegments, spinPositions: newSpinPositions);
  }
}