import 'package:shared_preferences/shared_preferences.dart';

/// Stores the list of saved splits as key-value data (SharedPreferences).
class HistoryStorage {
  static const String historyKey = 'history';

  // >>> Q7A1 START
  Future<List<String>> load() async {
    // TODO (Q7-A): saved entries, empty list when nothing is saved
    return [];
  }

  Future<void> save(List<String> entries) async {
    // TODO (Q7-A)
  }

  Future<void> clear() async {
    // TODO (Q7-A)
  }
  // <<< Q7A1 END
}
