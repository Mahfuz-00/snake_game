import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final double x;
  final double y;

  const Position({required this.x, required this.y});

  @override
  List<Object> get props => [x, y];

  Position copyWith({double? x, double? y}) {
    return Position(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}