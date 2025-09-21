part of 'menu_bloc.dart';

abstract class MenuEvent {
  const MenuEvent();
}

class SelectGameMode extends MenuEvent {
  final GameMode mode;

  const SelectGameMode(this.mode);
}