part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();
}

class LoadHighScores extends MenuEvent {
  @override
  List<Object> get props => [];
}
