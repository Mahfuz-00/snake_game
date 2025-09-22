import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/Core/enums.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState(controlType: ControlType.touch)) {
    on<ChangeControlType>(_onChangeControlType);
  }

  Future<void> _onChangeControlType(ChangeControlType event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('controlType', event.controlType.toString().split('.').last);
    emit(SettingsState(controlType: event.controlType));
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
