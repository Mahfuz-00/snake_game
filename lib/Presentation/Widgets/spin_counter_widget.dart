import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Presentation/Blocs/Game/game_bloc.dart';

class SpinCounterWidget extends StatelessWidget {
  const SpinCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Text(
          'Spins: ${state.spinCount}/3',
          style: const TextStyle(fontSize: 20, color: Colors.black),
        );
      },
    );
  }
}