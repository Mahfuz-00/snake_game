import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Presentation/Blocs/Game/game_bloc.dart';
import 'package:snake_game/Presentation/Widgets/food_widget.dart';
import 'package:snake_game/Presentation/Widgets/snake_widget.dart';

class GameBoard extends StatelessWidget {
  final double cellSize;

  const GameBoard({super.key, required this.cellSize});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return GestureDetector(
          onPanUpdate: (details) {
            final dx = details.delta.dx;
            final dy = details.delta.dy;
            if (dx.abs() > dy.abs() && dx.abs() > 5) {
              if (dx > 0) {
                context.read<GameBloc>().add(const ChangeDirection(Direction.right));
              } else {
                context.read<GameBloc>().add(const ChangeDirection(Direction.left));
              }
            } else if (dy.abs() > 5) {
              if (dy > 0) {
                context.read<GameBloc>().add(const ChangeDirection(Direction.down));
              } else {
                context.read<GameBloc>().add(const ChangeDirection(Direction.up));
              }
            }
          },
          onTap: () {
            context.read<GameBloc>().add(PerformSpin());
            print('Tap detected for spin');
          },
          child: Container(
            color: Colors.black,
            child: Stack(
              children: [
                SnakeWidget(cellSize: cellSize, snake: state.snake),
                if (state.food != null) FoodWidget(cellSize: cellSize, food: state.food!),
                if (state.specialFood != null) FoodWidget(cellSize: cellSize, food: state.specialFood!),
              ],
            ),
          ),
        );
      },
    );
  }
}