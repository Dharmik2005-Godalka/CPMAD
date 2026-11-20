import 'package:flutter/material.dart';
import '../services/prefs_service.dart';

class ThemeProvider extends ChangeNotifier 
{
  final PrefsService _prefs = PrefsService();
  bool _isDark = false;

  bool get isDark => _isDark;
  ThemeMode get mode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> load() async 
  {
    _isDark = await _prefs.getDarkMode();
    notifyListeners();
  }

  Future<void> setDark(bool value) async 
  {
    _isDark = value;
    notifyListeners();
    await _prefs.setDarkMode(value);
  }
}
