import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Data/Models/high_score.dart';
import 'package:snake_game/Data/Repositories/high_score_repository.dart';
import 'package:snake_game/Domain/Usecases/game_use_case.dart';
import 'package:snake_game/Domain/Entities/snake.dart';
import 'package:snake_game/Domain/Entities/position.dart';

import '../../../Domain/Entities/food.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameUseCase gameUseCase;
  final HighScoreRepository highScoreRepository;
  Timer? _gameTimer;
  Timer? _specialFoodTimer;

  GameBloc(this.gameUseCase, this.highScoreRepository)
      : super(GameState(
    snake: const Snake(
      segments: [Position(x: 5, y: 5)],
      direction: Direction.right,
    ),
    score: 0,
    spinCount: 0,
    isPlaying: false,
    gameMode: GameMode.classic,
    gridWidth: 0,
    gridHeight: 0,
    lives: 3,
    activeRewards: const [],
  )) {
    on<StartGame>(_onStartGame);
    on<Tick>(_onTick);
    on<ChangeDirection>(_onChangeDirection);
    on<PerformSpin>(_onPerformSpin);
  }

  void _onStartGame(StartGame event, Emitter<GameState> emit) {
    _gameTimer?.cancel();
    _specialFoodTimer?.cancel();

    final initialState = gameUseCase.initializeGame(event.gameMode, event.gridWidth, event.gridHeight);
    emit(initialState);

    _gameTimer = Timer.periodic(Duration(milliseconds: event.gameMode == GameMode.classic ? 500 : 300), (timer) {
      add(Tick());
    });

    _specialFoodTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final newState = gameUseCase.generateSpecialFood(state);
      emit(newState);
    });
  }

  Future<void> _onTick(Tick event, Emitter<GameState> emit) async {
    if (!state.isPlaying) return;

    var newState = gameUseCase.moveSnake(state);
    print('Tick: Snake length = ${newState.snake.segments.length}, Spin count = ${newState.spinCount}, Lives = ${newState.lives}, Score = ${newState.score}');

    if (!newState.isPlaying) {
      await _gameOver(emit);
      return;
    }

    // Handle regrowth after spin
    if (newState.originalLength != null && newState.spinDistanceTraveled < newState.snake.segments.length) {
      newState = newState.copyWith(
        spinDistanceTraveled: newState.spinDistanceTraveled + 1,
      );
      if (newState.spinDistanceTraveled >= newState.snake.segments.length && newState.originalLength != null) {
        newState = gameUseCase.regrowSnake(newState);
        print('Regrowing snake to original length: ${newState.originalLength}');
        newState = newState.copyWith(
          originalLength: null,
          spinDistanceTraveled: 0,
        );
      }
    }

    emit(newState);
  }

  void _onChangeDirection(ChangeDirection event, Emitter<GameState> emit) {
    final newState = gameUseCase.changeDirection(state, event.direction);
    print('Changing direction to: ${event.direction}');
    emit(newState);
  }

  Future<void> _onPerformSpin(PerformSpin event, Emitter<GameState> emit) async {
    if (state.snake.segments.length <= 1) {
      print('Cannot spin: Snake length is 1');
      return;
    }

    final newState = gameUseCase.spinSnake(state);
    print('Performing spin: New length = ${newState.snake.segments.length}, Spin count = ${newState.spinCount}, Lives = ${newState.lives}, Score = ${newState.score}');
    if (!newState.isPlaying) {
      await _gameOver(emit);
    } else {
      emit(newState);
    }
  }

  Future<void> _gameOver(Emitter<GameState> emit) async {
    print('Game over triggered in GameBloc');
    _gameTimer?.cancel();
    _specialFoodTimer?.cancel();
    try {
      await highScoreRepository.saveHighScore(HighScore(score: state.score, date: DateTime.now()));
    } catch (e) {
      print('Error saving high score: $e');
    }
    emit(state.copyWith(isPlaying: false));
  }

  @override
  Future<void> close() async {
    _gameTimer?.cancel();
    _specialFoodTimer?.cancel();
    super.close();
  }
}