import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Presentation/Blocs/Game/game_bloc.dart';

class RewardWidget extends StatelessWidget {
  const RewardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state.activeRewards.isEmpty) return const SizedBox.shrink();
        return Text(
          'Reward: ${state.activeRewards.last.toString().split('.').last}',
          style: const TextStyle(fontSize: 16, color: Colors.blue),
        );
      },
    );
  }
}