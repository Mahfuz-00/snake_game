import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Presentation/Blocs/Game/game_bloc.dart';
import 'package:snake_game/Presentation/Widgets/snake_widget.dart';

import 'food_widget.dart';

class GameBoard extends StatelessWidget {
  final double cellSize;

  const GameBoard({super.key, required this.cellSize});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Container(
          color: Colors.black,
          child: Stack(
            children: [
              SnakeWidget(cellSize: cellSize, snake: state.snake),
              FoodWidget(cellSize: cellSize, food: state.food),
            ],
          ),
        );
      },
    );
  }
}