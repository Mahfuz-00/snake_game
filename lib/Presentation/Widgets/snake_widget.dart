import 'package:flutter/material.dart';
import 'package:snake_game/Domain/Entities/position.dart';
import 'package:snake_game/Domain/Entities/snake.dart';

class SnakeWidget extends StatefulWidget {
  final double cellSize;
  final Snake snake;

  const SnakeWidget({super.key, required this.cellSize, required this.snake});

  @override
  _SnakeWidgetState createState() => _SnakeWidgetState();
}

class _SnakeWidgetState extends State<SnakeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> _currentPositions;
  late List<Offset> _targetPositions;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100), // Match GameBloc tick rate
      vsync: this,
    )..repeat();
    _currentPositions = widget.snake.segments.map((pos) => Offset(pos.x * widget.cellSize, pos.y * widget.cellSize)).toList();
    _targetPositions = _currentPositions;
  }

  @override
  void didUpdateWidget(SnakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.snake.segments != widget.snake.segments) {
      _currentPositions = _targetPositions;
      _targetPositions = widget.snake.segments.map((pos) => Offset(pos.x * widget.cellSize, pos.y * widget.cellSize)).toList();
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final List<Offset> interpolatedPositions = List.generate(
          widget.snake.segments.length,
              (index) {
            final start = _currentPositions[index];
            final end = _targetPositions[index];
            final t = _controller.value;
            return Offset(
              start.dx + (end.dx - start.dx) * t,
              start.dy + (end.dy - start.dy) * t,
            );
          },
        );

        return Stack(
          children: List.generate(
            widget.snake.segments.length,
                (index) {
              final isHead = index == 0;
              final isSpinning = widget.snake.spinPositions.contains(widget.snake.segments[index]);
              return Positioned(
                left: interpolatedPositions[index].dx,
                top: interpolatedPositions[index].dy,
                child: Transform.rotate(
                  angle: isSpinning ? _controller.value * 2 * 3.1416 : 0,
                  child: Container(
                    width: widget.cellSize,
                    height: widget.cellSize,
                    decoration: BoxDecoration(
                      color: isHead ? Colors.green : Colors.lightGreen,
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}