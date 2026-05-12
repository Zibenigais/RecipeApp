import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class ThemeProvider extends ChangeNotifier {
  final SettingsService _settings;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  ThemeProvider(this._settings);

  Future<void> load() async {
    final dark = await _settings.getDarkMode();
    _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggle() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _settings.setDarkMode(_themeMode == ThemeMode.dark);
    notifyListeners();
  }
}
