import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Presentation/Blocs/Menu/menu_bloc.dart';
import 'package:snake_game/Presentation/Screens/menu_screen.dart';
import 'package:snake_game/Data/Repositories/high_score_repository.dart';

void main() {
  runApp(const SnakeGameApp());
}

class SnakeGameApp extends StatelessWidget {
  const SnakeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => MenuBloc(highScoreRepository: HighScoreRepository()),
        child: const MenuScreen(),
      ),
    );
  }
}