import 'dart:math';
import '../data/places_data_source.dart';
import '../models/place.dart';
import '../models/day_plan.dart';

/// خدمة بناء جدول الرحلة الذكي
/// يستخدم SQLite على الموبايل وبيانات مضمّنة على الويب
class ItineraryService {
  final PlacesDataSource _dataSource = getPlacesDataSource();

  static const _categoryOrder = [
    'فنادق',
    'معالم سياحية',
    'مطاعم',
    'أماكن ترفيهية',
    'تسوق',
    'طبيعة',
    'فعاليات',
  ];

  /// حساب المسافة بين نقطتين بالكيلومتر (Haversine)
  double _haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // نصف قطر الأرض بالكيلومتر
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRad(double deg) => deg * pi / 180;

  Future<List<DayPlan>> buildItinerary({
    required List<String> interests,
    required int daysCount,
  }) async {
    if (interests.isEmpty || daysCount < 1) return [];

    final allPlaces = await _dataSource.getPlacesByCategories(interests);
    if (allPlaces.isEmpty) return [];

    final byCategory = <String, List<Place>>{};
    for (final p in allPlaces) {
      byCategory.putIfAbsent(p.category, () => []).add(p);
    }

    final random = Random(42);
    final usedPlaceIds = <int>{};
    final plans = <DayPlan>[];

    for (var day = 1; day <= daysCount; day++) {
      final dayPlaces = <Place>[];
      Place? prevPlace;

      for (final cat in _categoryOrder) {
        if (!interests.contains(cat)) continue;

        var list = byCategory[cat];
        if (list == null || list.isEmpty) continue;

        list = list.where((p) => !usedPlaceIds.contains(p.id)).toList();
        if (list.isEmpty) continue;

        Place place;
        final prev = prevPlace;
        if (prev != null && prev.hasCoordinates) {
          place = list.reduce((a, b) {
            if (!a.hasCoordinates) return b;
            if (!b.hasCoordinates) return a;
            final pLat = prev.latitude ?? 0.0;
            final pLng = prev.longitude ?? 0.0;
            final aLat = a.latitude ?? 0.0;
            final aLng = a.longitude ?? 0.0;
            final bLat = b.latitude ?? 0.0;
            final bLng = b.longitude ?? 0.0;
            final distA = _haversineDistance(pLat, pLng, aLat, aLng);
            final distB = _haversineDistance(pLat, pLng, bLat, bLng);
            return distA <= distB ? a : b;
          });
        } else {
          place = list[random.nextInt(list.length)];
        }

        usedPlaceIds.add(place.id);

        double? distanceToNext;
        if (prev != null &&
            place.hasCoordinates &&
            prev.hasCoordinates) {
          final pLat = prev.latitude ?? 0.0;
          final pLng = prev.longitude ?? 0.0;
          final plLat = place.latitude ?? 0.0;
          final plLng = place.longitude ?? 0.0;
          distanceToNext = _haversineDistance(pLat, pLng, plLat, plLng);
        }

        dayPlaces.add(place.copyWith(distanceToNext: distanceToNext));
        prevPlace = place;
      }

      if (dayPlaces.isNotEmpty) {
        plans.add(DayPlan(dayNumber: day, places: dayPlaces));
      }
    }

    return plans;
  }
}
