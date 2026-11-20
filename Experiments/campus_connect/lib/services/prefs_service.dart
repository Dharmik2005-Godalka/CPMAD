import 'package:shared_preferences/shared_preferences.dart';

// Local persistence: theme, theme color, onboarding flag and last login email
class PrefsService {
  static const _darkKey = 'dark_mode';
  static const _emailKey = 'last_email';
  static const _colorKey = 'theme_color';
  static const _onboardingKey = 'onboarding_seen';

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
}
