import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/Data/Models/high_score.dart';
import 'package:snake_game/Data/Repositories/high_score_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final HighScoreRepository highScoreRepository;

  MenuBloc({required this.highScoreRepository}) : super(const MenuState()) {
    on<LoadHighScores>(_onLoadHighScores);
  }

  Future<void> _onLoadHighScores(LoadHighScores event, Emitter<MenuState> emit) async {
    final highScores = await highScoreRepository.getHighScores();
    emit(state.copyWith(highScores: highScores));
  }
}
