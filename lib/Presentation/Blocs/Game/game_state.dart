part of 'game_bloc.dart';

class GameState extends Equatable {
  final Snake snake;
  final Food food;
  final GameMode gameMode;
  final int gridWidth;
  final int gridHeight;
  final bool isPlaying;
  final int score;
  final int lives;
  final int foodCount;
  final int specialFoodCount;
  final double speedMultiplier;
  final List<RewardType> activeRewards;
  final int nextMilestone;

  const GameState({
    this.snake = const Snake(segments: [], direction: Direction.right),
    this.food = const Food(position: Position(0, 0)),
    this.gameMode = GameMode.classic,
    this.gridWidth = 0,
    this.gridHeight = 0,
    this.isPlaying = false,
    this.score = 0,
    this.lives = 1,
    this.foodCount = 1,
    this.specialFoodCount = 0,
    this.speedMultiplier = 1.0,
    this.activeRewards = const [],
    this.nextMilestone = 1000,
  });

  GameState copyWith({
    Snake? snake,
    Food? food,
    GameMode? gameMode,
    int? gridWidth,
    int? gridHeight,
    bool? isPlaying,
    int? score,
    int? lives,
    int? foodCount,
    int? specialFoodCount,
    double? speedMultiplier,
    List<RewardType>? activeRewards,
    int? nextMilestone,
  }) {
    return GameState(
      snake: snake ?? this.snake,
      food: food ?? this.food,
      gameMode: gameMode ?? this.gameMode,
      gridWidth: gridWidth ?? this.gridWidth,
      gridHeight: gridHeight ?? this.gridHeight,
      isPlaying: isPlaying ?? this.isPlaying,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      foodCount: foodCount ?? this.foodCount,
      specialFoodCount: specialFoodCount ?? this.specialFoodCount,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
      activeRewards: activeRewards ?? this.activeRewards,
      nextMilestone: nextMilestone ?? this.nextMilestone,
    );
  }

  @override
  List<Object> get props => [
    snake,
    food,
    gameMode,
    gridWidth,
    gridHeight,
    isPlaying,
    score,
    lives,
    foodCount,
    specialFoodCount,
    speedMultiplier,
    activeRewards,
    nextMilestone,
  ];
}
