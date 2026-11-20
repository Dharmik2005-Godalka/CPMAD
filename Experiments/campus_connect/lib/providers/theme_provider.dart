import 'package:flutter/material.dart';
import '../services/prefs_service.dart';
import '../utils/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  final PrefsService _prefs = PrefsService();
  bool _isDark = false;
  int _colorIndex = 0;

  bool get isDark => _isDark;
  int get colorIndex => _colorIndex;
  Color get seedColor => AppTheme.seedColors[_colorIndex];
  ThemeMode get mode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> load() async {
    _isDark = await _prefs.getDarkMode();

    final saved = await _prefs.getColorIndex();
    _colorIndex =
        (saved >= 0 && saved < AppTheme.seedColors.length) ? saved : 0;

    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _isDark = value;
    notifyListeners();
    await _prefs.setDarkMode(value);
  }

  Future<void> setColorIndex(int index) async {
    _colorIndex = index;
    notifyListeners();
    await _prefs.setColorIndex(index);
  }
}
