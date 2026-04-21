import 'package:flutter/material.dart';

import '../l10n/locale_provider.dart';
import '../l10n/locale_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';

/// شاشة اختيار اللغة بعد شاشة الافتتاح (قبل اختيار الاهتمامات).
class LanguageGateScreen extends StatefulWidget {
  const LanguageGateScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<LanguageGateScreen> createState() => _LanguageGateScreenState();
}

class _LanguageGateScreenState extends State<LanguageGateScreen> {
  late bool _arabic;
  bool _seededFromProvider = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seededFromProvider) return;
    _arabic = LocaleProvider.of(context).isArabic;
    _seededFromProvider = true;
  }

  Future<void> _continue() async {
    final provider = LocaleProvider.maybeOf(context);
    provider?.setLocale(_arabic);
    await saveLanguageGateCompleted();
    if (mounted) widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final s = LocaleProvider.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBlue,
              Color(0xFF1A56B8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const AppLogo(height: 64, colorFilter: Colors.white),
                const SizedBox(height: 28),
                Text(
                  s.chooseLanguageTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  s.chooseLanguageHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                ),
                const SizedBox(height: 36),
                _LangCard(
                  label: s.arabic,
                  selected: _arabic,
                  onTap: () => setState(() => _arabic = true),
                ),
                const SizedBox(height: 14),
                _LangCard(
                  label: s.english,
                  selected: !_arabic,
                  onTap: () => setState(() => _arabic = false),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _continue,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      s.continueBtn,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangCard extends StatelessWidget {
  const _LangCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? Colors.white : Colors.white.withValues(alpha: 0.35),
              width: selected ? 2.5 : 1.5,
            ),
            color: selected
                ? Colors.white.withValues(alpha: 0.22)
                : Colors.white.withValues(alpha: 0.08),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: Colors.white,
                size: 26,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
