import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Presentation/Blocs/Game/game_bloc.dart';
import 'package:snake_game/Presentation/Blocs/Settings/settings_bloc.dart';
import 'package:snake_game/Presentation/Widgets/food_widget.dart';
import 'package:snake_game/Presentation/Widgets/snake_widget.dart';

class GameBoard extends StatefulWidget {
  final double cellSize;

  const GameBoard({super.key, required this.cellSize});

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Offset _buttonPanelPosition = const Offset(20, 20); // Initial position for Button controls
  Offset _joystickPosition = Offset.zero; // Initial position for TouchButton joystick
  bool _isDraggingJoystick = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<GameBloc, GameState>(
          builder: (context, gameState) {
            return Stack(
              children: [
                GestureDetector(
                  onPanUpdate: settingsState.controlType == ControlType.touch
                      ? (details) {
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
                  }
                      : null,
                  onTap: settingsState.controlType == ControlType.touch
                      ? () {
                    context.read<GameBloc>().add(PerformSpin());
                    print('Tap detected for spin');
                  }
                      : null,
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      children: [
                        SnakeWidget(cellSize: widget.cellSize, snake: gameState.snake),
                        if (gameState.food != null) FoodWidget(cellSize: widget.cellSize, food: gameState.food!),
                        if (gameState.specialFood != null)
                          FoodWidget(cellSize: widget.cellSize, food: gameState.specialFood!),
                      ],
                    ),
                  ),
                ),
                if (settingsState.controlType == ControlType.button)
                  Positioned(
                    left: _buttonPanelPosition.dx,
                    top: _buttonPanelPosition.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _buttonPanelPosition += details.delta;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 50),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<GameBloc>().add(const ChangeDirection(Direction.up));
                                  },
                                  child: const Icon(Icons.arrow_upward),
                                ),
                                const SizedBox(width: 50),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<GameBloc>().add(const ChangeDirection(Direction.left));
                                  },
                                  child: const Icon(Icons.arrow_back),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<GameBloc>().add(PerformSpin());
                                    print('Button spin triggered');
                                  },
                                  child: const Icon(Icons.rotate_right),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<GameBloc>().add(const ChangeDirection(Direction.right));
                                  },
                                  child: const Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 50),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<GameBloc>().add(const ChangeDirection(Direction.down));
                                  },
                                  child: const Icon(Icons.arrow_downward),
                                ),
                                const SizedBox(width: 50),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (settingsState.controlType == ControlType.touchButton)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: Center(
                      child: GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            _isDraggingJoystick = true;
                            _joystickPosition = details.localPosition;
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            _joystickPosition += details.delta;
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
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            _isDraggingJoystick = false;
                            _joystickPosition = Offset.zero;
                          });
                        },
                        onDoubleTap: () {
                          context.read<GameBloc>().add(PerformSpin());
                          print('Joystick double tap spin triggered');
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isDraggingJoystick ? Colors.blue.withOpacity(0.7) : Colors.grey.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}