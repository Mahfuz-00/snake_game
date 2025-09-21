import 'package:flutter/material.dart';
import 'package:snake_game/Domain/Entities/snake.dart';

class SnakeWidget extends StatefulWidget {
  final double cellSize;
  final Snake snake;

  const SnakeWidget({super.key, required this.cellSize, required this.snake});

  @override
  _SnakeWidgetState createState() => _SnakeWidgetState();
}

class _SnakeWidgetState extends State<SnakeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void didUpdateWidget(SnakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.snake.spinPositions.length < widget.snake.spinPositions.length) {
      _animationController.forward(from: 0).then((_) => _animationController.reset());
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snake.segments.isEmpty) {
      return const SizedBox.shrink(); // Handle empty snake
    }

    return Stack(
      children: [
        for (var i = 0; i < widget.snake.segments.length; i++)
          Positioned(
            left: widget.snake.segments[i].x * widget.cellSize,
            top: widget.snake.segments[i].y * widget.cellSize,
            child: i == 0 && widget.snake.spinPositions.contains(widget.snake.segments[i])
                ? RotationTransition(
              turns: _rotationAnimation,
              child: Container(
                width: widget.cellSize,
                height: widget.cellSize,
                color: Colors.green,
              ),
            )
                : Container(
              width: widget.cellSize,
              height: widget.cellSize,
              color: i == 0 ? Colors.green : Colors.lightGreen,
            ),
          ),
      ],
    );
  }
}