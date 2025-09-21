import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Core/enums.dart';
import 'package:snake_game/Data/Models/high_score.dart';
import 'package:snake_game/Data/Repositories/high_score_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final HighScoreRepository highScoreRepository;

  MenuBloc({required this.highScoreRepository}) : super(const MenuState()) {
    on<SelectGameMode>(_onSelectGameMode);
    _fetchHighScores();
  }

  void _onSelectGameMode(SelectGameMode event, Emitter<MenuState> emit) {
    emit(state.copyWith(selectedMode: event.mode));
  }

  Future<void> _fetchHighScores() async {
    try {
      final highScores = await highScoreRepository.getHighScores();
      emit(state.copyWith(highScores: highScores));
    } catch (e) {
      print('Error fetching high scores: $e');
      emit(state.copyWith(highScores: []));
    }
  }
}