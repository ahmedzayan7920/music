import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final SharedPreferences _sharedPreferences;

  AppCubit({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences,
        super(AppInitialState()) {
    _onInitialEvent();
  }

  late bool _isDarkMode;

  bool get isDarkMode => _isDarkMode;

  _onInitialEvent() {
    if (_sharedPreferences.getString("theme") != null) {
      if (_sharedPreferences.getString("theme") == "light") {
        _isDarkMode = false;
        emit(AppLightState());
      } else {
        _isDarkMode = true;
        emit(AppDarkState());
      }
    } else {
      _isDarkMode = true;
      emit(AppDarkState());
    }
  }

  onDarkEvent() {
    _sharedPreferences.setString("theme", "dark");
    _isDarkMode = true;
    emit(AppDarkState());
  }

  onLightEvent() {
    _sharedPreferences.setString("theme", "light");
    _isDarkMode = false;
    emit(AppLightState());
  }
}
