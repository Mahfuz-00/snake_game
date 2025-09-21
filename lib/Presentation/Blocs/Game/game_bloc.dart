import 'dart:async';
import 'dart:math';
import 'package:equatable/equatable.dart';
import '../../../Data/Models/high_score.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/enums.dart';
import '../../../Data/Repositories/high_score_repository.dart';
import '../../../Domain/Entities/food.dart';
import '../../../Domain/Entities/position.dart';
import '../../../Domain/Entities/snake.dart';
import '../../../Domain/Usecases/game_use_case.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameUseCase gameUseCase;
  final HighScoreRepository highScoreRepository;
  Timer? _gameTimer;
  Timer? _specialFoodTimer;

  GameBloc(this.gameUseCase, this.highScoreRepository) : super(const GameState()) {
    on<StartGame>(_onStartGame);
    on<ChangeDirection>(_onChangeDirection);
    on<PerformSpin>(_onPerformSpin);
    on<Tick>(_onTick);
  }

  void _onStartGame(StartGame event, Emitter<GameState> emit) {
    _gameTimer?.cancel();
    _specialFoodTimer?.cancel();

    final gridWidth = event.gridWidth;
    final gridHeight = event.gridHeight;
    final snake = Snake(
      segments: [Position(gridWidth ~/ 2, gridHeight ~/ 2)],
      direction: Direction.right,
    );
    final food = gameUseCase.generateFood(snake, gridWidth, gridHeight, 1, 0);

    _gameTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      add(Tick());
    });

    emit(state.copyWith(
      snake: snake,
      food: food,
      gameMode: event.gameMode,
      gridWidth: gridWidth,
      gridHeight: gridHeight,
      isPlaying: true,
      score: 0,
      lives: 1,
      foodCount: 1,
      specialFoodCount: 0,
      speedMultiplier: 1.0,
    ));
  }

  void _onChangeDirection(ChangeDirection event, Emitter<GameState> emit) {
    print('Changing direction to: ${event.direction}');
    if (!_isOppositeDirection(event.direction, state.snake.direction)) {
      emit(state.copyWith(snake: state.snake.copyWith(direction: event.direction)));
    }
  }

  void _onPerformSpin(PerformSpin event, Emitter<GameState> emit) {
    print('Performing spin, current segments: ${state.snake.segments.length}');
    if (state.snake.spinPositions.length >= 3 || state.snake.segments.length <= 1) {
      _gameOver(emit);
      return;
    }
    final newSnake = gameUseCase.performSpin(state.snake);
    emit(state.copyWith(snake: newSnake));
  }

  void _onTick(Tick event, Emitter<GameState> emit) {
    if (!state.isPlaying) return;

    final isFoodEaten = state.snake.segments.first == state.food.position;
    final grow = isFoodEaten && !state.food.isSpecial; // Grow only for regular food
    var newSnake = gameUseCase.moveSnake(
      state.snake,
      state.gridWidth,
      state.gridHeight,
      state.gameMode,
      grow: grow,
    );
    var newScore = state.score;
    var newFood = state.food;
    var newFoodCount = state.foodCount;
    var newSpecialFoodCount = state.specialFoodCount;
    var newLives = state.lives;
    var newRewards = state.activeRewards;

    print('Tick: Snake length = ${newSnake.segments.length}, Food eaten = $isFoodEaten, Grow = $grow');

    if (gameUseCase.checkCollision(newSnake, state.gridWidth, state.gridHeight, state.gameMode)) {
      if (newLives > 1) {
        newLives--;
        newSnake = Snake(
          segments: [Position(state.gridWidth ~/ 2, state.gridHeight ~/ 2)],
          direction: Direction.right,
        );
      } else {
        _gameOver(emit);
        return;
      }
    }

    if (isFoodEaten) {
      newScore += state.food.points;
      newFoodCount++;
      newSpecialFoodCount = state.food.isSpecial ? newSpecialFoodCount + 1 : newSpecialFoodCount;
      newFood = gameUseCase.generateFood(newSnake, state.gridWidth, state.gridHeight, newFoodCount, newSpecialFoodCount);
      // Placeholder: Play eat sound (regular: eat.wav, special: special_eat.wav)
      if (newFood.isSpecial) {
        _specialFoodTimer?.cancel();
        _specialFoodTimer = Timer(const Duration(seconds: 5), () {
          add(Tick()); // Refresh food after 5 seconds
        });
      }

      if (newScore >= (state.nextMilestone)) {
        final random = Random();
        final reward = RewardType.values[random.nextInt(RewardType.values.length)];
        newRewards = [...newRewards, reward];
        if (reward == RewardType.extraLife) newLives++;
        if (reward == RewardType.bonusPoints) newScore += 100;
        if (reward == RewardType.speedReduction || reward == RewardType.bonusSpin) {
          Timer(const Duration(seconds: 10), () {
            add(Tick()); // Remove temporary reward
          });
        }
        if (reward == RewardType.shrinkSize) {
          final newLength = (newSnake.segments.length * 0.9).floor();
          newSnake = newSnake.copyWith(segments: newSnake.segments.sublist(0, newLength.clamp(1, newSnake.segments.length)));
        }
        // Placeholder: Play milestone sound (milestone.wav)
      }
    }

    final newSpeedMultiplier = 1.0 + (newFoodCount ~/ 2) * 0.5;
    if (newSpeedMultiplier != state.speedMultiplier) {
      _gameTimer?.cancel();
      _gameTimer = Timer.periodic(Duration(milliseconds: (300 / newSpeedMultiplier).floor()), (timer) {
        add(Tick());
      });
    }

    emit(state.copyWith(
      snake: newSnake,
      food: newFood,
      score: newScore,
      lives: newLives,
      foodCount: newFoodCount,
      specialFoodCount: newSpecialFoodCount,
      speedMultiplier: newSpeedMultiplier,
      activeRewards: newRewards,
      nextMilestone: (newScore ~/ 1000 + 1) * 1000,
    ));
  }

  void _gameOver(Emitter<GameState> emit) async {
    _gameTimer?.cancel();
    _specialFoodTimer?.cancel();
    await highScoreRepository.saveHighScore(HighScore(score: state.score, date: DateTime.now()));
    // Placeholder: Play game over sound (game_over.wav)
    emit(state.copyWith(isPlaying: false));
  }

  bool _isOppositeDirection(Direction newDir, Direction currentDir) {
    return (newDir == Direction.up && currentDir == Direction.down) ||
        (newDir == Direction.down && currentDir == Direction.up) ||
        (newDir == Direction.left && currentDir == Direction.right) ||
        (newDir == Direction.right && currentDir == Direction.left);
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    _specialFoodTimer?.cancel();
    return super.close();
  }
}