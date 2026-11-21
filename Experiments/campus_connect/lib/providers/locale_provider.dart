import 'package:flutter/material.dart';
import '../services/prefs_service.dart';
import '../utils/app_strings.dart';

class LocaleProvider extends ChangeNotifier 
{
  final PrefsService _prefs = PrefsService();
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> load() async {
    final code = await _prefs.getLocaleCode();
    final supported = AppStrings.supportedLocales.any(
      (l) => l.languageCode == code,
    );
    _locale = supported ? Locale(code) : const Locale('en');
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    await _prefs.setLocaleCode(locale.languageCode);
  }
}
