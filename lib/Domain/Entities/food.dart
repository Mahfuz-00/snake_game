import 'package:equatable/equatable.dart';
import 'package:snake_game/Domain/Entities/position.dart';

class Food extends Equatable {
  final Position position;
  final bool isSpecial;
  final int points;

  const Food({
    required this.position,
    this.isSpecial = false,
    this.points = 1, // Regular food: 1 points
  });

  @override
  List<Object> get props => [position, isSpecial, points];
}