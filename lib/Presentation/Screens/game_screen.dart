import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Data/Repositories/high_score_repository.dart';
import 'package:snake_game/Domain/Usecases/game_use_case.dart';
import 'package:snake_game/Presentation/Blocs/Game/game_bloc.dart';
import 'package:snake_game/Presentation/Widgets/food_widget.dart';
import 'package:snake_game/Presentation/Widgets/game_board.dart';
import 'package:snake_game/Presentation/Widgets/reward_widget.dart';
import 'package:snake_game/Presentation/Widgets/score_widget.dart';
import 'package:snake_game/Presentation/Widgets/spin_counter_widget.dart';
import 'package:snake_game/Presentation/Widgets/game_over_dialog.dart';

class GameScreen extends StatelessWidget {
  final GameMode gameMode;

  const GameScreen({super.key, required this.gameMode});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const cellSize = 20.0;
    final gridWidth = (size.width / cellSize).floor();
    final gridHeight = (size.height / cellSize).floor() - 5; // Adjust for UI elements

    return BlocProvider(
      create: (context) => GameBloc(
        GameUseCase(),
        HighScoreRepository(),
      )..add(StartGame(gameMode, gridWidth, gridHeight)),
      child: Scaffold(
        body: BlocListener<GameBloc, GameState>(
          listener: (context, state) {
            if (!state.isPlaying) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => GameOverDialog(score: state.score),
              );
            }
          },
          child: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ScoreWidget(),
                      SpinCounterWidget(),
                    ],
                  ),
                ),
              ),
              RewardWidget(),
              Expanded(
                child: GameBoard(cellSize: cellSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}