import 'locale_storage_io.dart'
    if (dart.library.html) 'locale_storage_web.dart' as impl;

Future<bool> loadIsArabic() => impl.loadIsArabic();

Future<void> saveIsArabic(bool isArabic) => impl.saveIsArabic(isArabic);

Future<bool> loadLanguageGateCompleted() => impl.loadLanguageGateCompleted();

Future<void> saveLanguageGateCompleted() => impl.saveLanguageGateCompleted();
