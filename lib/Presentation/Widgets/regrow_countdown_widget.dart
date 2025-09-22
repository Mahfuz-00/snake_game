import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Presentation/Blocs/Game/game_bloc.dart';

class RegrowCountdownWidget extends StatelessWidget {
  const RegrowCountdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state.originalLength == null || state.spinDistanceTraveled >= state.snake.segments.length) {
          return const SizedBox.shrink();
        }
        final spacesLeft = state.snake.segments.length - state.spinDistanceTraveled;
        return Text(
          'Regrow in: $spacesLeft',
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}