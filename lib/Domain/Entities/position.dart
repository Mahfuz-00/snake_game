import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final int x;
  final int y;

  const Position(this.x, this.y);

  @override
  List<Object> get props => [x, y];
}