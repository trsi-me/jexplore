import 'package:flutter/material.dart';
import 'app_strings.dart';

/// مزوّد اللغة - يوفّر النصوص الحالية ووظيفة تغيير اللغة
class LocaleProvider extends InheritedWidget {
  final AppStrings strings;
  final void Function(bool isArabic) setLocale;

  const LocaleProvider({
    super.key,
    required this.strings,
    required this.setLocale,
    required super.child,
  });

  static AppStrings of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<LocaleProvider>();
    return provider!.strings;
  }

  static LocaleProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleProvider>();
  }

  @override
  bool updateShouldNotify(covariant LocaleProvider oldWidget) {
    return oldWidget.strings.isArabic != strings.isArabic;
  }
}
