import 'package:shared_preferences/shared_preferences.dart';

// Local persistence: theme choice and the last email used to log in
class PrefsService {
  static const _darkKey = 'dark_mode';
  static const _emailKey = 'last_email';

  Future<bool> getDarkMode() async 
  {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkKey) ?? false;
  }

  Future<void> setDarkMode(bool value) async 
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, value);
  }

  Future<String> getLastEmail() async 
  {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? '';
  }

  Future<void> setLastEmail(String email) async 
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }
}
