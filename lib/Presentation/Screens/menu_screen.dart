import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Data/Repositories/high_score_repository.dart';
import 'package:snake_game/Presentation/Blocs/Menu/menu_bloc.dart';
import 'package:snake_game/Presentation/Blocs/Settings/settings_bloc.dart';
import 'package:snake_game/Presentation/Screens/game_screen.dart';
import 'package:snake_game/Presentation/Widgets/high_score_widget.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MenuBloc(highScoreRepository: HighScoreRepository()),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Snake Game'),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<MenuBloc, MenuState>(
            builder: (context, menuState) {
              return BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.read<MenuBloc>().add(const SelectGameMode(GameMode.classic));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GameScreen(gameMode: GameMode.classic),
                              ),
                            );
                          },
                          child: const Text('Classic Mode'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<MenuBloc>().add(const SelectGameMode(GameMode.rapid));
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
                        DropdownButton<ControlType>(
                          value: settingsState.controlType,
                          items: ControlType.values
                              .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.toString().split('.').last.capitalize()),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              context.read<SettingsBloc>().add(ChangeControlType(value));
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        HighScoreWidget(highScores: menuState.highScores),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// Extension to capitalize control type names
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}