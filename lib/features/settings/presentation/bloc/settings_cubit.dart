import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

@singleton
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._prefs) : super(const SettingsState());

  final SharedPreferences _prefs;

  static const _keyTheme = 'settings_theme';
  static const _keyLocale = 'settings_locale';

  Future<void> loadSettings() async {
    final themeIndex = _prefs.getInt(_keyTheme) ?? ThemeMode.system.index;
    final localeStr = _prefs.getString(_keyLocale);

    emit(
      SettingsState(
        themeMode: ThemeMode.values[themeIndex],
        locale: localeStr != null ? Locale(localeStr) : null,
      ),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_keyTheme, mode.index);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_keyLocale, locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  Future<void> resetLocale() async {
    await _prefs.remove(_keyLocale);
    emit(state.copyWith(clearLocale: true));
  }
}
