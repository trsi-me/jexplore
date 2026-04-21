import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/locale_provider.dart';
import '../widgets/app_logo.dart';
import 'preferences_screen.dart';
import 'duration_screen.dart';

/// لوحة التحكم والإعدادات - إعادة التخطيط وتعديل الاهتمامات
class ControlPanelScreen extends StatelessWidget {
  final List<String> currentInterests;
  final int currentDays;
  final Function(List<String>, int) onReplan;

  const ControlPanelScreen({
    super.key,
    required this.currentInterests,
    required this.currentDays,
    required this.onReplan,
  });

  @override
  Widget build(BuildContext context) {
    final s = LocaleProvider.of(context);
    final provider = LocaleProvider.maybeOf(context)!;

    return Scaffold(
      body: Container(
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
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                    ),
                    const Expanded(
                      child: AppLogo(height: 40, colorFilter: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s.settings,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 20,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          s.editItinerary,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          s.editItineraryDesc,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                        ),
                        const SizedBox(height: 32),
                        _OptionCard(
                          icon: Icons.interests_rounded,
                          title: s.editInterests,
                          subtitle: s.editInterestsDesc,
                          onTap: () => _openPreferences(context),
                        ),
                        const SizedBox(height: 14),
                        _OptionCard(
                          icon: Icons.calendar_month_rounded,
                          title: s.changeDays,
                          subtitle: s.changeDaysDesc,
                          onTap: () => _openDuration(context),
                        ),
                        const SizedBox(height: 14),
                        _LanguageCard(
                          isArabic: s.isArabic,
                          onSelectArabic: () => provider.setLocale(true),
                          onSelectEnglish: () => provider.setLocale(false),
                        ),
                        const SizedBox(height: 28),
                        FilledButton.icon(
                          onPressed: () => _openFullReplan(context),
                          icon: const Icon(Icons.refresh_rounded, size: 24),
                          label: Text(s.replanFromStart),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            backgroundColor: AppColors.secondaryTeal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPreferences(BuildContext context) async {
    final interests = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (ctx) => PreferencesScreen(
          initialInterests: currentInterests,
          onComplete: (i) => Navigator.pop(ctx, i),
        ),
      ),
    );
    if (interests != null && context.mounted) {
      onReplan(interests, currentDays);
      Navigator.pop(context);
    }
  }

  void _openDuration(BuildContext context) async {
    final days = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (ctx) => DurationScreen(
          interests: currentInterests,
          onConfirm: (d) => Navigator.pop(ctx, d),
        ),
      ),
    );
    if (days != null && context.mounted) {
      onReplan(currentInterests, days);
      Navigator.pop(context);
    }
  }

  void _openFullReplan(BuildContext context) async {
    final interests = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (ctx) => PreferencesScreen(
          initialInterests: null,
          onComplete: (i) => Navigator.pop(ctx, i),
        ),
      ),
    );
    if (interests == null || !context.mounted) return;

    final days = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (ctx) => DurationScreen(
          interests: interests,
          onConfirm: (d) => Navigator.pop(ctx, d),
        ),
      ),
    );
    if (days != null && context.mounted) {
      Navigator.popUntil(context, (r) => r.isFirst);
      onReplan(interests, days);
    }
  }
}

class _LanguageCard extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onSelectArabic;
  final VoidCallback onSelectEnglish;

  const _LanguageCard({
    required this.isArabic,
    required this.onSelectArabic,
    required this.onSelectEnglish,
  });

  @override
  Widget build(BuildContext context) {
    final s = LocaleProvider.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryBlue.withValues(alpha: 0.15),
                          AppColors.secondaryTeal.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.language_rounded,
                      color: AppColors.primaryBlue,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Text(
                    s.language,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: isArabic ? null : onSelectArabic,
                      style: FilledButton.styleFrom(
                        backgroundColor: isArabic
                            ? AppColors.primaryBlue.withValues(alpha: 0.2)
                            : null,
                        foregroundColor: isArabic
                            ? AppColors.primaryBlue
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(s.arabic),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: isArabic ? onSelectEnglish : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: !isArabic
                            ? AppColors.primaryBlue.withValues(alpha: 0.2)
                            : null,
                        foregroundColor: !isArabic
                            ? AppColors.primaryBlue
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(s.english),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlue.withValues(alpha: 0.15),
                      AppColors.secondaryTeal.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.primaryBlue, size: 26),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
