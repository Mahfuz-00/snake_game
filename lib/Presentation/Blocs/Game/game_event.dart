part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class StartGame extends GameEvent {
  final GameMode gameMode;
  final int gridWidth;
  final int gridHeight;

  const StartGame(this.gameMode, this.gridWidth, this.gridHeight);

  @override
  List<Object> get props => [gameMode, gridWidth, gridHeight];
}

class ChangeDirection extends GameEvent {
  final Direction direction;

  const ChangeDirection(this.direction);

  @override
  List<Object> get props => [direction];
}

class PerformSpin extends GameEvent {
  @override
  List<Object> get props => [];
}

class Tick extends GameEvent {
  @override
  List<Object> get props => [];
}
