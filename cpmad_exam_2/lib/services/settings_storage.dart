import 'package:shared_preferences/shared_preferences.dart';

import '../models/calc_settings.dart';

/// Remembers the last calculator values (tip, people, GST, amount).
class SettingsStorage {
  static const String tipKey = 'tip';
  static const String peopleKey = 'people';
  static const String gstKey = 'gst';
  static const String amountKey = 'amount';

  // >>> Q7B1 START
  Future<void> save(CalcSettings settings) async {
    // TODO (Q7-B)
  }

  Future<CalcSettings> load() async {
    // TODO (Q7-B): defaults for missing keys, clamp tip 0-100 and people 1-10
    return const CalcSettings();
  }

  Future<void> clear() async {
    // TODO (Q7-B)
  }
  // <<< Q7B1 END
}
