import 'package:equatable/equatable.dart';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Domain/Entities/position.dart';

class Snake extends Equatable {
  final List<Position> segments;
  final Direction direction;
  final List<Position> spinPositions;

  const Snake({
    required this.segments,
    required this.direction,
    this.spinPositions = const [],
  });

  Snake copyWith({
    List<Position>? segments,
    Direction? direction,
    List<Position>? spinPositions,
  }) {
    return Snake(
      segments: segments ?? this.segments,
      direction: direction ?? this.direction,
      spinPositions: spinPositions ?? this.spinPositions,
    );
  }

  @override
  List<Object> get props => [segments, direction, spinPositions];
}