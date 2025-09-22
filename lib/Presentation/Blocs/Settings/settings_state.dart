part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final ControlType controlType;

  const SettingsState({required this.controlType});

  @override
  List<Object> get props => [controlType];
}