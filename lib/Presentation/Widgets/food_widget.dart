import 'package:flutter/material.dart';
import 'package:snake_game/Domain/Entities/food.dart';

class FoodWidget extends StatelessWidget {
  final double cellSize;
  final Food food;

  const FoodWidget({super.key, required this.cellSize, required this.food});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: food.position.x * cellSize,
      top: food.position.y * cellSize,
      child: Container(
        width: cellSize,
        height: cellSize,
        color: food.isSpecial ? Colors.red : Colors.yellow,
      ),
    );
  }
}