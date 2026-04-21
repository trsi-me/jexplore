import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/locale_provider.dart';
import '../widgets/app_logo.dart';
import '../widgets/place_map.dart';
import '../widgets/place_detail_sheet.dart';
import '../widgets/tips_card.dart';
import '../l10n/place_translations.dart';
import '../models/day_plan.dart';
import '../models/place.dart';

/// شاشة عرض خطة الرحلة
class ItineraryScreen extends StatefulWidget {
  final List<DayPlan> plans;
  final VoidCallback onOpenControlPanel;

  const ItineraryScreen({
    super.key,
    required this.plans,
    required this.onOpenControlPanel,
  });

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  int _selectedDayIndex = 0;
  int? _selectedPlaceIndex;

  @override
  Widget build(BuildContext context) {
    final s = LocaleProvider.of(context);
    final plan = widget.plans[_selectedDayIndex];

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppLogo(height: 36, colorFilter: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          s.yourItinerary,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                      child: IconButton(
                        icon: const Icon(Icons.settings_rounded),
                        color: Colors.white,
                        onPressed: widget.onOpenControlPanel,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      widget.plans.length,
                      (i) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _DayChip(
                          label: '${s.dayNum} ${widget.plans[i].dayNumber}',
                          isSelected: i == _selectedDayIndex,
                          onTap: () =>
                              setState(() => _selectedDayIndex = i),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: PlaceMap(
                          places: plan.places,
                          selectedIndex: _selectedPlaceIndex,
                          onPlaceSelected: (i) =>
                              setState(() => _selectedPlaceIndex = i),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          itemCount: plan.places.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return TipsCard(dayNumber: plan.dayNumber);
                            }
                            if (index == 1) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Icon(Icons.route_rounded,
                                        size: 20, color: AppColors.primaryBlue),
                                    const SizedBox(width: 8),
                                    Text(
                                      s.placesOfDay,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppColors.primaryBlue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(
                                  milliseconds: 300 + (index - 2) * 80),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 24 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: _PlaceCard(
                                place: plan.places[index - 2],
                                index: index - 2,
                                isSelected:
                                    _selectedPlaceIndex == index - 2,
                                onTap: () {
                                  setState(() => _selectedPlaceIndex = index - 2);
                                  showPlaceDetailSheet(
                                    context,
                                    plan.places[index - 2],
                                    index - 2,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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

class _DayChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primaryBlue : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final Place place;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlaceCard({
    required this.place,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = LocaleProvider.of(context);
    final displayName = PlaceTranslations.name(place.name, isArabic: s.isArabic);
    final displayCategory = s.categoryKey(place.category);
    final displayDesc = PlaceTranslations.description(place.name, isArabic: s.isArabic) ?? place.description;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? Border.all(color: AppColors.primaryBlue, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.secondaryTeal.withValues(alpha: 0.2),
                          AppColors.primaryBlue.withValues(alpha: 0.12),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          _categoryIcon(place.category),
                          size: 36,
                          color: AppColors.secondaryTeal,
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryBlue,
                                  AppColors.secondaryTeal,
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                        ),
                        if (displayDesc != null && displayDesc.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            displayDesc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryTeal
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                displayCategory,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.secondaryTeal,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            if (place.distanceToNext != null) ...[
                              const SizedBox(width: 12),
                              Icon(
                                Icons.near_me_rounded,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${place.distanceToNext!.toStringAsFixed(1)} ${s.km}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
}
