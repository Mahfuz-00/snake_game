part of 'game_bloc.dart';

class GameState extends Equatable {
  final Snake snake;
  final Food? food;
  final Food? specialFood;
  final int score;
  final int spinCount;
  final bool isPlaying;
  final GameMode gameMode;
  final int gridWidth;
  final int gridHeight;
  final int? originalLength;
  final int spinDistanceTraveled;
  final int lives;
  final List<RewardType> activeRewards;

  const GameState({
    required this.snake,
    this.food,
    this.specialFood,
    required this.score,
    required this.spinCount,
    required this.isPlaying,
    required this.gameMode,
    required this.gridWidth,
    required this.gridHeight,
    this.originalLength,
    this.spinDistanceTraveled = 0,
    this.lives = 3,
    this.activeRewards = const [],
  });

  GameState copyWith({
    Snake? snake,
    Food? food,
    Food? specialFood,
    int? score,
    int? spinCount,
    bool? isPlaying,
    GameMode? gameMode,
    int? gridWidth,
    int? gridHeight,
    int? originalLength,
    int? spinDistanceTraveled,
    int? lives,
    List<RewardType>? activeRewards,
  }) {
    return GameState(
      snake: snake ?? this.snake,
      food: food ?? this.food,
      specialFood: specialFood ?? this.specialFood,
      score: score ?? this.score,
      spinCount: spinCount ?? this.spinCount,
      isPlaying: isPlaying ?? this.isPlaying,
      gameMode: gameMode ?? this.gameMode,
      gridWidth: gridWidth ?? this.gridWidth,
      gridHeight: gridHeight ?? this.gridHeight,
      originalLength: originalLength ?? this.originalLength,
      spinDistanceTraveled: spinDistanceTraveled ?? this.spinDistanceTraveled,
      lives: lives ?? this.lives,
      activeRewards: activeRewards ?? this.activeRewards,
    );
  }

  @override
  List<Object?> get props => [
    snake,
    food,
    specialFood,
    score,
    spinCount,
    isPlaying,
    gameMode,
    gridWidth,
    gridHeight,
    originalLength,
    spinDistanceTraveled,
    lives,
    activeRewards,
  ];
}