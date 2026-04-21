import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';

const _keyLocale = 'locale';
const _keyGate = 'language_gate_done';
const _legacyPrefsLocale = 'app_locale';

Future<bool> loadIsArabic() async {
  final db = DatabaseHelper();
  final v = await db.getAppSetting(_keyLocale);
  if (v != null) return v == 'ar';

  final prefs = await SharedPreferences.getInstance();
  final legacy = prefs.getBool(_legacyPrefsLocale);
  if (legacy != null) {
    await saveIsArabic(legacy);
    return legacy;
  }
  return true;
}

Future<void> saveIsArabic(bool isArabic) async {
  final db = DatabaseHelper();
  await db.setAppSetting(_keyLocale, isArabic ? 'ar' : 'en');
}

Future<bool> loadLanguageGateCompleted() async {
  final db = DatabaseHelper();
  final v = await db.getAppSetting(_keyGate);
  return v == '1';
}

Future<void> saveLanguageGateCompleted() async {
  final db = DatabaseHelper();
  await db.setAppSetting(_keyGate, '1');
}
