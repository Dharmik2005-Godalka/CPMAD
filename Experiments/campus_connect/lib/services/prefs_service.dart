import 'package:shared_preferences/shared_preferences.dart';

class PrefsService 
{
  static const _darkKey = 'dark_mode';
  static const _emailKey = 'last_email';
  static const _colorKey = 'theme_color';
  static const _onboardingKey = 'onboarding_seen';
  static const _rsvpKey = 'rsvp_ids';
  static const _localeKey = 'locale_code';

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkKey) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, value);
  }

  Future<String> getLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? '';
  }

  Future<void> setLastEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  Future<int> getColorIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_colorKey) ?? 0;
  }

  Future<void> setColorIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, index);
  }

  Future<bool> getOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  // RSVP status: ids of the events the user is going to
  Future<Set<String>> getRsvpIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_rsvpKey) ?? []).toSet();
  }

  Future<void> setRsvpIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_rsvpKey, ids.toList());
  }

  Future<String> getLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey) ?? 'en';
  }

  Future<void> setLocaleCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, code);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
