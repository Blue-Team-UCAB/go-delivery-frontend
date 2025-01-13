import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:go_delivery_frontend/presentation/core/theme/theme.dart';

part 'themes_event.dart';
part 'themes_state.dart';

class ThemesBloc extends Bloc<ThemesEvent, ThemesState> {
  ThemesBloc() : super(const ThemesState()) {
    on<ToggleDarkmode>(_toggleColorMode);
    on<InitThemeSystem>(_initThemeSystem);
  }

  void _toggleColorMode(ToggleDarkmode event, Emitter<ThemesState> emit) {
    final currentMode = state.appTheme.colorMode;
    AppColorMode nextMode;

    switch (currentMode) {
      case AppColorMode.red:
        nextMode = AppColorMode.blue;
        break;
      case AppColorMode.blue:
        nextMode = AppColorMode.red;
        break;
      default:
        nextMode = AppColorMode.red; // Default to red if somehow another mode is set
    }

    emit(state.copyWith(
        appTheme: state.appTheme.copyWith(colorMode: nextMode)
    ));
  }

  void _initThemeSystem(InitThemeSystem event, Emitter<ThemesState> emit) {
    // If value is true, start with red, otherwise blue
    AppColorMode initialMode = event.value
        ? AppColorMode.red
        : AppColorMode.blue;

    emit(state.copyWith(
        appTheme: state.appTheme.copyWith(colorMode: initialMode),
        isInitialized: true
    ));
  }

  void changeTheme() {
    add(ToggleDarkmode());
  }

  void setInitTheme(bool value) {
    add(InitThemeSystem(value: value));
  }

  AppColorMode get currentColorMode => state.appTheme.colorMode;
}
