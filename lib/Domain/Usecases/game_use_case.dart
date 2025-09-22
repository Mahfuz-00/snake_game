import 'dart:math';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Domain/Entities/food.dart';
import 'package:snake_game/Domain/Entities/position.dart';
import 'package:snake_game/Domain/Entities/snake.dart';
import '../../Presentation/Blocs/Game/game_bloc.dart';

class GameUseCase {
  final Random _random = Random();

  GameState initializeGame(GameMode gameMode, int gridWidth, int gridHeight) {
    final initialSnake = Snake(
      segments: [Position(x: 5, y: 5)],
      direction: Direction.right,
    );
    final initialFood = _generateFood(initialSnake.segments, gridWidth, gridHeight);
    return GameState(
      snake: initialSnake,
      food: initialFood,
      score: 0,
      spinCount: 0,
      isPlaying: true,
      gameMode: gameMode,
      gridWidth: gridWidth,
      gridHeight: gridHeight,
      lives: 3,
      activeRewards: const [],
    );
  }

  GameState moveSnake(GameState state) {
    final newHead = _getNewHead(state.snake.segments.first, state.snake.direction, state.gridWidth, state.gridHeight);
    List<Position> newSegments = [newHead, ...state.snake.segments.sublist(0, state.snake.segments.length - 1)];

    bool ateFood = state.food != null && newHead == state.food!.position;
    bool ateSpecialFood = state.specialFood != null && newHead == state.specialFood!.position;

    if (ateFood || ateSpecialFood) {
      newSegments = [newHead, ...state.snake.segments]; // Grow snake
      final newFood = ateFood ? _generateFood(newSegments, state.gridWidth, state.gridHeight) : state.food;
      final newSpecialFood = ateSpecialFood ? null : state.specialFood;
      final newScore = state.score + (ateFood ? 10 : ateSpecialFood ? 50 : 0);
      final newActiveRewards = ateSpecialFood ? [...state.activeRewards, RewardType.bonusPoints] : state.activeRewards;

      return state.copyWith(
        snake: state.snake.copyWith(segments: newSegments),
        food: newFood,
        specialFood: newSpecialFood,
        score: newScore,
        activeRewards: newActiveRewards,
        isPlaying: true,
      );
    }

    if (_isGameOver(newSegments, state.gameMode, state.gridWidth, state.gridHeight)) {
      final newLives = state.lives - 1;
      final newScore = (state.score - 50).clamp(0, state.score); // Apply score penalty
      if (newLives <= 0) {
        return state.copyWith(
          isPlaying: false,
          lives: newLives,
          score: newScore,
        );
      }
      final newSnake = Snake(
        segments: [Position(x: 5, y: 5)], // Reset to initial position
        direction: Direction.right, // Reset to initial direction
        spinPositions: const [],
      );
      return state.copyWith(
        snake: newSnake,
        lives: newLives,
        score: newScore,
        spinCount: 0,
        originalLength: null,
        spinDistanceTraveled: 0,
      );
    }

    return state.copyWith(snake: state.snake.copyWith(segments: newSegments));
  }

  GameState changeDirection(GameState state, Direction newDirection) {
    if (_isOppositeDirection(state.snake.direction, newDirection)) {
      return state;
    }
    return state.copyWith(snake: state.snake.copyWith(direction: newDirection));
  }

  GameState spinSnake(GameState state) {
    if (state.snake.segments.length <= 1) {
      return state;
    }

    final newSegments = state.snake.segments.sublist(0, state.snake.segments.length - 1);
    final newSpinCount = state.spinCount + 1;
    final newLives = newSpinCount >= 4 ? state.lives - 1 : state.lives;
    final newSpinPositions = [...state.snake.spinPositions, newSegments.first];

    if (newLives <= 0) {
      final newScore = (state.score - 50).clamp(0, state.score);
      return state.copyWith(
        snake: state.snake.copyWith(segments: newSegments, spinPositions: newSpinPositions),
        spinCount: newSpinCount,
        lives: newLives,
        score: newScore,
        isPlaying: false,
        originalLength: null,
        spinDistanceTraveled: 0,
      );
    }

    return state.copyWith(
      snake: state.snake.copyWith(segments: newSegments, spinPositions: newSpinPositions),
      spinCount: newSpinCount,
      lives: newLives,
      originalLength: state.snake.segments.length,
      spinDistanceTraveled: 0,
    );
  }

  GameState regrowSnake(GameState state) {
    if (state.originalLength == null || state.snake.segments.length >= state.originalLength!) {
      return state.copyWith(
        snake: state.snake.copyWith(spinPositions: const []), // Clear spin positions
        originalLength: null,
        spinDistanceTraveled: 0,
      );
    }

    final newSegments = [...state.snake.segments, state.snake.segments.last];
    final newSpinPositions = state.snake.spinPositions.isNotEmpty
        ? state.snake.spinPositions.sublist(1)
        : state.snake.spinPositions;

    return state.copyWith(
      snake: state.snake.copyWith(segments: newSegments, spinPositions: newSpinPositions),
    );
  }

  GameState generateSpecialFood(GameState state) {
    if (state.specialFood != null) return state;
    final newSpecialFood = _generateFood(state.snake.segments, state.gridWidth, state.gridHeight);
    return state.copyWith(specialFood: newSpecialFood);
  }

  Food _generateFood(List<Position> segments, int gridWidth, int gridHeight) {
    Position position;
    do {
      position = Position(
        x: _random.nextInt(gridWidth).toDouble(),
        y: _random.nextInt(gridHeight).toDouble(),
      );
    } while (segments.contains(position));
    return Food(position: position, isSpecial: false, points: 10);
  }

  Position _getNewHead(Position head, Direction direction, int gridWidth, int gridHeight) {
    double newX = head.x;
    double newY = head.y;

    switch (direction) {
      case Direction.up:
        newY -= 1;
        break;
      case Direction.down:
        newY += 1;
        break;
      case Direction.left:
        newX -= 1;
        break;
      case Direction.right:
        newX += 1;
        break;
    }

    if (newX < 0) newX = gridWidth - 1;
    if (newX >= gridWidth) newX = 0;
    if (newY < 0) newY = gridHeight - 1;
    if (newY >= gridHeight) newY = 0;

    return Position(x: newX, y: newY);
  }

  bool _isGameOver(List<Position> segments, GameMode gameMode, int gridWidth, int gridHeight) {
    final head = segments.first;
    if (gameMode == GameMode.classic) {
      if (head.x < 0 || head.x >= gridWidth || head.y < 0 || head.y >= gridHeight) {
        return true;
      }
    }
    return segments.sublist(1).contains(head);
  }

  bool _isOppositeDirection(Direction current, Direction newDirection) {
    return (current == Direction.up && newDirection == Direction.down) ||
        (current == Direction.down && newDirection == Direction.up) ||
        (current == Direction.left && newDirection == Direction.right) ||
        (current == Direction.right && newDirection == Direction.left);
  }
}