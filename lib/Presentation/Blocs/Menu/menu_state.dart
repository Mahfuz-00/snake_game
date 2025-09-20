part of 'menu_bloc.dart';

class MenuState extends Equatable {
  final List<HighScore> highScores;

  const MenuState({this.highScores = const []});

  MenuState copyWith({List<HighScore>? highScores}) {
    return MenuState(highScores: highScores ?? this.highScores);
  }

  @override
  List<Object> get props => [highScores];
}
