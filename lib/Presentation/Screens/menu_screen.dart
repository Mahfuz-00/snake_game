import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Presentation/Blocs/Menu/menu_bloc.dart';
import 'package:snake_game/Presentation/Screens/game_screen.dart';
import 'package:snake_game/Presentation/Widgets/high_score_widget.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Snake Game')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(gameMode: GameMode.classic),
                  ),
                );
              },
              child: const Text('Classic Mode'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(gameMode: GameMode.rapid),
                  ),
                );
              },
              child: const Text('Rapid Mode'),
            ),
            const SizedBox(height: 20),
            BlocBuilder<MenuBloc, MenuState>(
              builder: (context, state) {
                context.read<MenuBloc>().add(LoadHighScores());
                return HighScoreWidget(highScores: state.highScores);
              },
            ),
          ],
        ),
      ),
    );
  }
}