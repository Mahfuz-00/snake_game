part of 'menu_bloc.dart';

class MenuState {
  final GameMode? selectedMode;
  final List<HighScore> highScores;

  const MenuState({
    this.selectedMode,
    this.highScores = const [],
  });

  MenuState copyWith({
    GameMode? selectedMode,
    List<HighScore>? highScores,
  }) {
    return MenuState(
      selectedMode: selectedMode ?? this.selectedMode,
      highScores: highScores ?? this.highScores,
    );
  }
}