import 'package:flutter/material.dart';
import '../models/place.dart';
import '../theme/app_theme.dart';
import '../l10n/locale_provider.dart';
import '../l10n/place_translations.dart';

/// ورقة تفاصيل المكان مع النصائح والوصول
void showPlaceDetailSheet(BuildContext context, Place place, int index) {
  final s = LocaleProvider.of(context);
  final isArabic = s.isArabic;

  final displayName = PlaceTranslations.name(place.name, isArabic: isArabic);
  final displayDesc = PlaceTranslations.description(place.name, isArabic: isArabic) ?? place.description;
  final displayAddress = PlaceTranslations.address(place.name, isArabic: isArabic) ?? place.address;
  final displayHours = PlaceTranslations.openingHours(place.name, isArabic: isArabic) ?? place.openingHours;
  final displayTips = PlaceTranslations.tips(place.name, isArabic: isArabic) ?? place.tips;
  final displayCategory = s.categoryKey(place.category);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryBlue.withValues(alpha: 0.2),
                        AppColors.secondaryTeal.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _categoryIcon(place.category),
                    size: 28,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryTeal.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          displayCategory,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.secondaryTeal,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (displayDesc != null && displayDesc.isNotEmpty) ...[
              _SectionTitle(title: s.description),
              const SizedBox(height: 8),
              Text(
                displayDesc,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 20),
            ],
            if (displayAddress != null && displayAddress.isNotEmpty) ...[
              _SectionTitle(title: s.location),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 20, color: AppColors.secondaryTeal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      displayAddress,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            if (displayHours != null && displayHours.isNotEmpty) ...[
              _SectionTitle(title: s.openingHours),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 20, color: AppColors.secondaryTeal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      displayHours,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            if (displayTips != null && displayTips.isNotEmpty) ...[
              _SectionTitle(
                title: s.visitorTips,
                icon: Icons.lightbulb_rounded,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryTeal.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.secondaryTeal.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  displayTips,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.7,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ],
            if (place.distanceToNext != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.directions_walk_rounded,
                        color: AppColors.primaryBlue),
                    const SizedBox(width: 12),
                    Text(
                      '${s.distanceToNext} ${place.distanceToNext!.toStringAsFixed(1)} ${s.km}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.primaryBlue,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, this.icon = Icons.info_outline_rounded});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryBlue),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

IconData _categoryIcon(String category) {
  switch (category) {
    case 'مطاعم':
      return Icons.restaurant_rounded;
    case 'فنادق':
      return Icons.hotel_rounded;
    case 'معالم سياحية':
      return Icons.place_rounded;
    case 'فعاليات':
      return Icons.event_rounded;
    case 'أماكن ترفيهية':
      return Icons.theater_comedy_rounded;
    case 'طبيعة':
      return Icons.nature_people_rounded;
    case 'تسوق':
      return Icons.shopping_bag_rounded;
    default:
      return Icons.place_rounded;
  }
}
