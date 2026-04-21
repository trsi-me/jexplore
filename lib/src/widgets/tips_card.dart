import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/locale_provider.dart';

/// بطاقة نصائح عامة لرحلة جدة
class TipsCard extends StatelessWidget {
  final int dayNumber;

  const TipsCard({super.key, required this.dayNumber});

  @override
  Widget build(BuildContext context) {
    final s = LocaleProvider.of(context);
    final tips = s.generalTips;
    final tipIndex = (dayNumber - 1) % tips.length;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondaryTeal.withValues(alpha: 0.15),
              AppColors.primaryBlue.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.secondaryTeal.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondaryTeal.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lightbulb_rounded,
                color: AppColors.secondaryTeal,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.tipOfDay,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.secondaryTeal,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tips[tipIndex],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
