import 'package:snake_game/Domain/Entities/food.dart';
import 'package:snake_game/Domain/Entities/snake.dart';
import 'package:snake_game/Core/enums.dart';

abstract class GameRepository {
  Snake moveSnake(Snake snake, int gridWidth, int gridHeight, GameMode mode);
  bool checkCollision(Snake snake, int gridWidth, int gridHeight, GameMode mode);
  Food generateFood(Snake snake, int gridWidth, int gridHeight, int foodCount, int specialFoodCount);
}