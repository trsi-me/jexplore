import 'package:shared_preferences/shared_preferences.dart';

const _keyLocale = 'app_locale';
const _keyGate = 'language_gate_done';

Future<bool> loadIsArabic() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_keyLocale) ?? true;
}

Future<void> saveIsArabic(bool isArabic) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_keyLocale, isArabic);
}

Future<bool> loadLanguageGateCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_keyGate) ?? false;
}

Future<void> saveLanguageGateCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_keyGate, true);
}
